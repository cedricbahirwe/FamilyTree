//
//  Other.swift
//  FamilyTree
//
//  Created by Cédric Bahirwe on 22/10/2023.
//

import Foundation




//struct FamilyTree {
//    let ancestor: FNode
//}
//
//enum FamilyGender {
//    case male, female
//    
//}
//enum FamilyStatus {
//    case deceased, alive, unknown
//}
//struct FNode: Identifiable {
//    var id: UUID { UUID() }
//    var name: String
//    var status: FamilyStatus = .alive
//    var gender: FamilyGender
//    var descendants: [FNode] = []
//    
//    func legend() -> String {
//        let mark = (status == .deceased) ? "+" : (status == .unknown) ? "?" : ""
//        switch gender {
//        case .male:
//            return "M\(mark)"
//        case .female:
//            return "F\(mark)"
//        }
//    }
//}
//
//struct FamilyLink: Identifiable {
//    var id: UUID { UUID() }
//    var father: FNode
//    var mother: FNode
//    var descendants: [FNode]
//}




// leaf nodes
//let ciri = FNode(name: "CIRIMWAMI", gender: .male)
//let aga = FNode(name: "AGANZE", gender: .male)
//let nabi = FNode(name: "NABINTU", gender: .female)
//let bulo = FNode(name: "BULONZA", gender: .female)
//let ira = FNode(name: "IRAGI", gender: .male)
//
//// intermediate nodes on the left
//let bahi = FNode(name: "BAHIRWE", gender: .male, descendants: [
//    ciri, aga, nabi, bulo, ira
//])
//let muke = FNode(name: "MUKEMBANYI", gender: .male, descendants: [
//    bahi
//])
//// intermediate nodes on the right
//let ndya = FNode(name: "NDYANABO", gender: .female, descendants: [
//    ciri, aga, nabi, bulo, ira
//])
//let nalu = FNode(name: "NALUSAMBO", gender: .female, descendants: [
//    muke
//])
//
//// root node
//let tree = FNode(name: "MUSOLE", gender: .male)
//
//extension FNode {
//    func linkTo(externalNode: FNode, descendants: [FNode]) -> FamilyLink {
//        FamilyLink(father: gender == .male ? self : externalNode,
//                   mother: gender == .male ? self : externalNode,
//                   descendants: descendants)
//    }
//}




//struct NodeView: View {
//    let node: FNode
//    var body: some View {
//        Text(node.name)
//            .bold()
//            .padding()
//            .minimumScaleFactor(0.5)
//            .lineLimit(1)
//            .frame(width: 160)
//            .border(.red)
//            .overlay(alignment: .topTrailing) {
//                if node.status == .deceased {
//                    Text(node.legend())
//                        .font(.caption)
//                        .padding(3)
//                        .background(.red.opacity(0.6))
//                        .clipShape(RoundedRectangle(cornerRadius: 2))
//                        .foregroundStyle(.white)
//                }
//            }
//            .overlay(alignment: .bottom) {
//                if !node.descendants.isEmpty {
//                    HStack {
//                        ForEach(0..<node.descendants.count, id: \.self) { i in
//                            Color.red.frame(width: 1, height: 10)
//                                .frame(maxWidth: .infinity)
//                                .offset(y: 10)
//                        }
//                    }
//                }
//            }
//    }
//}


//
//let mwabahene = FNode(name: "MWA BAHENE", status: .deceased, gender: .female, descendants: [])
//
//let musole = FNode(name: "MUSOLE", status: .deceased, gender: .male, descendants: [])
//
//
//let mwamunana = FNode(name: "MWA MUNANA", status: .deceased, gender: .male, descendants: [])
//
