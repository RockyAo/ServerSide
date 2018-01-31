import Routing
import Vapor
import Leaf
import Foundation

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
final class Routes: RouteCollection {
    /// Use this to create any services you may
    /// need for your routes.
    let app: Application

    /// Create a new Routes collection with
    /// the supplied application.
    init(app: Application) {
        self.app = app
    }

    /// See RouteCollection.boot
    func boot(router: Router) throws {
        router.get("hello") { req in
            return "Hello, world!"
        }
        
        router.get { (req) -> Future<View>  in
            let leaf = try req.make(LeafRenderer.self)
            return leaf.render("home")
        }
        
        router.get("contact") { (req) -> Future<View> in
            let leaf = try req.make(LeafRenderer.self)
            return leaf.render("contact")
        }
        
        router.get("staff",String.parameter) { (req) -> Future<View> in
            
            let name = try req.parameter(String.self)
            
            print(name)
            
            let bios = [
                "kirk": "My name is James Kirk and I love snakes.",
                "picard": "My name is Jean-Luc Picard and I'm mad for fish.",
                "sisko": "My name is Benjamin Sisko and I'm all about the budgies.",
                "janeway": "My name is Kathryn Janeway and I want to hug every hamster.",
                "archer": "My name is Jonathan Archer and beagles are my thing."
            ]
            
            struct Staff:Codable {
                var name:String?
                var bio:String?
                var allNames:[String]
                
            }
            
            var staff:Staff
            
            
            if let bio = bios[name] {
                staff = Staff(name: name, bio: bio, allNames: bios.keys.sorted())
            }else{
                staff = Staff(name: nil, bio: nil, allNames: bios.keys.sorted())
            }
            
            let leaf = try req.make(LeafRenderer.self)
            return leaf.render("staff", staff)
        }
    }
}
