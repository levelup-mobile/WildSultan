//
//  ShopViewModel.swift
//  Sultan
//
//  Created by Pfriedrix on 14.09.2023.
//

import Foundation

class ShopViewModel: ObservableObject {
    @Published var buildings: Int
    @Published var hp: Int
    @Published var bombs: Int
    
    init(buildings: Int, hp: Int, bombs: Int) {
        self.buildings = buildings
        self.hp = hp
        self.bombs = bombs
    }
}
