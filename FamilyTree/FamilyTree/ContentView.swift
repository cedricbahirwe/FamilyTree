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
    @State private var datasource = GenealogyDataSource()
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    
    private let screen = UIScreen.main.bounds.size
    
    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: false) {
            GenealogyTreeView()
                .fixedSize()
                .frame(width: screen.width, height: screen.height, alignment: .top)
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
                .padding(.horizontal, 300)
            
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
        .environment(datasource)
    }
}

#Preview {
    ContentView()
}

struct GenealogyTreeView: View {
    @Environment(GenealogyDataSource.self) private var dataSource
    
    var body: some View {
        
        Group {
            if let tree = dataSource.tree {
                FamilyNodeView(node: tree)
            } else {
                ProgressView("Loading Genealogy Tree")
            }
        }
        .onAppear() {
            dataSource.fetch()
        }
    }
    
}

struct FamilyNodeView: View {
    let node: FamilyNode<String>
    var offset = TreeLayout.lineOffset
    var accentColor = TreeLayout.mainColor
    
    var body: some View {
        VStack(spacing: offset) {
            intro(node)
            //                .offset(y: -TreeLayout.nocdeHeight-TreeLayout.lineOffset)
                .overlay {
                    HStack(alignment: .top, spacing: 15) {
                        ForEach(node.children) { childNode in
                            FamilyNodeView(node: childNode)
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
    
}
