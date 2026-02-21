//
//  SearchViewController.swift
//  BrainMaps_Explorer
//
//  Created by Fariha Kha on 11/10/25.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let searchTextField = UITextField()
    private let tableView = UITableView()
    private let welcomeLabel = UILabel()
    private let featuredLabel = UILabel()
    
    private var featuredStudies: [NeuroVaultImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "BrainMap Explorer"
        view.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 251/255, alpha: 1.0) // #f9f9fb
        setupUI()
        loadFeaturedStudies()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let favoritesButton = UIBarButtonItem(
            image: UIImage(systemName: "star.fill"),
            style: .plain,
            target: self,
            action: #selector(favoritesButtonTapped)
        )
        favoritesButton.tintColor = UIColor(red: 247/255, green: 168/255, blue: 184/255, alpha: 1.0)
        navigationItem.rightBarButtonItem = favoritesButton
    }
    
    @objc private func favoritesButtonTapped() {
        let favoritesVC = FavoritesViewController()
        let navController = UINavigationController(rootViewController: favoritesVC)
        
        // Add a close/done button
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissFavorites))
        favoritesVC.navigationItem.leftBarButtonItem = doneButton
        
        present(navController, animated: true, completion: nil)
    }

    @objc private func dismissFavorites() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupUI() {
        setupWelcomeLabel()
        setupSearchField()
        setupFeaturedLabel()
        setupTableView()
    }
    
    private func setupWelcomeLabel() {
        welcomeLabel.text = "Explore Real fMRI Studies"
        welcomeLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        welcomeLabel.textColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.0) // charcoal
        welcomeLabel.textAlignment = .center
        welcomeLabel.numberOfLines = 0
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomeLabel)
        
        let subtitle = UILabel()
        subtitle.text = "Search 650,000+ brain maps from published research"
        subtitle.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        subtitle.textColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 0.7) // charcoal with alpha
        subtitle.textAlignment = .center
        subtitle.numberOfLines = 0
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitle)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            subtitle.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 10),
            subtitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            subtitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
    
    private func setupSearchField() {
        // Search container
        let searchContainer = UIView()
        searchContainer.backgroundColor = .white
        searchContainer.layer.cornerRadius = 12
        searchContainer.layer.shadowColor = UIColor.black.cgColor
        searchContainer.layer.shadowOpacity = 0.1
        searchContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        searchContainer.layer.shadowRadius = 4
        searchContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchContainer)
        
        // Search icon
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = UIColor(red: 130/255, green: 199/255, blue: 230/255, alpha: 1.0) // accent blue
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        searchContainer.addSubview(searchIcon)
        
        // Text field - UPDATED PLACEHOLDER WITH BETTER TERMS
        searchTextField.placeholder = "Try: 'decision', 'reward', 'visual', 'memory'"
        searchTextField.borderStyle = .none
        searchTextField.font = UIFont.systemFont(ofSize: 16)
        searchTextField.returnKeyType = .search
        searchTextField.delegate = self
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchContainer.addSubview(searchTextField)
        
        NSLayoutConstraint.activate([
            searchContainer.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 60),
            searchContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchContainer.heightAnchor.constraint(equalToConstant: 56),
            
            searchIcon.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 15),
            searchIcon.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 22),
            searchIcon.heightAnchor.constraint(equalToConstant: 22),
            
            searchTextField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 12),
            searchTextField.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor, constant: -15),
            searchTextField.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupFeaturedLabel() {
        featuredLabel.text = "Featured Studies"
        featuredLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        featuredLabel.textColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.0) // charcoal
        featuredLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(featuredLabel)
        
        NSLayoutConstraint.activate([
            featuredLabel.topAnchor.constraint(equalTo: searchTextField.superview!.bottomAnchor, constant: 40),
            featuredLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            featuredLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FeaturedCell.self, forCellReuseIdentifier: "FeaturedCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: featuredLabel.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func loadFeaturedStudies() {
        // Use the new getFeaturedStudies (gets 500 studies)
        APIService.shared.getFeaturedStudies { [weak self] (result: Result<[NeuroVaultImage], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let studies):
                    self?.featuredStudies = studies
                    self?.tableView.reloadData()
                    print("Loaded \(studies.count) featured studies")
                case .failure(let error):
                    print("Failed to load featured: \(error)")
                }
            }
        }
    }
    
    private func performSearch() {
        guard let query = searchTextField.text, !query.isEmpty else {
            let alert = UIAlertController(title: "Empty Search",
                                        message: "Please enter a search term",
                                        preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let resultsVC = ResultsViewController()
        resultsVC.searchQuery = query
        navigationController?.pushViewController(resultsVC, animated: true)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSearch()
        textField.resignFirstResponder()
        return true
    }
}

// Custom Cell for Featured Studies
class FeaturedCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .gray
        backgroundColor = .clear
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.0) // charcoal
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 0.7) // charcoal with alpha
        descriptionLabel.numberOfLines = 1
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        
        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = UIColor(red: 199/255, green: 184/255, blue: 234/255, alpha: 1.0) // lavender
        chevron.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(chevron)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            
            chevron.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            chevron.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevron.widthAnchor.constraint(equalToConstant: 12),
            chevron.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with study: NeuroVaultImage) {
        // Use the display properties from your NeuroVaultImage struct
        titleLabel.text = study.displayName
        descriptionLabel.text = study.displayTask
    }
}

// TableView DataSource & Delegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return featuredStudies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedCell", for: indexPath) as! FeaturedCell
        let study = featuredStudies[indexPath.row]
        cell.configure(with: study)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let study = featuredStudies[indexPath.row]
        let detailVC = StudyDetailViewController()
        detailVC.study = study
        navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
