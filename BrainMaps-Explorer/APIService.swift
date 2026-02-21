//
//  APIService.swift
//  BrainMaps_Explorer
//
//  Created by Fariha Kha on 11/20/25.
//

import Foundation
import UIKit

// NeuroVault Data Models
struct NeuroVaultResponse: Codable {
    let count: Int
    let next: String?  // For pagination
    let previous: String?  // For pagination
    let results: [NeuroVaultImage]
}

struct NeuroVaultImage: Codable {
    // Basic study info
    let id: Int
    let name: String
    let description: String?
    let thumbnail: String?
    let map_type: String?
    let cognitive_paradigm_cogatlas: String?
    let number_of_subjects: Int?
    let modality: String?
    let file: String
    
    // Technical data
    let brain_coverage: Double?
    let perc_bad_voxels: Double?
    let smoothness_fwhm: Double?
    let perc_voxels_outside: Double?
    
    // Rich demographic data
    let subject_species: String?
    let age: Int?
    let sex: String?
    let race: String?
    let ethnicity: String?
    let handedness: String?
    let analysis_level: String?
    let is_valid: Bool?
    let target_template_image: String?
    let data_origin: String?
    let not_mni: Bool?
    
    // Extended metadata
    let cognitive_paradigm_cogatlas_id: String?
    let cognitive_contrast_cogatlas: String?
    let add_date: String?
    let modify_date: String?
    
    // IAPS study specific fields
    let YRS_SCH: Int?
    let SubjectID: Double?
    let Rating: Int?
    let Holdout: String?
    let Picture: Double?
    
    // MARK: - Cleaned Display Properties
    var displayName: String {
        if name.contains("task") && name.contains("cope") {
            return "Brain Activation Map"
        } else if name.lowercased().contains("parametric") {
            return "Reward Processing Study"
        } else if name.lowercased().contains("coherence") {
            return "Brain Connectivity Analysis"
        } else if name.lowercased().contains("falff") {
            return "Brain Signal Analysis"
        } else if name.lowercased().contains("iaps") {
            return "Emotion Processing Study"
        }
        return name.isEmpty ? "Neuroscience Study" : name
    }
    
    var displayTask: String {
        if let task = cognitive_paradigm_cogatlas {
            switch task.lowercased() {
            case "mixed gambles task":
                return "Decision Making Study"
            case "international affective picture system":
                return "Emotion Processing Study"
            case "memory task":
                return "Memory Research"
            case "visual task":
                return "Vision Study"
            case "motor task":
                return "Movement Research"
            case "n-back":
                return "Working Memory Task"
            case "stop signal":
                return "Inhibition Study"
            default:
                return task
            }
        }
        return map_type ?? "Brain Imaging"
    }
    
    var cleanDescription: String {
        if let desc = description, !desc.isEmpty {
            return desc
        }
        
        if name.lowercased().contains("visual") {
            return "Study of visual processing in the brain"
        } else if name.lowercased().contains("memory") {
            return "Research on how the brain forms and retrieves memories"
        } else if name.lowercased().contains("motor") {
            return "Analysis of brain regions controlling movement"
        } else if cognitive_paradigm_cogatlas?.lowercased().contains("affective") == true {
            return "Study of emotional processing using picture stimuli"
        } else if cognitive_paradigm_cogatlas?.lowercased().contains("gambles") == true {
            return "Study of decision-making and risk assessment in the brain"
        }
        
        return "Scientific study of brain function using fMRI imaging"
    }
    
    var hasQuantitativeData: Bool {
        return number_of_subjects != nil || brain_coverage != nil || perc_bad_voxels != nil
    }
    
    var hasDemographicData: Bool {
        return age != nil || sex != nil || race != nil || YRS_SCH != nil
    }
    
    // NEW: Better search matching
    func matchesQuery(_ query: String) -> Bool {
        let lowerQuery = query.lowercased()
        
        // Check all relevant fields
        let searchFields = [
            name.lowercased(),
            displayName.lowercased(),
            displayTask.lowercased(),
            cleanDescription.lowercased(),
            cognitive_paradigm_cogatlas?.lowercased() ?? "",
            modality?.lowercased() ?? "",
            map_type?.lowercased() ?? ""
        ]
        
        // Return true if ANY field contains the query
        return searchFields.contains { field in
            field.contains(lowerQuery)
        }
    }
}

// APIService
class APIService {
    static let shared = APIService()
    private let baseURL = "https://neurovault.org/api"
    private let pageSize = 500  // Get 500 results at once
    
    private init() {}
    
    // SMART SEARCH (500 results + pagination)
    func searchStudies(query: String, page: Int = 1, completion: @escaping (Result<(studies: [NeuroVaultImage], totalCount: Int, hasMore: Bool), Error>) -> Void) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let offset = (page - 1) * pageSize
        
