//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Jeff Kang on 11/29/20.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case happy = "🙂"
    case neutral = "😐"
    case sad = "☹️"
}

extension Entry {
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        title: String,
                                        timestamp: Date = Date(),
                                        bodyText: String?,
                                        mood: Mood = .neutral,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.timestamp = timestamp
        self.bodyText = bodyText
        self.mood = mood.rawValue
    }
}
