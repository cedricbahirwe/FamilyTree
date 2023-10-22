//
//  ContentView.swift
//  FamilyTree
//
//  Created by Cédric Bahirwe on 22/10/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            VStack(spacing: 10) {
                TrialView()
                    .scaleEffect(currentZoom + totalZoom)
                    .gesture(
                        MagnifyGesture()
                            .onChanged { value in
                                currentZoom = value.magnification - 1
                            }
                            .onEnded { value in
                                totalZoom += currentZoom
                                currentZoom = 0
                            }
                    )
            }
            
        }
    }
}

#Preview {
    ContentView()
}


struct TrialView: View {
    var rootNode = trial()
    var body: some View {
        
        VStack(spacing: 10) {
            intro(rootNode)
            HStack(spacing: 15) {
                ForEach(rootNode.children) { fdescendant in
                    TrialView(rootNode: fdescendant)
                    
                }
            }
        }
    }
    
    @ViewBuilder
    func intro(_ node: FamilyNode<String>) -> some View {
        Text(node.value)
            .bold()
            .padding()
            .minimumScaleFactor(0.5)
            .lineLimit(1)
            .frame(width: 160)
            .border(.red)
            .overlay(alignment: .bottom) {
                if !node.children.isEmpty {
                    HStack {
                        ForEach(0..<node.children.count, id: \.self) { i in
                            Color.red.frame(width: 1, height: 10)
                                .frame(maxWidth: .infinity)
                                .offset(y: 10)
                        }
                    }
                }
            }
    }
    
    typealias Node = FamilyNode
    static func trial() -> Node<String> {
        let musole = Node(value: "MUSOLE")
        
        let mukembanyi = Node(value: "MUKEMBANYI")
        let coldBeverages = Node(value: "cold")
        
        let bahirwe = Node(value: "BAHIRWE")
        
        let ciri = Node(value: "CIRIMWAMI")
        let aga = Node(value: "AGANZE")
        let nabi = Node(value: "NABINTU")
        let bulo = Node(value: "BULONZA")
        let ira = Node(value: "IRAGI")
        
               
        musole.add(child: mukembanyi)
        
        mukembanyi.add(child: bahirwe)
        
        bahirwe.add(child: ciri)
        bahirwe.add(child: aga)
        bahirwe.add(child: nabi)
        bahirwe.add(child: bulo)
        bahirwe.add(child: ira)
            
    
        print(musole)
        return musole
    }
}




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
    
}

// 1
extension FamilyNode: CustomStringConvertible {
    // 2
    var description: String {
        // 3
        var text = "\(value)"
        
        // 4
        if !children.isEmpty {
            text += " {" + children.map { $0.description }.joined(separator: ", ") + "} "
        }
        return text
    }
}

extension FamilyNode where T: Equatable {
    // 2.
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
