//
//  Post.swift
//  App
//
//  Created by Yun Ao on 2018/7/10.
//

import Foundation
import FluentMySQL
import Vapor

struct Post: Content, MySQLModel {
    var id: Int?
    var title: String
    var strap: String
    var content: String
    var category: Int
    var slug: String
    var date: Date
}

extension Post: Migration {
    
    static func prepare(on conn: MySQLConnection) -> Future<Void> {
        return MySQLDatabase.create(self, on: conn, closure: { (builder) in
            builder.field(for: \.id)
            builder.field(for: \.title)
            builder.field(for: \.strap)
            builder.field(for: \.content, type: .text())
            builder.field(for: \.category)
            builder.field(for: \.slug)
            builder.field(for: \.date)
        })
    }
}
