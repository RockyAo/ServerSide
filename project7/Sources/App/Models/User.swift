//
//  User.swift
//  App
//
//  Created by Yun Ao on 2018/7/6.
//

import Foundation
import FluentSQLite
import Vapor

struct User: Content, SQLiteStringModel, Migration {
    var id: String?
    var password: String
}


