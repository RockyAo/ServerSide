//
//  MarkdownTag.swift
//  App
//
//  Created by Yun Ao on 2018/7/11.
//

import Foundation
import Leaf
import Vapor
import Markdown

public final class MarkdownTag: TagRenderer {
    public func render(tag: TagContext) throws -> EventLoopFuture<TemplateData> {
        try tag.requireParameterCount(1)
        
        return Future.map(on: tag.container, {
            
            if let str = tag.parameters[0].string {
                let trimmed = str.replacingOccurrences(of: "\r\n", with: "\n")
                let md = try Markdown(string: trimmed)
                let doc = try md.document()
                return .string(doc)
            }
            
            return .null
        })
    }
}
