//
//  Poll.swift
//  App
//
//  Created by Yun Ao on 2018/7/4.
//

import Foundation
import Vapor
import FluentSQLite


struct Poll: Content {
    var id: UUID?
    var title: String
    var option1: String
    var option2: String
    var votes1: Int
    var votes2: Int
}

extension Poll: SQLiteUUIDModel {}
extension Poll: Migration {}

