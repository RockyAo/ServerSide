import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    
    router.post(Poll.self, at:"polls","create") { (req, poll) -> Future<Poll> in
        return poll.save(on: req)
    }
    
    router.get("polls","list") { (req) -> Future<[Poll]> in
        
        return Poll.query(on: req).all()
    }
    
    router.post("polls", "vote", UUID.parameter, Int.parameter) { (req) -> Future<Poll> in
        let id = try req.parameters.next(UUID.self)
        let vote = try req.parameters.next(Int.self)
        return Poll.find(id, on: req).flatMap({ (poll) -> EventLoopFuture<Poll> in
            guard var poll = poll else {
                throw Abort(.notFound)
            }
            vote == 1 ? (poll.votes1 += 1) : (poll.votes2 += 1)
            return poll.save(on: req)
        })
    }
    
    router.get("polls",UUID.parameter) { (req) -> Future<Poll> in
        
        let uuid = try req.parameters.next(UUID.self)
        return Poll.find(uuid, on: req).map({ (poll) in
            guard let poll = poll else {
                throw Abort(.notFound)
            }
            
            return poll
        })
    }
    
    router.post("polls",UUID.parameter,"delete") { (req) -> Future<HTTPStatus> in
        let uuid = try req.parameters.next(UUID.self)
        return Poll.find(uuid, on: req).flatMap({ (poll) in
            if let poll = poll {
                return poll.delete(on: req).map { .ok }
            } else {
                throw Abort(.notFound)
            }
        })
    }
}
