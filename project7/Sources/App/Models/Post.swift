//
//  Post.swift
//  App
//
//  Created by Yun Ao on 2018/7/6.
//

import Foundation
import Vapor
import FluentSQLite
import Validation



struct Post: Content, SQLiteModel, Migration {
    var id: Int?
    var username: String
    var message: String
    var parent: Int
    var date: Date
}

extension Post: Validatable {
    static func validations() throws -> Validations<Post> {
        var validations = Validations(Post.self)
        try validations.add(\.username, .count(1...) && .alphanumeric)
        try validations.add(\.message, .count(2...))
        try validations.add(\.parent, .range(0...))
        return validations
    }
}
