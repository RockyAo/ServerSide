import Vapor
import FluentSQLite

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    router.post(User.self, at: "create") { (req, user) -> Future<User> in
        guard let id = user.id else { throw Abort(.badRequest) }
        return User.find(id, on: req)
            .flatMap(to: User.self, { (existingUser) in
                guard existingUser == nil else {
                    throw Abort(.badRequest)
                }
                return user.create(on: req).map { $0 }
            })
    }
    
    router.post("login") { (req) -> Future<Token> in
        let username: String = try req.content.syncGet(at: "id")
        let password: String = try req.content.syncGet(at: "password")
        
        guard username.count > 0, password.count > 0 else { throw Abort(.badRequest) }
        
        return User.find(username, on: req)
            .flatMap(to: Token.self, { (user) in
                _ = Token.query(on: req).filter(\.expiry < Date()).delete()
                
                guard let user = user else {
                    throw Abort(.notFound)
                }
                
                guard user.password == password else {
                    throw Abort(.unauthorized)
                }
                
                let newToken = Token(id: nil, username: username, expiry: Date().addingTimeInterval(86400))
                return newToken.create(on: req).map { $0 }
            })
    }
    
    router.post("post") { (req) -> Future<Post> in
        let token: UUID = try req.content.syncGet(at: "token")
        let message: String = try req.content.syncGet(at: "message")
        
        guard message.count > 0 else {
            throw Abort(.badRequest)
        }
        let reply: Int = (try? req.content.syncGet(at: "reply")) ?? 0
        return Token.find(token, on: req)
            .flatMap(to: Post.self, { (token) in
                guard let token = token else { throw Abort(.unauthorized) }
                let post = Post(id: nil, username: token.username, message: message, parent: reply, date: Date())
                try post.validate()
                return post.create(on: req).map { $0 }
            })
    }
    
    router.get(String.parameter,"posts") { (req) -> Future<[Post]> in
        let username = try req.parameters.next(String.self)
        return Post.query(on: req).filter(\Post.username == username).all()
    }
    
    router.get("search") { (req) -> Future<[Post]> in
        let query = try req.query.get(String.self, at: ["query"])
        return Post.query(on: req).filter(\.message ~~ query).all()
    }
}
