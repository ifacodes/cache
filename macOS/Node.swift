//
//  Node.swift
//  cache (macOS)
//
//  Created by Aoife Bradley on 2022-03-16.
//

import Foundation
import Cocoa
import UniformTypeIdentifiers

enum NodeType: Int, Codable {
    case container
    case document
    case separator
    case unknown
}

/// - Tag: NodeClass
struct Node: Hashable, Identifiable, CustomStringConvertible {
    var id = UUID()
    
    var name: String
    var children: [Node]? = nil
    var type: NodeType = .unknown
    var description: String {
        switch children {
        case nil:
            return "\(name)"
        case .some(let children):
            return children.isEmpty ? "\(name)" : "\(name)"
        }
    }
    
    var isLeaf: Bool {
        return type == .separator
    }

}

