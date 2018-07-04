//
//  User.swift
//  project4
//
//  Created by Yun Ao on 2018/7/4.
//

import Foundation
import FluentSQLite
import Vapor

struct User: Content {
    var id: Int?
    var username: String
    var password: String
}

extension User: SQLiteModel {}
extension User: Migration {}
