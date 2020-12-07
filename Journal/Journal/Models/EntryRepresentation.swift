//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Jeff Kang on 12/6/20.
//

import Foundation

struct EntryRepresentation: Codable {
    var identifier: String
    var title: String
    var bodyText: String?
    var timestamp: Date
    var mood: String
}
