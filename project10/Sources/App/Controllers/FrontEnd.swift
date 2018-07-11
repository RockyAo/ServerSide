//
//  FrontEnd.swift
//  App
//
//  Created by Yun Ao on 2018/7/10.
//

import Foundation
import Leaf
import Markdown
import SwiftSlug
import Vapor

struct CategoryPage: Codable {
    var title: String
    var stories: [Post]
    var categories: [Category]
}

struct StoryPage: Codable {
    var title: String
    var story: Post
    var categories: [Category]
}

class FrontEnd: RouteCollection {
    
    var categories = [Category]()
    
    func boot(router: Router) throws {
        router.get(use: getHomePage)
        router.get("read", Int.parameter , use: getStory)
        
        let adminRouter = router.grouped("admin")
        adminRouter.get(use: getAdminHome)
        adminRouter.get("edit", Int.parameter, use: getAdminEdit)
        adminRouter.get("edit", use: getAdminEdit)
        adminRouter.post("edit", Int.parameter, use: postAdminEdit)
        adminRouter.post("edit", use: postAdminEdit)
    }
    
    func getHomePage(req: Request) throws -> Future<View> {
        return try req.client().get("http://localhost:8080/backend/stories")
            .flatMap({ (response) -> EventLoopFuture<View> in
                let posts = try response.content.syncDecode([Post].self)
                let categories = try self.getCategories(for: req)
                
                return categories.flatMap({ (categories) -> EventLoopFuture<View> in
                    let context = CategoryPage(title: "Top Stories", stories: posts, categories: categories)
                    return try req.view().render("home", context)
                })
            })
    }
    
    func getStory(req: Request) throws -> Future<View> {
        guard let id = try? req.parameters.next(Int.self) else {
            return try req.view().render("error")
        }
        let uri = "http://localhost:8080/backend/story/\(id)"
        return try req.client().get(uri)
            .flatMap({ (response) -> EventLoopFuture<View> in
                if let post = try? response.content.syncDecode(Post.self) {
                    return try self.getCategories(for: req).flatMap({ (categories) -> EventLoopFuture<View> in
                        let context = StoryPage(title: post.title, story: post, categories: categories)
                        return try req.view().render("read", context)
                    })
                }
                
                return try req.view().render("error")
            })
    }
    
    func getCategories(for req: Request) throws -> Future<[Category]> {
        guard self.categories.count == 0 else {
            return Future.map(on: req) { self.categories }
        }
        
        return try req.client().get("http://localhost:8080/backend/categories")
            .flatMap({ (response) -> EventLoopFuture<[Category]> in
                return try response.content.decode([Category].self).map {
                    self.categories = $0
                    return $0
                }
            })
    }
    
    func getAdminHome(req: Request) throws -> Future<View> {
        return try req.client().get("http://localhost/8080/backend/stories")
            .flatMap({ (response) -> EventLoopFuture<View> in
                let posts = try response.content.syncDecode([Post].self)
                return try self.getCategories(for: req)
                    .flatMap({ (categories) -> EventLoopFuture<View> in
                        let context = CategoryPage(title: "Admin", stories: posts, categories: categories)
                        return try req.view().render("admin_home", context)
                    })
            })
    }
    
    func getAdminEdit(req: Request) throws -> Future<View> {
        if let id = try? req.parameters.next(Int.self) {
            let uri = "http://localhost:8080/backend/story/\(id)"
            
            return try req.client().get(uri)
                .flatMap({ (response) -> EventLoopFuture<View> in
                    let post = try response.content.syncDecode(Post.self)
                    return try self.getCategories(for: req)
                        .flatMap({ (categories) -> EventLoopFuture<View> in
                            let context = StoryPage(title: "Article Edit", story: post, categories: categories)
                            return try req.view().render("admin_edit", context)
                        })
                })
        } else {
            let empty = Post(id: nil, title: "", strap: "", content: "", category: 1, slug: "", date: Date())
            return try getCategories(for: req)
                .flatMap({ (categories) -> EventLoopFuture<View> in
                    let context = StoryPage(title: "Create Article", story: empty, categories: categories)
                    return try req.view().render("admin_edit", context)
                })
        }
    }
    
    func postAdminEdit(on req: Request) throws -> Future<Response> {
        let title: String = try req.content.syncGet(at: "title")
        let strap: String = try req.content.syncGet(at: "strap")
        let content: String = try req.content.syncGet(at: "content")
        let category: Int = try req.content.syncGet(at: "category")
        var slug: String = try req.content.syncGet(at: "slug")
        
        slug = slug.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if slug.count == 0 {
            slug = try title.convertedToSlug()
        } else {
            slug = try slug.convertedToSlug()
        }
        
        let id = try? req.parameters.next(Int.self)
        let post = Post(id: id, title: title, strap: strap, content: content, category: category, slug: slug, date: Date())
        
        let uri = "http://localhost:8080/backend/story"
        
        let request = try req.client().post(uri) { postRequest in
            try postRequest.content.encode(post)
        }
        
        return request.map(to: Response.self) { response in
            if response.http.status == .ok {
            return req.redirect(to: "/admin")
            } else {
            return Response(http: HTTPResponse(status: .internalServerError), using: req)
            }
        }
    }
}

