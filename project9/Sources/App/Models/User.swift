//
//  User.swift
//  App
//
//  Created by Yun Ao on 2018/7/9.
//

import Foundation
import FluentSQLite
import Vapor
import Authentication


struct User: Content, SQLiteModel, Migration {
    var id: Int?
    var username: String
    var password: String
    var language: String
}

extension User: BasicAuthenticatable {
    static var usernameKey: WritableKeyPath<User, String> {
        return \User.username
    }
    
    static var passwordKey: WritableKeyPath<User, String> {
        return \User.password
    }
    
}
