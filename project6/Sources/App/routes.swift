import Vapor
import Leaf

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.get("hello") { (req) -> Future<View> in
        struct ExampleData: Codable {
            let haters = "hating"
            let names = ["Taylor", "Paul", "Justin", "Adele"]
            let results = ["Scott": 90, "Dan": 85, "Liz": 100]
            let quote = "He thrusts his fists against the posts and still insists he sees the ghosts"
        }
        
        return try req.view().render("home", ExampleData())
    }
}
