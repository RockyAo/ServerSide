//
//  ProjectController.swift
//  App
//
//  Created by Yun Ao on 2018/7/9.
//

import Foundation
import Vapor
import FluentSQLite
import Leaf


struct ProjectController: RouteCollection {
    
    private struct ProjectList: Codable {
        var projects: [Project]
        var activePage: String
    }
    
    func boot(router: Router) throws {
        let projectRouter = router.grouped("projects")
        projectRouter.get("mine", use: projectMinePage)
        projectRouter.post("delete",Int.parameter, use: projectDelete)
        projectRouter.get("new", use: projectNewPage)
        projectRouter.post("new", use: projectNew)
        projectRouter.get("all", use: allProject)
        projectRouter.get("search", use: projectSearch)
    }
    
    private func session(query: String, on request: Request) throws -> String {
        let session = try request.session()
        guard let message = session[query] else {
            throw Abort(.unauthorized)
        }
        return message
    }
    
    private func sessionIsExisit(_ query: String, on request: Request) throws -> Bool {
        let session = try request.session()
        guard session[query] != nil else {
            return false
        }
        return true
    }
}



extension ProjectController {
    
    private func projectMinePage(_ req: Request) throws -> Future<View> {
        let session = try req.session()
        guard let userID = session["user_id"] else {
            throw Abort(.unauthorized)
        }
        
        return Project.query(on: req)
            .filter(\.owner == Int(userID) ?? 0)
            .all()
            .flatMap(to: View.self, { (projects) in
                let context = ProjectList(projects: projects, activePage: "page_projects_mine")
                return try req.view().render("projects_mine", context)
            })
    }
    
    private func projectDelete(_ req: Request) throws -> Future<Response> {
        let userID = try session(query: "user_id", on: req)
        let id = try req.parameters.next(Int.self)
        return Project.query(on: req)
            .filter(\.id == id)
            .filter(\.owner == Int(userID) ?? 0)
            .delete()
            .map({ () -> Response in
                return req.redirect(to: "/projects/mine")
            })
    }
    
    private func projectNewPage(_ req: Request) throws -> Future<View> {
        if try sessionIsExisit("user_id", on: req) == false {
            throw Abort(.unauthorized)
        }
        return try req.view().render("projects_new", ["activePage": "page_projects_new"])
    }
    
    private func projectNew(_ req: Request) throws -> Future<Response> {
        let userID = try session(query: "user_id", on: req)
        
        let name: String = try req.content.syncGet(at: "name")
        let desctiption: String = try req.content.syncGet(at: "description")
        let language: String = try req.content.syncGet(at: "language")
        
        let project = Project(id: nil, owner: Int(userID) ?? 0, name: name, language: language, description: desctiption, date: Date())
        
        return project.save(on: req).map({ (project) -> Response in
            return req.redirect(to: "/projects/mine")
        })
    }
    
    private func allProject(_ req: Request) throws -> Future<View> {
        if try sessionIsExisit("user_id", on: req) == false {
            throw Abort(.unauthorized)
        }
        return Project.query(on: req)
            .all()
            .flatMap({ (projects) -> Future<View> in
                let context = ProjectList(projects: projects, activePage: "page_projects_all")
                return try req.view().render("projects_all", context)
            })
    }
    
    private func projectSearch(_ req: Request) throws -> Future<View> {
        struct ProjectSearch: Codable {
            var projects: [Project]
            var users: [User]
            var activePage: String
        }
        
        if try sessionIsExisit("user_id", on: req) == false {
            throw Abort(.unauthorized)
        }
        
        if let language: String = try req.query.get(at: "lanuage") {
            return Project.query(on: req)
                .filter(\.language == language)
                .all()
                .flatMap({ (projects) -> EventLoopFuture<View> in
                    return User.query(on: req)
                        .filter(\.language == language)
                        .all()
                        .flatMap({ (users) -> EventLoopFuture<View> in
                            let context = ProjectSearch(projects: projects, users: users, activePage: "page_projects_search")
                            return try req.view().render("projects_search", context)
                        })
                })
        } else {
            let context = ProjectSearch(projects: [], users: [], activePage: "page_project_search")
            return try req.view().render("projects_search", context)
        }
    }
}
