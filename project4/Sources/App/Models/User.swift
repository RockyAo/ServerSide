//
//  User.swift
//  project4
//
//  Created by Yun Ao on 2018/7/4.
//

import Foundation
import FluentSQLite
import Vapor

public struct User: Content {
    public var id: Int?
    public var username: String
    public var password: String
}

extension User: SQLiteModel {}
extension User: Migration {}
