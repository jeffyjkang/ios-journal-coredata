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
    
    var entryRepresentation: EntryRepresentation? {
        guard let id = identifier,
              let title = title,
              let timestamp = timestamp,
              let mood = mood
        else { return nil }
        
        return EntryRepresentation(identifier: id.uuidString, title: title, bodyText: bodyText, timestamp: timestamp, mood: mood)
    }
    
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
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let identifier = UUID(uuidString: entryRepresentation.identifier),
              let mood = Mood(rawValue: entryRepresentation.mood) else { return nil }
        self.init(identifier: identifier, title: entryRepresentation.title,  timestamp: entryRepresentation.timestamp, bodyText: entryRepresentation.bodyText, mood: mood)
    }
}
