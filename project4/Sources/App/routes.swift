import Vapor
import Leaf
import FluentSQLite
import Crypto

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    router.get("setup") { (req) -> String in
//        let item1 = Forum(id: 1, name: "Taylor's Songs")
//        let item2 = Forum(id: 2, name: "Taylor's Albums")
//        let item3 = Forum(id: 3, name: "Taylor's Concerts")
        
        let item1 = Message(id: 1, forum: 1, title: "Welcome", body: "Hello!", parent: 0, user: "twostraws", date: Date())
        let item2 = Message(id: 2, forum: 1, title: "Second post", body: "Hello!", parent: 0, user: "twostraws", date: Date())
        let item3 = Message(id: 3, forum: 1, title: "Test reply", body: "Yay!", parent: 1, user: "twostraws", date: Date())

        _ = item1.create(on: req)
        _ = item2.create(on: req)
        _ = item3.create(on: req)
        
        return "OK"
    }
    
    router.get { (req) -> Future<View> in
        struct HomeContext: Codable {
            var username: String?
            var forums: [Forum]
        }
        
        return Forum.query(on: req).all().flatMap({ (forums) -> Future<View> in
            let context = HomeContext(username: getUsername(req), forums: forums)
            return try req.view().render("home", context)
        })
    }
    
    router.get("forum",Int.parameter) { (req) -> Future<View> in
        struct ForumContext: Codable {
            var username: String?
            var forum: Forum
            var messages: [Message]
        }
        
        let forumID = try req.parameters.next(Int.self)
        
        return Forum.find(forumID, on: req).flatMap(to: View.self, { (forum)  in
            guard let forum = forum else { throw Abort(.notFound) }
            
            return Message.query(on: req)
                .filter(\.forum == forum.id!)
                .filter(\.parent == 0)
                .all()
                .flatMap(to: View.self) { messages in
                    let context = ForumContext(username: getUsername(req), forum: forum, messages: messages)
                    return try req.view().render("forum", context)
                }
        })
    }
    
    router.get("forum", Int.parameter, Int.parameter) { (req) -> Future<View> in
        struct MessageContext: Codable {
            var username: String?
            var forum: Forum
            var message: Message
            var replies: [Message]
        }
        
        let forumID = try req.parameters.next(Int.self)
        let messageID = try req.parameters.next(Int.self)
        
        return Forum.find(forumID, on: req)
            .flatMap(to: View.self, { (forum) in
                guard let forum = forum else { throw Abort(.notFound) }
                return Message.find(messageID, on: req)
                    .flatMap(to: View.self, { (message)  in
                        guard let message = message else { throw Abort(.notFound) }
                        return Message.query(on: req)
                            .filter(\.parent == message.id!)
                            .all()
                            .flatMap(to: View.self, { (replies) in
                                let context = MessageContext(username: getUsername(req), forum: forum, message: message, replies: replies)
                                return try req.view().render("message", context)
                            })
                    })
            })
    }
    
   try router.register(collection: UserController())
}

private func getUsername(_ req: Request) -> String? {
    return "Testing"
}
