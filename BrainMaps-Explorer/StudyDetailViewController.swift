//
//  StudyDetailViewController.swift
//  BrainMaps_Explorer
//
//  Created by Fariha Kha on 11/10/25.
//

import UIKit

class StudyDetailViewController: UIViewController {
    
    var study: NeuroVaultImage?
    private var isFavorite = false
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let brainImageView = UIImageView()
    private let titleLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    private let infoStack = UIStackView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Study Details"
        view.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 251/255, alpha: 1.0)
        setupUI()
        loadStudyData()
        checkIfFavorite()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let favoritesButton = UIBarButtonItem(
            image: UIImage(systemName: "star.fill"),
            style: .plain,
            target: self,
            action: #selector(navFavoritesButtonTapped)
        )
        favoritesButton.tintColor = UIColor(red: 247/255, green: 168/255, blue: 184/255, alpha: 1.0)
        navigationItem.rightBarButtonItem = favoritesButton
    }
    
    @objc private func navFavoritesButtonTapped() {
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
        setupScrollView()
        setupBrainImageView()
        setupTitleLabel()
        setupFavoriteButton()
        setupInfoStack()
        setupActivityIndicator()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupBrainImageView() {
        brainImageView.contentMode = .scaleAspectFit
        brainImageView.layer.cornerRadius = 10
        brainImageView.clipsToBounds = true
        brainImageView.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.99, alpha: 1.0)
        brainImageView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        brainImageView.layer.borderWidth = 1
        brainImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(brainImageView)
        
        NSLayoutConstraint.activate([
            brainImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            brainImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            brainImageView.widthAnchor.constraint(equalToConstant: 300),
            brainImageView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    private func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.0)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: brainImageView.bottomAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25)
        ])
    }
    
    private func setupFavoriteButton() {
        favoriteButton.setTitle("☆ Add to Favorites", for: .normal)
        favoriteButton.backgroundColor = UIColor(red: 247/255, green: 168/255, blue: 184/255, alpha: 1.0)
        favoriteButton.setTitleColor(.white, for: .normal)
        favoriteButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        favoriteButton.layer.cornerRadius = 8
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        contentView.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            favoriteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 200),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupInfoStack() {
        infoStack.axis = .vertical
        infoStack.spacing = 12
        infoStack.distribution = .fill
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(infoStack)
        
        NSLayoutConstraint.activate([
            infoStack.topAnchor.constraint(equalTo: favoriteButton.bottomAnchor, constant: 30),
            infoStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            infoStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            infoStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor(red: 247/255, green: 168/255, blue: 184/255, alpha: 1.0)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: brainImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: brainImageView.centerYAnchor)
        ])
    }
    
    // Load Study Data
    private func loadStudyData() {
        guard let study = study else { return }
        
        // Set title using cleaned display name
        titleLabel.text = study.displayName
        
        // Load image
        if let thumbnailURL = study.thumbnail {
            activityIndicator.startAnimating()
            APIService.shared.downloadImage(from: thumbnailURL) { [weak self] result in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    if case .success(let image) = result {
                        self?.brainImageView.image = image
                    } else {
                        self?.brainImageView.image = UIImage(systemName: "brain.head.profile")
                        self?.brainImageView.tintColor = .lightGray
                    }
                }
            }
        } else {
            brainImageView.image = UIImage(systemName: "brain.head.profile")
            brainImageView.tintColor = .lightGray
        }
        
        // Add ALL data cards
        addInfoCard(title: "Study Type", value: study.displayTask)
        
        if let mapType = study.map_type, !mapType.isEmpty {
            addInfoCard(title: "Analysis Type", value: mapType)
        }
        
        if let modality = study.modality, !modality.isEmpty {
            addInfoCard(title: "Imaging Method", value: modality)
        }
        
        // Add rich demographic data card
        addDemographicDataCard()
        
        // Add quantitative data card
        addDataVisualizationCard()
        
        // Add technical details card
        addTechnicalDetailsCard()
        
        // Add description last
        let description = study.cleanDescription
        if !description.isEmpty {
            addInfoCard(title: "Description", value: description)
        }
    }
    
    // MARK: - Basic Info Card
    private func addInfoCard(title: String, value: String) {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 8
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.05
        card.layer.shadowOffset = CGSize(width: 0, height: 1)
        card.layer.shadowRadius = 2
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 16)
        valueLabel.textColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 0.8)
        valueLabel.numberOfLines = 0
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -15),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            valueLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 15),
            valueLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -15),
            valueLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -15)
        ])
        
        infoStack.addArrangedSubview(card)
    }
    
    // Rich Demographic Data Card
    private func addDemographicDataCard() {
        guard let study = study else { return }
        
        // Only show if have demographic data
        guard study.hasDemographicData else { return }
        
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 12
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.08
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowRadius = 4
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "Participant Information"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)
        
        // Create a grid for demographic data
        let gridStack = UIStackView()
        gridStack.axis = .vertical
        gridStack.spacing = 10
        gridStack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(gridStack)
        
        // Helper to add data rows
        func addGridRow(title: String, value: String?) {
            guard let value = value, !value.isEmpty else { return }
            
            let row = UIView()
            row.translatesAutoresizingMaskIntoConstraints = false
            
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            titleLabel.textColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 0.7)
            titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            
            let valueLabel = UILabel()
            valueLabel.text = value
            valueLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            valueLabel.textColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.0)
            valueLabel.textAlignment = .right
            
            let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
            stack.axis = .horizontal
            stack.distribution = .fill
            stack.spacing = 10
            stack.translatesAutoresizingMaskIntoConstraints = false
            row.addSubview(stack)
            
            NSLayoutConstraint.activate([
                stack.topAnchor.constraint(equalTo: row.topAnchor),
                stack.leadingAnchor.constraint(equalTo: row.leadingAnchor),
                stack.trailingAnchor.constraint(equalTo: row.trailingAnchor),
                stack.bottomAnchor.constraint(equalTo: row.bottomAnchor)
            ])
            
            gridStack.addArrangedSubview(row)
        }
        
        // Add available demographic data
        if let age = study.age {
            addGridRow(title: "Age:", value: "\(age)")
        }
        
        if let sex = study.sex {
            addGridRow(title: "Sex:", value: sex)
        }
        
        if let race = study.race {
            addGridRow(title: "Race:", value: race)
        }
        
        if let ethnicity = study.ethnicity {
            addGridRow(title: "Ethnicity:", value: ethnicity)
        }
        
        if let handedness = study.handedness {
            addGridRow(title: "Handedness:", value: handedness)
        }
        
        if let yrsSch = study.YRS_SCH {
            addGridRow(title: "Education:", value: "\(yrsSch) years")
        }
        
        if let subjectId = study.SubjectID {
            addGridRow(title: "Participant ID:", value: String(format: "%.0f", subjectId))
        }
        
        if let rating = study.Rating {
            addGridRow(title: "Emotion Rating:", value: "\(rating)/9")
        }
        
        if let species = study.subject_species {
            addGridRow(title: "Species:", value: species)
        }
        
        if let subjects = study.number_of_subjects {
            addGridRow(title: "Total Participants:", value: "\(subjects)")
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            
            gridStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            gridStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            gridStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            gridStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20)
        ])
        
        infoStack.addArrangedSubview(card)
    }
    
    // Quantitative Data Visualization Card
    private func addDataVisualizationCard() {
        guard let study = study else { return }
        
        guard study.hasQuantitativeData else { return }
        
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 12
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.08
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowRadius = 4
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "Study Data Metrics"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)
        
        let metricsStack = UIStackView()
        metricsStack.axis = .vertical
        metricsStack.spacing = 12
        metricsStack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(metricsStack)
        
        // Add metrics if available
        if let subjects = study.number_of_subjects {
            addMetricRow(to: metricsStack, title: "Sample Size", value: "\(subjects) participants", percentage: nil)
        }
        
        if let coverage = study.brain_coverage {
            addMetricRow(to: metricsStack, title: "Brain Coverage", value: String(format: "%.1f%%", coverage), percentage: coverage / 100.0)
        }
        
        if let badVoxels = study.perc_bad_voxels {
            addMetricRow(to: metricsStack, title: "Data Quality", value: String(format: "%.1f%% clean", 100 - badVoxels), percentage: (100 - badVoxels) / 100.0)
        }
        
        if let outsideVoxels = study.perc_voxels_outside {
            addMetricRow(to: metricsStack, title: "Data Within Brain", value: String(format: "%.1f%%", 100 - outsideVoxels), percentage: (100 - outsideVoxels) / 100.0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            
            metricsStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            metricsStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            metricsStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            metricsStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20)
        ])
        
        infoStack.addArrangedSubview(card)
    }
    
    private func addMetricRow(to stack: UIStackView, title: String, value: String, percentage: Double?) {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(titleLabel)
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        valueLabel.textColor = UIColor(red: 130/255, green: 199/255, blue: 230/255, alpha: 1.0)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: row.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: row.topAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: row.trailingAnchor)
        ])
        
        if let percentage = percentage {
            let progressBar = UIProgressView()
            progressBar.progress = Float(percentage)
            progressBar.progressTintColor = UIColor(red: 130/255, green: 199/255, blue: 230/255, alpha: 1.0)
            let pinkColor = UIColor(red: 247/255, green: 168/255, blue: 184/255, alpha: 1.0)
            progressBar.trackTintColor = pinkColor.withAlphaComponent(0.2)
            progressBar.layer.cornerRadius = 4
            progressBar.clipsToBounds = true
            progressBar.translatesAutoresizingMaskIntoConstraints = false
            row.addSubview(progressBar)
            
            NSLayoutConstraint.activate([
                progressBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
                progressBar.leadingAnchor.constraint(equalTo: row.leadingAnchor),
                progressBar.trailingAnchor.constraint(equalTo: row.trailingAnchor),
                progressBar.heightAnchor.constraint(equalToConstant: 8),
                progressBar.bottomAnchor.constraint(equalTo: row.bottomAnchor)
            ])
        } else {
            valueLabel.bottomAnchor.constraint(equalTo: row.bottomAnchor).isActive = true
            row.heightAnchor.constraint(equalToConstant: 25).isActive = true
        }
        
        stack.addArrangedSubview(row)
    }
    
    // MARK: - Technical Details Card
    private func addTechnicalDetailsCard() {
        guard let study = study else { return }
        
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 12
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.08
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowRadius = 4
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "Technical Details"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)
        
        let detailsStack = UIStackView()
        detailsStack.axis = .vertical
        detailsStack.spacing = 8
        detailsStack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(detailsStack)
        
        // Add technical details
        func addDetailRow(title: String, value: String?) {
            guard let value = value, !value.isEmpty else { return }
            
            let row = UIView()
            row.translatesAutoresizingMaskIntoConstraints = false
            
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            titleLabel.textColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 0.7)
            
            let valueLabel = UILabel()
            valueLabel.text = value
            valueLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            valueLabel.textColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.0)
            valueLabel.textAlignment = .right
            
            let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
            stack.axis = .horizontal
            stack.distribution = .fill
            stack.spacing = 10
            stack.translatesAutoresizingMaskIntoConstraints = false
            row.addSubview(stack)
            
            NSLayoutConstraint.activate([
                stack.topAnchor.constraint(equalTo: row.topAnchor),
                stack.leadingAnchor.constraint(equalTo: row.leadingAnchor),
                stack.trailingAnchor.constraint(equalTo: row.trailingAnchor),
                stack.bottomAnchor.constraint(equalTo: row.bottomAnchor)
            ])
            
            detailsStack.addArrangedSubview(row)
        }
        
        if let analysisLevel = study.analysis_level {
            addDetailRow(title: "Analysis Level:", value: analysisLevel)
        }
        
        if let targetTemplate = study.target_template_image {
            addDetailRow(title: "Brain Template:", value: targetTemplate)
        }
        
        if let dataOrigin = study.data_origin {
            addDetailRow(title: "Data Source:", value: dataOrigin)
        }
        
        if let notMNI = study.not_mni {
            addDetailRow(title: "Standard Space:", value: notMNI ? "No" : "Yes")
        }
        
        if let isValid = study.is_valid {
            addDetailRow(title: "Data Validated:", value: isValid ? "Yes" : "No")
        }
        
        if let smoothness = study.smoothness_fwhm {
            addDetailRow(title: "Image Smoothness:", value: String(format: "%.2f mm", smoothness))
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            
            detailsStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            detailsStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            detailsStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            detailsStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20)
        ])
        
        // Only add the card if technical details exist
        if detailsStack.arrangedSubviews.count > 0 {
            infoStack.addArrangedSubview(card)
        }
    }
    
    // Favorites
    private func checkIfFavorite() {
        guard let study = study else { return }
        isFavorite = PersistenceManager.shared.isFavorite(studyId: study.id)
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        if isFavorite {
            favoriteButton.setTitle("★ Added to Favorites", for: .normal)
            favoriteButton.backgroundColor = UIColor(red: 199/255, green: 184/255, blue: 234/255, alpha: 1.0)
        } else {
            favoriteButton.setTitle("☆ Add to Favorites", for: .normal)
            favoriteButton.backgroundColor = UIColor(red: 247/255, green: 168/255, blue: 184/255, alpha: 1.0)
        }
    }
    
    @objc private func favoriteButtonTapped() {
        guard let study = study else { return }
        
        if isFavorite {
            // Remove from favorites
            PersistenceManager.shared.removeFavorite(studyId: study.id)
            isFavorite = false
        } else {
            // Add to favorites
            PersistenceManager.shared.saveFavorite(
                studyName: study.name,
                studyId: study.id,
                task: study.cognitive_paradigm_cogatlas ?? "Neuroscience Study"
            )
            isFavorite = true
        }
        
        updateFavoriteButton()
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
