//
//  MenuList.swift
//  LittleLemon
//
//  Created by Dhai Alassaf on 22/05/2024.
//

import Foundation

struct MenuList: Codable {
    let menu: [MenuItem]
    
    enum CodingKeys: String, CodingKey {
        case menu = "menu"
    }
    
}
