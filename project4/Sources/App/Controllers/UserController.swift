//
//  UserController.swift
//  project4
//
//  Created by Yun Ao on 2018/7/4.
//

import Foundation
import Vapor
import FluentSQLite
import Crypto


public final class UserController: RouteCollection {
    
    public func boot(router: Router) throws {
        
        let usersGroup = router.grouped("users")
        
        usersGroup.get("create", use: createPage)
        usersGroup.post("create", use: create)
        usersGroup.get("login", use: loginPage)
        usersGroup.post(User.self, at: "login", use: login)
    }
    
    public func createPage(_ req: Request) throws -> Future<View>{
        return try req.view().render("users-create")
    }
    
    public func create(_ req: Request) throws -> Future<View> {
        var user = try req.content.syncDecode(User.self)
        return User.query(on: req)
            .filter(\.username == user.username)
            .first()
            .flatMap(to: View.self, { (existing)  in
                if existing == nil {
                    user.password = try BCrypt.hash(user.password)
                    return user.save(on: req).flatMap(to: View.self, { (user) in
                        return try req.view().render("users-welcome")
                    })
                } else {
                    let context = ["error": "true"]
                    return try req.view().render("user-create", context)
                }
            })
    }
    
    public func loginPage(_ req: Request) throws -> Future<View> {
        return try req.view().render("users-login")
    }
    
    public func login(_ req: Request, _ user: User) throws -> Future<View> {
        return User.query(on: req)
            .filter(\.username == user.username)
            .first()
            .flatMap(to: View.self, { (existingUser) in
                if let existingUser = existingUser {
                    if try BCrypt.verify(user.password, created: existingUser.password) {
                        let session = try req.session()
                        session["username"] = existingUser.username
                        return try req.view().render("users-welcome")
                    }
                }
                
                let context = ["error": "true"]
                return try req.view().render("users-login", context)
            })
    }
}
