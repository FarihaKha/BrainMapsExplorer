//
//  ResultsViewController.swift
//  BrainMaps_Explorer
//
//  Created by Fariha Kha on 11/10/25.
//

import UIKit

class ResultsViewController: UIViewController {
    
    var searchQuery: String = ""
    private var searchResults: [NeuroVaultImage] = []
    private var currentPage = 1
    private var isLoading = false
    private var hasMoreResults = true
    private var totalStudyCount = 0
    
    private let resultsLabel = UILabel()
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let emptyStateView = UIView()
    private let loadMoreActivityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Results"
        view.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 251/255, alpha: 1.0)
        setupUI()
        performInitialSearch()
        
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Refresh table view to update star states
        tableView.reloadData()
    }
    
    private func setupUI() {
        setupResultsLabel()
        setupTableView()
        setupActivityIndicator()
        setupEmptyState()
        setupLoadMoreIndicator()
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
    
    private func setupResultsLabel() {
        resultsLabel.text = "Results for: \"\(searchQuery)\""
        resultsLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        resultsLabel.textColor = UIColor(red: 247/255, green: 168/255, blue: 184/255, alpha: 1.0)
        resultsLabel.textAlignment = .center
        resultsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resultsLabel)
        
        NSLayoutConstraint.activate([
            resultsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            resultsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ResultCell.self, forCellReuseIdentifier: "ResultCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: resultsLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor(red: 247/255, green: 168/255, blue: 184/255, alpha: 1.0)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupLoadMoreIndicator() {
        loadMoreActivityIndicator.hidesWhenStopped = true
        loadMoreActivityIndicator.color = UIColor(red: 247/255, green: 168/255, blue: 184/255, alpha: 1.0)
    }
    
    private func setupEmptyState() {
        emptyStateView.isHidden = true
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyStateView)
        
        let emptyLabel = UILabel()
        emptyLabel.text = "No studies found\nTry a different search term"
        emptyLabel.textColor = .gray
        emptyLabel.font = UIFont.systemFont(ofSize: 16)
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.addSubview(emptyLabel)
        
        let searchExamples = UILabel()
        searchExamples.text = "Try: 'memory', 'visual', 'decision', 'reward', 'motor'"
        searchExamples.textColor = .lightGray
        searchExamples.font = UIFont.systemFont(ofSize: 14)
        searchExamples.textAlignment = .center
        searchExamples.numberOfLines = 0
        searchExamples.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.addSubview(searchExamples)
        
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.widthAnchor.constraint(equalToConstant: 300),
            emptyStateView.heightAnchor.constraint(equalToConstant: 120),
            
            emptyLabel.topAnchor.constraint(equalTo: emptyStateView.topAnchor, constant: 10),
            emptyLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            
            searchExamples.topAnchor.constraint(equalTo: emptyLabel.bottomAnchor, constant: 10),
            searchExamples.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            searchExamples.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            searchExamples.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor)
        ])
    }
    
    private func performInitialSearch() {
        activityIndicator.startAnimating()
        tableView.isHidden = true
        emptyStateView.isHidden = true
        
        currentPage = 1
        searchResults.removeAll()
        hasMoreResults = true
        isLoading = false
        
        APIService.shared.searchStudies(query: searchQuery, page: currentPage) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
                switch result {
                case .success(let searchResult):
                    let studies = searchResult.studies
                    let totalCount = searchResult.totalCount
                    let hasMore = searchResult.hasMore
                    
                    self?.searchResults = studies
                    self?.totalStudyCount = totalCount
                    self?.hasMoreResults = hasMore
                    
                    self?.resultsLabel.text = "Found \(totalCount) studies for: \"\(self?.searchQuery ?? "")\""
                    
                    self?.tableView.reloadData()
                    self?.tableView.isHidden = false
                    self?.emptyStateView.isHidden = !studies.isEmpty
                    
                    self?.tableView.alpha = 0
                    UIView.animate(withDuration: 0.3) {
                        self?.tableView.alpha = 1
                    }
                    
                    print("Initial search loaded \(studies.count) results")
                    
                case .failure(let error):
                    print("Search failed: \(error)")
                    self?.showError(message: "Search failed. Please check your connection.")
                    self?.emptyStateView.isHidden = false
                }
            }
        }
    }
    
    private func loadMoreResults() {
        guard !isLoading && hasMoreResults else { return }
        
        isLoading = true
        currentPage += 1
        
        print("Loading page \(currentPage)...")
        
        APIService.shared.searchStudies(query: searchQuery, page: currentPage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let searchResult):
                    let newStudies = searchResult.studies
                    let hasMore = searchResult.hasMore
                    
                    if newStudies.isEmpty {
                        self?.hasMoreResults = false
                        print("No more results")
                    } else {
                        let startIndex = self?.searchResults.count ?? 0
                        self?.searchResults.append(contentsOf: newStudies)
                        
                        let newIndexPaths = newStudies.indices.map { index in
                            IndexPath(row: startIndex + index, section: 0)
                        }
                        
                        self?.tableView.beginUpdates()
                        self?.tableView.insertRows(at: newIndexPaths, with: .automatic)
                        self?.tableView.endUpdates()
                        
                        print("Added \(newStudies.count) more results")
                    }
                    
                    self?.hasMoreResults = hasMore
                    
                case .failure(let error):
                    print("Load more failed: \(error)")
                    self?.currentPage -= 1
                }
            }
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count + (hasMoreResults ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row >= searchResults.count {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "LoadMoreCell")
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            loadMoreActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(loadMoreActivityIndicator)
            
            NSLayoutConstraint.activate([
                loadMoreActivityIndicator.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                loadMoreActivityIndicator.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ])
            
            loadMoreActivityIndicator.startAnimating()
            
            let label = UILabel()
            label.text = "Loading more studies..."
            label.textColor = .gray
            label.font = UIFont.systemFont(ofSize: 14)
            label.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: loadMoreActivityIndicator.bottomAnchor, constant: 10),
                label.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor)
            ])
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ResultCell
        let study = searchResults[indexPath.row]
        cell.configure(with: study)
        
        cell.onFavoriteTapped = { studyId, isFavorite in
            if isFavorite {
                PersistenceManager.shared.saveFavorite(
                    studyName: study.name,
                    studyId: studyId,
                    task: study.cognitive_paradigm_cogatlas ?? "Neuroscience Study"
                )
            } else {
                PersistenceManager.shared.removeFavorite(studyId: studyId)
            }
            
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= searchResults.count - 3 && !isLoading && hasMoreResults {
            loadMoreResults()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row >= searchResults.count ? 80 : 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < searchResults.count else {
            tableView.deselectRow(at: indexPath, animated: false)
            return
        }
        
        let study = searchResults[indexPath.row]
        let detailVC = StudyDetailViewController()
        detailVC.study = study
        navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class ResultCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let typeLabel = UILabel()
    private let taskLabel = UILabel()
    private let previewImageView = UIImageView()
    private let favoriteButton = UIButton(type: .system)
    private var studyId: Int = 0
    private var isFavorite = false
    
    var onFavoriteTapped: ((Int, Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        // Remove notification observer
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        selectionStyle = .gray
        
        previewImageView.contentMode = .scaleAspectFit
        previewImageView.layer.cornerRadius = 6
        previewImageView.clipsToBounds = true
        previewImageView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(previewImageView)
        
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoriteButton.tintColor = UIColor(red: 247/255, green: 168/255, blue: 184/255, alpha: 1.0)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(favoriteButton)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.0)
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        typeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        typeLabel.textColor = UIColor.darkGray
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(typeLabel)
        
        taskLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        taskLabel.textColor = UIColor.darkGray
        taskLabel.numberOfLines = 1
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(taskLabel)
        
        NSLayoutConstraint.activate([
            previewImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            previewImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            previewImageView.widthAnchor.constraint(equalToConstant: 70),
            previewImageView.heightAnchor.constraint(equalToConstant: 70),
            
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: previewImageView.trailingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -10),
            
            typeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            typeLabel.leadingAnchor.constraint(equalTo: previewImageView.trailingAnchor, constant: 15),
            typeLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -10),
            
            taskLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 5),
            taskLabel.leadingAnchor.constraint(equalTo: previewImageView.trailingAnchor, constant: 15),
            taskLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -10),
            taskLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -15)
        ])
    }
    
    private func setupNotifications() {
        // Listen for favorites changes
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(favoritesDidChange),
                name: .favoritesChanged,  // Changed to .favoritesChanged
                object: nil
            )
    }
    
    @objc private func favoritesDidChange() {
        // Update the star state when favorites change
        DispatchQueue.main.async {
            self.isFavorite = PersistenceManager.shared.isFavorite(studyId: self.studyId)
            self.updateFavoriteButton()
        }
    }
    
    func configure(with study: NeuroVaultImage) {
        self.studyId = study.id
        
        titleLabel.text = study.displayName
        typeLabel.text = study.displayTask
        taskLabel.text = study.cleanDescription
        
        isFavorite = PersistenceManager.shared.isFavorite(studyId: study.id)
        updateFavoriteButton()
        
        if let thumbnailURL = study.thumbnail {
            APIService.shared.downloadImage(from: thumbnailURL) { [weak self] result in
                DispatchQueue.main.async {
                    if case .success(let image) = result {
                        self?.previewImageView.image = image
                    } else {
                        self?.previewImageView.image = UIImage(systemName: "brain.head.profile")
                        self?.previewImageView.tintColor = .lightGray
                    }
                }
            }
        } else {
            previewImageView.image = UIImage(systemName: "brain.head.profile")
            previewImageView.tintColor = .lightGray
        }
    }
    
    private func updateFavoriteButton() {
        let imageName = isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        favoriteButton.tintColor = isFavorite ?
            UIColor(red: 247/255, green: 168/255, blue: 184/255, alpha: 1.0) :
            UIColor.gray
    }
    
    @objc private func favoriteButtonTapped() {
        isFavorite.toggle()
        updateFavoriteButton()
        onFavoriteTapped?(studyId, isFavorite)
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
