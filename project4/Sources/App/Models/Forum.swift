//
//  Forum.swift
//  App
//
//  Created by Yun Ao on 2018/7/4.
//

import Foundation
import Vapor
import FluentSQLite

struct Forum: Content {
    var id: Int?
    var name: String
}

extension Forum: SQLiteModel {}
extension Forum: Migration {}
