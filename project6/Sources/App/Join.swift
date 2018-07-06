//
//  Join.swift
//  App
//
//  Created by Yun Ao on 2018/7/6.
//

import Foundation
import Async
import Leaf


public final class JoinTag: TagRenderer {
    public func render(tag: TagContext) throws -> EventLoopFuture<TemplateData> {
        try tag.requireParameterCount(2)
        return Future.map(on: tag.container) {
            if let array = tag.parameters[0].array,
                let separator = tag.parameters[1].string {
                let items = array.compactMap { $0.string }
                return .string(items.joined(separator: separator))
            } else {
                return .null
            }
        }
    }
}
