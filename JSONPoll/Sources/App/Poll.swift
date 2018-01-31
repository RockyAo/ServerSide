//
//  Poll.swift
//  App
//
//  Created by Rocky on 2018/1/14.
//

import Foundation
import Vapor
import Fluent
import FluentSQLite


final class Poll : Content {
    
    var id: UUID?
    var title: String
    var option1: String
    var option2: String
    var votes1: Int
    var votes2: Int
    
    init(id: UUID?, title: String, option1: String, option2: String, votes1: Int, votes2: Int) {
        self.id = id
        self.title = title
        self.option1 = option1
        self.option2 = option2
        self.votes1 = votes1
        self.votes2 = votes2
    }
    
    
}

extension Poll : Model, Migration {
    
    static var idKey: ReferenceWritableKeyPath<Poll, UUID?> {
        return \.id
    }
    
    typealias Database = SQLiteDatabase
    
    typealias ID = UUID
}
