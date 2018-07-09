//
//  Project.swift
//  App
//
//  Created by Yun Ao on 2018/7/9.
//

import Foundation
import Authentication
import FluentSQLite
import Vapor

struct Project: Content, SQLiteModel, Migration {
    var id: Int?
    var owner: Int
    var name: String
    var language: String
    var description: String
    var date: Date
}
