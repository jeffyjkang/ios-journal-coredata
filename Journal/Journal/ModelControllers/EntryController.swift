//
//  EntryController.swift
//  Journal
//
//  Created by Jeff Kang on 12/6/20.
//

import Foundation
import CoreData

enum NetworkError: Error {
    case noIdentifier
    case noRepresentation
    case noData
    case failedDecode
    case failedEncode
    case otherError
}

class EntryController {
    
    let baseURL =  URL(string: "https://ios-journal-b488b-default-rtdb.firebaseio.com/")!
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    init() {
        fetchEntriesFromServer()
    }
    
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard let representation = entry.entryRepresentation else {
                completion(.failure(.noRepresentation))
                return
            }
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding entry \(entry): \(error)")
            completion(.failure(.failedEncode))
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error sending entry to server \(entry): \(error)")
                completion(.failure(.otherError))
                return
            }
            completion(.success(true))
        }.resume()
        
    }
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response!)
            completion(.success(true))
        }.resume()
        
    }
    
//    func update(entry: Entry, with representation: EntryRepresentation) {
//        entry.title = representation.title
//        entry.bodyText = representation.bodyText
//        entry.timestamp = representation.timestamp
//        entry.mood = representation.mood
//    }
    
    func updateEntries(with representations: [EntryRepresentation]) throws {
        let identifiersToFetch = representations.compactMap { UUID(uuidString: $0.identifier) }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.mainContext
        
        do {
            let existingEntries = try context.fetch(fetchRequest)
            for entry in existingEntries {
                guard let id = entry.identifier, let representation = representationsByID[id] else { continue }
                
//                self.update(entry: entry, with: representation)
                entry.title = representation.title
                entry.bodyText = representation.bodyText
                entry.timestamp = representation.timestamp
                entry.mood = representation.mood
                
                entriesToCreate.removeValue(forKey: id)
            }
            // entriesToCreate should now have entries we do not have in core data
            for representation in entriesToCreate.values {
                Entry(entryRepresentation: representation, context: context)
            }
        } catch {
            print("Error fetching entries for UUIDs: \(error)")
        }
        try context.save()
    }
    
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("Error fetching entries: \(error)")
                completion(.failure(.otherError))
                return
            }
            guard let data = data else {
                print("No data returned by data task")
                completion(.failure(.noData))
                return
            }
            do {
                let entryRepresentations = Array(try JSONDecoder().decode([String: EntryRepresentation].self, from: data).values)
                try self.updateEntries(with: entryRepresentations)
                completion(.success(true))
            } catch {
                print("Error decoding entries: \(error)")
                completion(.failure(.failedDecode))
            }
        }.resume()
    }
    
}
