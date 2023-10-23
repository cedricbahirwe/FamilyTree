//
//  FamilyNode.swift
//  FamilyTree
//
//  Created by Cédric Bahirwe on 23/10/2023.
//

import Foundation

class FamilyNode<T>: Identifiable {
    var value: T
    var children: [FamilyNode] = []
    weak var parent: FamilyNode?
    
    init(value: T) {
        self.value = value
    }
    
    func add(child: FamilyNode) {
        children.append(child)
        child.parent = self
    }
    
    func add(children elements: [FamilyNode]) {
        children.append(contentsOf: elements)
        elements.forEach { $0.parent = self }
    }
    
}

extension FamilyNode: CustomStringConvertible {
    var description: String {
        var text = "\(value)"
        
        if !children.isEmpty {
            text += " {" + children.map { $0.description }.joined(separator: ", ") + "} "
        }
        return text
    }
}

extension FamilyNode where T: Equatable {
    func search(value: T) -> FamilyNode? {
        if value == self.value {
            return self
        }
        for child in children {
            if let found = child.search(value: value) {
                return found
            }
        }
        return nil
    }
}
