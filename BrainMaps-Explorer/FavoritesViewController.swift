//
//  FavoritesViewController.swift
//  BrainMaps_Explorer
//
//  Created by Fariha Kha on 11/10/25.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    private let tableView = UITableView()
    private let emptyStateLabel = UILabel()
    private var favoriteIds: [Int] = []
    private var favoriteStudies: [NeuroVaultImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Favorites"
        view.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 251/255, alpha: 1.0)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }
    
    private func setupUI() {
        setupTableView()
        setupEmptyState()
        
        let refreshButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.clockwise"),
            style: .plain,
            target: self,
            action: #selector(refreshFavorites)
        )
        refreshButton.tintColor = UIColor(red: 247/255, green: 168/255, blue: 184/255, alpha: 1.0)
        navigationItem.rightBarButtonItem = refreshButton
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FavoriteCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupEmptyState() {
        emptyStateLabel.text = "No favorites yet\nSearch for studies and tap the star to save them"
        emptyStateLabel.textColor = .gray
        emptyStateLabel.font = UIFont.systemFont(ofSize: 16)
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.isHidden = true
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func loadFavorites() {
        favoriteIds = PersistenceManager.shared.getFavoriteIds()
        
        if favoriteIds.isEmpty {
            favoriteStudies = []
            tableView.reloadData()
            emptyStateLabel.isHidden = false
            return
        }
        
        favoriteStudies = [] // Clear existing
        tableView.reloadData()
        emptyStateLabel.isHidden = !favoriteIds.isEmpty
        
        // Load from saved UserDefaults favorites
        loadSavedFavorites()
    }
    
    private func loadSavedFavorites() {
        if let savedFavorites = UserDefaults.standard.array(forKey: "favorite_studies") as? [[String: Any]] {
            // Filter to only include IDs that are in our favoriteIds
            let filteredFavorites = savedFavorites.filter { dict in
                if let id = dict["id"] as? Int {
                    return favoriteIds.contains(id)
                }
                return false
            }
            
            // Convert to simple display format
            favoriteStudies = filteredFavorites.compactMap { dict in
                // Create a minimal NeuroVaultImage from the saved data
                guard let id = dict["id"] as? Int,
                      let name = dict["name"] as? String else {
                    return nil
                }
                
                return NeuroVaultImage(
                    id: id,
                    name: name,
                    description: dict["description"] as? String,
                    thumbnail: dict["thumbnail"] as? String,
                    map_type: dict["map_type"] as? String,
                    cognitive_paradigm_cogatlas: dict["task"] as? String,
                    number_of_subjects: nil,
                    modality: nil,
                    file: "",
                    brain_coverage: nil,
                    perc_bad_voxels: nil,
                    smoothness_fwhm: nil,
                    perc_voxels_outside: nil,
                    subject_species: nil,
                    age: nil,
                    sex: nil,
                    race: nil,
                    ethnicity: nil,
                    handedness: nil,
                    analysis_level: nil,
                    is_valid: nil,
                    target_template_image: nil,
                    data_origin: nil,
                    not_mni: nil,
                    cognitive_paradigm_cogatlas_id: nil,
                    cognitive_contrast_cogatlas: nil,
                    add_date: nil,
                    modify_date: nil,
                    YRS_SCH: nil,
                    SubjectID: nil,
                    Rating: nil,
                    Holdout: nil,
                    Picture: nil
                )
            }
            
            tableView.reloadData()
        }
    }
    
    @objc private func refreshFavorites() {
        loadFavorites()
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteStudies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath)
        let study = favoriteStudies[indexPath.row]
        
        cell.textLabel?.text = study.displayName
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        cell.textLabel?.textColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.0)
        
        cell.detailTextLabel?.text = study.displayTask
        cell.detailTextLabel?.textColor = .gray
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        
        cell.backgroundColor = .clear
        
        let starView = UIImageView(image: UIImage(systemName: "star.fill"))
        starView.tintColor = UIColor(red: 247/255, green: 168/255, blue: 184/255, alpha: 1.0)
        cell.accessoryView = starView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let study = favoriteStudies[indexPath.row]
        
        // Create a detail view controller
        let detailVC = StudyDetailViewController()
        detailVC.study = study
        
        // Switch to search tab (index 0) and push detail
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 0
            
            if let navController = tabBarController.viewControllers?[0] as? UINavigationController {
                navController.pushViewController(detailVC, animated: true)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Remove") { [weak self] (action, view, completion) in
            guard let self = self else { return }
            
            let study = self.favoriteStudies[indexPath.row]
            PersistenceManager.shared.removeFavorite(studyId: study.id)
            
            self.favoriteStudies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            self.emptyStateLabel.isHidden = !self.favoriteStudies.isEmpty
            
            completion(true)
        }
        
        deleteAction.backgroundColor = UIColor(red: 247/255, green: 168/255, blue: 184/255, alpha: 1.0)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
