import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
    
    router.get("greetings", String.parameter) { (req) -> String in
        let name = try req.parameters.next(String.self)
        return "Greetings, \(name)!"
    }
    
    router.get("read",Int.parameter) { (req) -> String in
        let number = try req.parameters.next(Int.self)
        return "Chapter \(number)..."
    }
    
    router.get("posts",Int.parameter, String.parameter) { (req) -> String in
        let id = try req.parameters.next(Int.self)
        let title = try req.parameters.next(String.self)
        
        return "Loading article \(id) with title \(title)"
    }
    
    router.get("articles",Article.parameter) { (req) -> Article in
       return try req.parameters.next(Article.self)
    }
    
    groupRoutesExampleA(router)
    groupRoutesExampleB(router)
    
    try collectionExample(router)
}

// Group route example
private func groupRoutesExampleA(_ router: Router) {
    router.group("hello") { (route) in
        route.get("world", use: { (req)  in
            return "Hello world!"
        })
        
        route.get("Kitty", use: { (req)  in
            return "Hello Kitty"
        })
    }
}

private func groupRoutesExampleB(_ router: Router) {
    let articleRouter = router.grouped("article", Int.parameter)
    
    articleRouter.get("read") { (req) -> String in
        let num = try req.parameters.next(Int.self)
        return "Reading article \(num)"
    }
    
    articleRouter.get("edit") { (req) -> String in
        let num = try req.parameters.next(Int.self)
        return "Editing article \(num)"
    }
}

// Route collections

final class AdminCollection: RouteCollection {
    func boot(router: Router) throws {
        let article = router.grouped("article", Int.parameter)
        
        article.get("read") { req -> String in
            let num = try req.parameters.next(Int.self)
            return "Reading article \(num)"
        }
        
        article.get("edit") { req -> String in
            let num = try req.parameters.next(Int.self)
            return "Editing article \(num)"
        }
    }
}

private func collectionExample(_ router: Router) throws {
    try router.register(collection: AdminCollection())
}


