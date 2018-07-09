import Vapor
import FluentSQLite
import Crypto
import Leaf
import Authentication


/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.get("setup") { (req) -> String in
        let password = try BCrypt.hash("password")
        let item1 = User(id: 1, username: "test1", password: password, language: "Swift")
        let item2 = User(id: 1, username: "test2", password: password, language: "Swift")
        
        _ = item1.create(on: req)
        _ = item2.create(on: req)
        
        print("setup data ok")
        
        return "OK"
    }
    
    router.get { (req) -> Future<View> in
        return try req.view().render("home")
    }
    
    router.post("users", "login") { (req) -> Future<View> in
        let user = try req.content.syncDecode(User.self)
        
        return User.query(on: req)
            .filter(\.username == user.username)
            .first()
            .flatMap(to: View.self, { (existingUser)  in
                if let existingUser = existingUser {
                    if try BCrypt.verify(user.password, created: existingUser.password) {
                        return try req.view().render("users-welcome")
                    }
                }
                let context = ["error": "true"]
                return try req.view().render("users-login", context)
            })
    }
    
    router.get("login") { (req) -> Future<View> in
        return try req.view().render("login")
    }
    
    router.post("login") { (req) -> Future<AnyResponse> in
        let username: String = try req.content.syncGet(at: "username")
        let password: String = try req.content.syncGet(at: "password")
        
        let authenticationPassword = BasicAuthorization(username: username, password: password)
        
        return User.authenticate(using: authenticationPassword, verifier: BCryptDigest(), on: req)
            .map(to: AnyResponse.self, { (user)  in
                if let user = user {
                    let session = try req.session()
                    session["user_id"] = String(user.id!)
                    session["username"] = user.username
                    let redirect = req.redirect(to: "/projects/mine")
                    return AnyResponse(redirect)
                } else {
                    let context = ["error": true]
                    let page = try req.view().render("login", context)
                    return AnyResponse(page)
                }
            })
    }
    
    try router.register(collection: ProjectController())
}