        // SMART SEARCH: Try multiple search strategies
        var urlString: String
        
        if query.isEmpty {
            // Empty search = get recent studies
            urlString = "\(baseURL)/images?image_type=statistic_map&is_valid=true&ordering=-id&limit=\(pageSize)&offset=\(offset)"
        } else {
            // Try searching in the MOST RELEVANT field first
            urlString = "\(baseURL)/images?cognitive_paradigm_cogatlas__icontains=\(encodedQuery)&image_type=statistic_map&is_valid=true&ordering=-id&limit=\(pageSize)&offset=\(offset)"
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        print("SMART SEARCH: \(urlString)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Search error: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            // Debug
            if let httpResponse = response as? HTTPURLResponse {
                print("Status: \(httpResponse.statusCode)")
            }
            
            do {
                let response = try JSONDecoder().decode(NeuroVaultResponse.self, from: data)
                
                // Filter for better relevance
                let filteredStudies = self.filterForRelevance(response.results, query: query)
                
                // Calculate if there are more pages
                let hasMore = response.results.count == self.pageSize
                
                print("Found \(response.count) total studies in database")
                print("Got \(response.results.count) raw results")
                print("\(filteredStudies.count) relevant studies after filtering")
                print("Has more pages: \(hasMore)")
                
                completion(.success((filteredStudies, response.count, hasMore)))
            } catch {
                print("Decoding error: \(error)")
                
                // Fallback to general search if specific search fails
                if !query.isEmpty {
                    print("Trying fallback search...")
                    self.fallbackSearch(query: query, page: page, completion: completion)
                } else {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // MARK: - Fallback Search (broader search)
    private func fallbackSearch(query: String, page: Int = 1, completion: @escaping (Result<(studies: [NeuroVaultImage], totalCount: Int, hasMore: Bool), Error>) -> Void) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let offset = (page - 1) * pageSize
        
        // Broader search
        let urlString = "\(baseURL)/images?search=\(encodedQuery)&image_type=statistic_map&is_valid=true&ordering=-id&limit=\(pageSize)&offset=\(offset)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(NeuroVaultResponse.self, from: data)
                let filteredStudies = self.filterForRelevance(response.results, query: query)
                let hasMore = response.results.count == self.pageSize
                
                print("Fallback search successful")
                print("Got \(response.results.count) results")
                print("\(filteredStudies.count) relevant studies")
                
                completion(.success((filteredStudies, response.count, hasMore)))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Client-side Filtering for Better Relevance
    private func filterForRelevance(_ results: [NeuroVaultImage], query: String) -> [NeuroVaultImage] {
        guard !query.isEmpty else {
            return results  // Return all for empty query
        }
        
        let lowerQuery = query.lowercased()
        
        // Score each result based on relevance
        let scoredResults = results.map { study -> (study: NeuroVaultImage, score: Int) in
            var score = 0
            
            // High priority: Cognitive paradigm (what the study is actually about)
            if let paradigm = study.cognitive_paradigm_cogatlas?.lowercased(),
               paradigm.contains(lowerQuery) {
                score += 10
            }
            
            // High priority: Study name
            if study.name.lowercased().contains(lowerQuery) {
                score += 8
            }
            
            // Medium priority: Display task
            if study.displayTask.lowercased().contains(lowerQuery) {
                score += 6
            }
            
            // Medium priority: Description
            if let desc = study.description?.lowercased(),
               desc.contains(lowerQuery) {
                score += 5
            }
            
            // Low priority: Other fields
            if study.displayName.lowercased().contains(lowerQuery) {
                score += 3
            }
            
            if let modality = study.modality?.lowercased(),
               modality.contains(lowerQuery) {
                score += 2
            }
            
            return (study, score)
        }
        
        // Filter out zero-score results and sort by score
        return scoredResults
            .filter { $0.score > 0 }
            .sorted { $0.score > $1.score }
            .map { $0.study }
    }
    
    // Get Featured Studies (500 most recent)
    func getFeaturedStudies(completion: @escaping (Result<[NeuroVaultImage], Error>) -> Void) {
        let urlString = "\(baseURL)/images?image_type=statistic_map&is_valid=true&ordering=-id&limit=\(pageSize)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(NeuroVaultResponse.self, from: data)
                print("Got \(response.results.count) featured studies")
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Download Image (unchanged)
    func downloadImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            let placeholder = UIImage(systemName: "brain.head.profile") ?? UIImage()
            completion(.success(placeholder))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Image download error: \(error)")
                let placeholder = UIImage(systemName: "brain.head.profile") ?? UIImage()
                completion(.success(placeholder))
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                let placeholder = UIImage(systemName: "brain.head.profile") ?? UIImage()
                completion(.success(placeholder))
            }
        }.resume()
    }
}
