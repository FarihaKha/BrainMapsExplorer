//
//  BrainRegion.swift
//  BrainMaps_Explorer
//
//  Created by Fariha Kha on 11/22/25.
//


import Foundation

struct BrainRegion {
    let id: Int
    let name: String
    let parentStructure: String?
    let expressionValue: Double
    
    init(id: Int, name: String, parentStructure: String? = nil, expressionValue: Double) {
        self.id = id
        self.name = name
        self.parentStructure = parentStructure
        self.expressionValue = expressionValue
    }
}
