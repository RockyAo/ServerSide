import Vapor
import Leaf

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get { req -> Future<View> in
        
        return try req.view().render("home")
    }
    
    router.get("path","to","staff") { (req) in
        return "Meet our great team"
    }
    
    router.get("staff", String.parameter) { (req) -> Future<View> in
        
        let name = try req.parameters.next(String.self)
        
        let bios = [
            "kirk": "My name is James Kirk and I love snakes.",
            "picard": "My name is Jean-Luc Picard and I'm mad for fish.",
            "sisko": "My name is Benjamin Sisko and I'm all about the budgies.",
            "janeway": "My name is Kathryn Janeway and I want to hug every hamster.",
            "archer": "My name is Jonathan Archer and beagles are my thing."
        ]
        
        struct StaffView: Codable {
            var name: String?
            var bio: String?
            var allNames: [String]
        }
        
        let context: StaffView
        
        if let bio = bios[name] {
            context = StaffView(name: name, bio: bio, allNames: bios.keys.sorted())
        } else {
            context = StaffView(name: nil, bio: nil, allNames: bios.keys.sorted())
        }
        
        return try req.view().render("staff", context)
    }
    
    router.get("contact") { (req) -> Future<View> in
       return try req.view().render("contact")
    }
}
