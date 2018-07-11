//
//  LinkTag.swift
//  App
//
//  Created by Yun Ao on 2018/7/11.
//

import Foundation
import Vapor
import Leaf

public final class LinkTag: TagRenderer {
    public func render(tag: TagContext) throws -> EventLoopFuture<TemplateData> {
        try tag.requireParameterCount(1)
        
        return Future.map(on: tag.container, {
            if let dict = tag.parameters[0].dictionary,
                let id = dict["id"]?.string,
                let slug = dict["slug"]?.string {
                return .string("/read/\(id)/\(slug)")
            } else {
                return .null
            }
        })
    }
}
