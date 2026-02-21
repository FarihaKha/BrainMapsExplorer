//
//  PersistenceManager.swift
//  BrainMaps_Explorer
//
//  Created by Fariha Kha on 11/22/25.
//

import Foundation

// Define the notification name outside the class
extension Notification.Name {
    static let favoritesChanged = Notification.Name("favoritesChanged")
}

class PersistenceManager {
    static let shared = PersistenceManager()
    private let favoritesKey = "neurovault_favorites"
    
    func saveFavorite(studyName: String, studyId: Int, task: String) {
        let favorite = "\(studyId)|\(studyName)|\(task)"
        var favorites = getFavorites()
        favorites.removeAll { $0 == favorite }
        favorites.append(favorite)
        UserDefaults.standard.set(favorites, forKey: favoritesKey)
        
        // Also save to detailed favorites
        saveDetailedFavorite(studyId: studyId, studyName: studyName, task: task)
        
        // POST NOTIFICATION
        NotificationCenter.default.post(name: .favoritesChanged, object: nil)
    }
    
    func getFavorites() -> [String] {
        return UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []
    }
    
    func isFavorite(studyId: Int) -> Bool {
        let favorites = getFavorites()
        return favorites.contains { $0.hasPrefix("\(studyId)|") }
    }
    
    func removeFavorite(studyId: Int) {
        var favorites = getFavorites()
        favorites.removeAll { $0.hasPrefix("\(studyId)|") }
        UserDefaults.standard.set(favorites, forKey: favoritesKey)
        
        // Also remove from detailed favorites
        removeDetailedFavorite(studyId: studyId)
        
        // POST NOTIFICATION
        NotificationCenter.default.post(name: .favoritesChanged, object: nil)
    }
    
    func getFavoriteIds() -> [Int] {
        let favorites = getFavorites()
        return favorites.compactMap { favoriteString in
            let components = favoriteString.components(separatedBy: "|")
            return Int(components.first ?? "")
        }
    }
    
    private func saveDetailedFavorite(studyId: Int, studyName: String, task: String) {
        var detailedFavorites = getDetailedFavorites()
        
        // Remove if already exists
        detailedFavorites.removeAll { ($0["id"] as? Int) == studyId }
        
        // Add new favorite
        let favoriteData: [String: Any] = [
            "id": studyId,
            "name": studyName,
            "task": task,
            "date": Date().timeIntervalSince1970
        ]
        
        detailedFavorites.append(favoriteData)
        UserDefaults.standard.set(detailedFavorites, forKey: "favorite_studies")
    }
    
    private func removeDetailedFavorite(studyId: Int) {
        var detailedFavorites = getDetailedFavorites()
        detailedFavorites.removeAll { ($0["id"] as? Int) == studyId }
        UserDefaults.standard.set(detailedFavorites, forKey: "favorite_studies")
    }
    
    private func getDetailedFavorites() -> [[String: Any]] {
        return UserDefaults.standard.array(forKey: "favorite_studies") as? [[String: Any]] ?? []
    }
}
