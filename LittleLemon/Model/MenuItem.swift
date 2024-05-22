//
//  MenuItem.swift
//  LittleLemon
//
//  Created by Dhai Alassaf on 22/05/2024.
//

import Foundation
struct MenuItem: Codable {
    var id: Int
    var title: String
    var dishDescription: String
    var price: String
    var image: String
    var category: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, price, image, category
        case dishDescription = "description"
    }
}
