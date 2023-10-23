//
//  ContentView.swift
//  FamilyTree
//
//  Created by Cédric Bahirwe on 22/10/2023.
//

import SwiftUI

enum TreeLayout {
    static let lineHeight: CGFloat = 20
    static let lineOffset: CGFloat = 40
    
    static let mainColor = Color.blue
    
    static let nodeWidth: CGFloat = 160
    static let nodeHeight: CGFloat = 60
    static let nodeSize = CGSize(width: nodeWidth, height: nodeHeight)
}

struct ContentView: View {
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    
    private let screen = UIScreen.main.bounds.size
    
    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: false) {
            VStack(spacing: TreeLayout.lineHeight) {
                TrialView()
            }
            .fixedSize()
            .frame(width: screen.width, height: screen.height)
            .scaleEffect(currentZoom + totalZoom)
            .contentShape(Rectangle())
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
            .padding(100)

        }
        .overlay(alignment: .topTrailing) {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text("Légende:")
                    VStack(alignment: .leading) {
                        Text("M+ = Masculin décédé")
                        Text("F+ = Féminin décédée")
                        Text("?  = Disparu")
                    }
                }
                Text("**N.B.**: Tu es de la cinquième génération à partir de l'ancêtre **BIRHONGA**.")
            }
            .font(.callout)
            .fontDesign(.monospaced)
            .padding()
            .frame(maxWidth: 320, alignment: .leading)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

struct TrialView: View {
    var accentColor = TreeLayout.mainColor
    var offset = TreeLayout.lineOffset
    var rootNode = trial()
    
    var body: some View {
        
        VStack(spacing: offset) {
            intro(rootNode)
                .offset(y: -TreeLayout.nodeHeight-TreeLayout.lineOffset)
                .overlay {
                    HStack(alignment: .top, spacing: 15) {
                        ForEach(rootNode.children) { fdescendant in
                            TrialView(rootNode: fdescendant)
//                                .offset(y: -TreeLayout.nodeHeight)
                        }
                    }
                    .offset(y: TreeLayout.nodeHeight + offset)
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
            .frame(width: TreeLayout.nodeWidth, height: TreeLayout.nodeHeight)
            .border(accentColor)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .bottom) {
                
                if node.children.count == 1 {
                    accentColor.frame(width: 1, height: offset)
                        .frame(maxWidth: .infinity)
                        .offset(y: offset)
                    
                } else if node.children.count > 1 {
                    VStack(spacing: 0) {
                        
                        accentColor.frame(width: 1, height: TreeLayout.lineHeight)
                        
                        accentColor
                            .frame(height: 1)
                            .frame(
                                width: (TreeLayout.nodeWidth * CGFloat(node.children.count)) + (15 * CGFloat(node.children.count-1)) - TreeLayout.nodeWidth,
                                height: 1
                            )
                        
                        HStack(spacing: 15) {
                            ForEach(0..<node.children.count, id: \.self) { i in
                                accentColor
                                    .frame(width: 1, height: TreeLayout.lineHeight)
                                if i+1 != node.children.count {
                                    Spacer()
                                }
                            }
                        }
                        
                    }
                    .offset(y: offset)
                }
            }
    }
    
    typealias Node = FamilyNode
    
    static func otherMusoles() -> [FamilyNode<String>] {
        [
            "MWENGEHERWA", "NAMWEZI",
            "MUKEMBANYI", "ZIRIMWABA",
            "CIBALONZA", "CHARLOTTE", "CIREZI"
        ].map(FamilyNode.init)
    }
    
    
    static func otherBahirwes() -> [FamilyNode<String>] {
        let ciri = Node(value: "CIRIMWAMI")
        let aga = Node(value: "AGANZE")
        let nabi = Node(value: "NABINTU")
        let bulo = Node(value: "BULONZA")
        let ira = Node(value: "IRAGI")
        
        return [ciri, aga, nabi, bulo, ira]
    }
    
    static func otherKanywenges() -> [FamilyNode<String>] {
        ["MWA BAHENE", "MUSOLE","MWA MUNANA"].map(FamilyNode.init)
    }
    
    static func otherMukembanyis() -> [FamilyNode<String>] {
        [
            "BISIMA", "KAJIBWAMI", "KUJIRAKWINJA", "MARIO?", "BACIKENGE", "KULIMUSHI",
            "BAHIRWE",
            "NSIMIRE", "MAPENDO","SCOLASTIC", "VELENTINE", "NZIGIRE"
            
        ].map(FamilyNode.init)
    }
    
    static func trial() -> Node<String> {
        let birhonga = Node(value: "BIRHONGA")
        
        // 1st Generation
        let kanywenge = Node(value: "KANYWENGE")
        birhonga.add(child: kanywenge)
        
        // 2nd Generation
        kanywenge.add(children: otherKanywenges())
        
        if let musole = kanywenge.search(value: "MUSOLE") {
            musole.add(children: otherMusoles())
            // 3rd Generation
            if let mukembanyi = musole.search(value: "MUKEMBANYI") {
                // 4th Generation
                mukembanyi.add(children: otherMukembanyis())
                if let bahirwe = mukembanyi.search(value: "BAHIRWE") {
                    // 5th Generation
                    bahirwe.add(children: otherBahirwes())
                }
            }
        }
        
        return birhonga
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
    
    func add(children elements: [FamilyNode]) {
        children.append(contentsOf: elements)
        elements.forEach { $0.parent = self }
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
