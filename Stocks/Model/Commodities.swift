//
//  Commodities.swift
//  Stocks
//
//  Created by Matthew Reddin on 26/07/2022.
//

import Foundation

struct CommoditySection {
    let name: String
    let commodities: [CommodityItem]
}

extension CommoditySection {
    static let energySection = CommoditySection(name: "Energy", commodities: [.crudeOil, .brentOil, .naturalGas])
    static let metals = CommoditySection(name: "Metals", commodities: [.gold, .silver, .platinum, .copper, .aluminium])
    static let agricultire = CommoditySection(name: "Agriculture", commodities: [.wheat, .cocoa, .coffee, .cotton, .liveCattle])
    static let allSections = [CommoditySection.energySection, .metals, .agricultire]
}

struct CommodityItem {
    let name: String
    let symbol: String
}

extension CommodityItem {
    
    // Energy
    static let crudeOil = CommodityItem(name: "Crude Oil", symbol: "CL=F")
    static let brentOil = CommodityItem(name: "Brent Crude Oil", symbol: "BZ=F")
    static let naturalGas = CommodityItem(name: "Natural Gas", symbol: "NG=F")
    
    // Metals
    static let gold = CommodityItem(name: "Gold", symbol: "GC=F")
    static let silver = CommodityItem(name: "Silver", symbol: "SI=F")
    static let platinum = CommodityItem(name: "Platinum", symbol: "PL=F")
    static let copper = CommodityItem(name: "Copper", symbol: "HG=F")
    static let aluminium = CommodityItem(name: "Aluminium", symbol: "ALI=F")
    
    //Agriculture
    static let wheat = CommodityItem(name: "Wheat", symbol: "KE=F")
    static let cocoa = CommodityItem(name: "Cocoa", symbol: "CC=F")
    static let coffee = CommodityItem(name: "Coffee", symbol: "KC=F")
    static let cotton = CommodityItem(name: "Cotton", symbol: "CT=F")
    static let liveCattle = CommodityItem(name: "Live Cattle", symbol: "LE=F")
}
