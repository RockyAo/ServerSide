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
        
        usersGroup.get("create") { (req) -> Future<View> in
            return try req.view().render("users-create")
        }
        
        usersGroup.post("create") { (req) -> Future<View> in
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
        
        usersGroup.get("login") { (req) -> Future<View> in
            return try req.view().render("users-login")
        }
    }
}
