//
//  Token.swift
//  App
//
//  Created by Yun Ao on 2018/7/6.
//

import Foundation
import Vapor
import FluentSQLite

struct Token: Content, SQLiteUUIDModel, Migration {
    var id: UUID?
    var username: String
    var expiry: Date
}
