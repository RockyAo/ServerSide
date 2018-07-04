//
//  Article.swift
//  App
//
//  Created by Yun Ao on 2018/7/4.
//

import Foundation
import Vapor

struct Article: Content {
    
    var id: Int
    var title: String
    
    init(id: String) {
        if let intId = Int(id) {
            self.id = intId
            self.title = "Custom Parameters rock!"
        } else {
            self.id = 0
            self.title = "Unknown article"
        }
    }
}

extension Article: Parameter {
    
    typealias ResolvedParameter = Article
    
    static func resolveParameter(_ parameter: String, on container: Container) throws -> Article {
        return Article(id: parameter)
    }
}


