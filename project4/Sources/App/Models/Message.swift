//
//  Message.swift
//  project4
//
//  Created by Yun Ao on 2018/7/4.
//

import Foundation
import Vapor
import FluentSQLite

struct Message: Content {
    var id: Int?
    var forum: Int
    var title: String
    var body: String
    var parent: Int
    var user: String
    var date: Date
}

extension Message: SQLiteModel {}
extension Message: Migration {}
