//
//  PhotosView.swift
//  CR
//
//  Created by Данил Забинский on 21.11.2024.
//

import UIKit

class PhotosView: UIView {
    
    private lazy var screenTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Fonts.big)
        label.text = "Выберите опцию."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var photosColletionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: Constants.screenWidth / 2 - Constants.tiny, height: Constants.screenWidth / 2 - Constants.tiny)
        collectionViewFlowLayout.minimumLineSpacing = Constants.ultraTiny
        collectionViewFlowLayout.minimumInteritemSpacing = Constants.ultraTiny
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.layer.cornerRadius = Constants.ultraTiny
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = Colors.powderBlue
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var stateSegmentControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.backgroundColor = Colors.powderBlue
        NSLayoutConstraint.activate([
            segment.heightAnchor.constraint(equalToConstant: Constants.medium),
        ])
        return segment
    }()
    
    private lazy var dataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            progressBarStackView,
            stateSegmentControl,
            photosColletionView
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constants.tiny
        return stack
    }()
    
    lazy var loadLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Еще не начали"
        label.font = .systemFont(ofSize: Fonts.medium)
        return label
    }()
    
    lazy var cancelLoading: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "stop.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    lazy var loadProgressView: UIProgressView = {
        let progres = UIProgressView()
        progres.translatesAutoresizingMaskIntoConstraints = false
        progres.trackTintColor = Colors.carribianSea
        progres.progress = 0
        return progres
    }()
    
    private lazy var titleAndButon: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            loadLabel,
            cancelLoading
        ])
        stack.spacing = Constants.tiny
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var progressBarStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleAndButon,
            loadProgressView
        ])
        stack.axis = .vertical
        stack.spacing = Constants.tiny
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(segmentAction: UIAction) {
        super.init(frame: .zero)
        self.stateSegmentControl.addAction(segmentAction, for: .valueChanged)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSegmentData(title: [String]) {
        stateSegmentControl.removeAllSegments()
        for (index, item) in title.enumerated() {
            stateSegmentControl.insertSegment(withTitle: item, at: index, animated: false)
        }
    }
    
    func getSegmentSelectionIndex() -> Int {
        self.stateSegmentControl.selectedSegmentIndex
    }
    
    func segmentDeactivate() {
        self.stateSegmentControl.isEnabled = false
    }
    
    func segmentActivate() {
        self.stateSegmentControl.isEnabled = true
    }
    
    private func setup() {
        setupLayout()
    }
    
    private func setupLayout() {
        self.addSubview(screenTitle)
        self.addSubview(dataStackView)
        NSLayoutConstraint.activate([
            screenTitle.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Constants.ultraTiny),
            screenTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            dataStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Constants.ultraTiny),
            dataStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.ultraTiny),
            dataStackView.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: Constants.medium),
            dataStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.tiny),
        ])
    }
}

extension PhotosView: UICollectionViewDelegate {
    
}
