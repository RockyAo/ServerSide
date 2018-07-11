//
//  BackEnd.swift
//  App
//
//  Created by Yun Ao on 2018/7/10.
//

import Foundation
import FluentMySQL
import Vapor

class BackEnd: RouteCollection {
    
    func boot(router: Router) throws {
        let backendRouter = router.grouped("backend")
        backendRouter.get("stories", use: fetchStories)
        backendRouter.get("story",Int.parameter, use: fetchStory)
        backendRouter.get("categories", use: getAllCategories)
        backendRouter.post("story", use: postAdminEdit)
    }
    
    func fetchStories(on req: Request) throws -> Future<[Post]> {
        return Post.query(on: req).sort(\Post.date, .descending).all()
    }
    
    func fetchStory(on req: Request) throws -> Future<Post> {
        let id = try req.parameters.next(Int.self)
        return Post.find(id, on: req).map({ (post) -> Post in
            guard let post = post else { throw Abort(.notFound) }
            return post
        })
    }
    
    func getAllCategories(on req: Request) throws -> Future<[Category]> {
        return Category.query(on: req).all()
    }
    
    func postAdminEdit(on req: Request) throws -> Future<Post> {
        let post = try req.content.syncDecode(Post.self)
        return post.save(on: req)
    }
}
