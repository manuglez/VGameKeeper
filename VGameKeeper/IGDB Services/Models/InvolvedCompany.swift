//
//  InvolvedCompanies.swift
//  VGameKeeper
//
//  Created by Manuel Gonzalez on 11/06/23.
//

import Foundation
import Foundation

// MARK: - InvolvedCompany
struct InvolvedCompany: Codable {
    let id: Int
    let company: IGDB_Item
    let developer, publisher, supporting: Bool
}
