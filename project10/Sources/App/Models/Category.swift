//
//  Category.swift
//  App
//
//  Created by Yun Ao on 2018/7/10.
//

import Foundation
import FluentMySQL
import Vapor

struct Category: Content, MySQLModel, Migration {
    var id: Int?
    var name: String?
}


