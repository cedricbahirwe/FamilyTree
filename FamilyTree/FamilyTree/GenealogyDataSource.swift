//
//  GenealogyDataSource.swift
//  FamilyTree
//
//  Created by Cédric Bahirwe on 23/10/2023.
//

import Foundation


@Observable class GenealogyDataSource {
    
    var tree: FamilyNode<String>?
    
    func fetch() {
        self.tree = loadGenealogy()
    }

    private func otherMusoles() -> [FamilyNode<String>] {
        [
            "MWENGEHERWA", "NAMWEZI",
            "MUKEMBANYI", "ZIRIMWABA",
            "CIBALONZA", "CHARLOTTE", "CIREZI"
        ].map(FamilyNode.init)
    }
    
    private func otherBahirwes() -> [FamilyNode<String>] {
        ["CIRIMWAMI", "AGANZE", "NABINTU", "BULONZA", "IRAGI"].map(FamilyNode.init)
    }
    
    private func otherKanywenges() -> [FamilyNode<String>] {
        ["MWA BAHENE", "MUSOLE","MWA MUNANA"].map(FamilyNode.init)
    }
    
    private func otherMukembanyis() -> [FamilyNode<String>] {
        [
            "BISIMA", "KAJIBWAMI", "KUJIRAKWINJA", "MARIO?", "BACIKENGE", "KULIMUSHI",
            "BAHIRWE",
            "NSIMIRE", "MAPENDO","SCOLASTIC", "VELENTINE", "NZIGIRE"
            
        ].map(FamilyNode.init)
    }
    
    private func loadGenealogy() -> FamilyNode<String> {
        let birhonga = FamilyNode(value: "BIRHONGA")
        
        // 1st Generation
        let kanywenge = FamilyNode(value: "KANYWENGE")
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
