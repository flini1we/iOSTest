//
//  ViewController.swift
//  CR
//
//  Created by Данил Забинский on 21.11.2024.
//

import UIKit

class PhotosController: UIViewController {
    
    private var customView: PhotosView {
        view as! PhotosView
    }
    private let dataManager = PhotosModel()
    private lazy var images = dataManager.obtainImages()
    private var collectionViewDiffableDataSource: CollectionViewDiffableDataSource?
    private lazy var segmentControllAction: UIAction = {
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            dataManager.selectedIndex = customView.getSegmentSelectionIndex()
            let group = DispatchGroup()
            customView.segmentDeactivate()
            
            if dataManager.obtainSelectedType() == "Параллельно" {
                let concurrentQueue = DispatchQueue(label: "com.my.queue", attributes: .concurrent)
                
                for (index, image) in images.enumerated() {
                    group.enter()
                    concurrentQueue.async { [weak self] in
                        guard let self else { return }
                        let oldImage = image
                        let newImage = image.addFilter(filter: FilterType.allCases.randomElement()!)
                        images[index] = newImage
                        
                        if var snapshot = self.collectionViewDiffableDataSource?.diffableDataSource?.snapshot() {
                            snapshot.insertItems([newImage], beforeItem: oldImage)
                            snapshot.deleteItems([oldImage])
                            
                            DispatchQueue.main.async {
                                self.collectionViewDiffableDataSource?.diffableDataSource?.apply(snapshot, animatingDifferences: true)
                            }
                        }
                        group.leave()
                    }
                }
                group.notify(queue: DispatchQueue.main) {
                    self.customView.segmentActivate()
                }
            } else {
                let serialOperationQueue = OperationQueue()
                serialOperationQueue.maxConcurrentOperationCount = 1
                
                for (index, image) in images.enumerated() {
                    group.enter()
                    let upgradeImageOperation = BlockOperation { [weak self] in
                        guard let self else { return }
                        let oldImage = image
                        let newImage = image.addFilter(filter: FilterType.allCases.randomElement()!)
                        images[index] = newImage
                        
                        if var snapshot = self.collectionViewDiffableDataSource?.diffableDataSource?.snapshot() {
                            snapshot.insertItems([newImage], beforeItem: oldImage)
                            snapshot.deleteItems([oldImage])
                            
                            DispatchQueue.main.async {
                                self.collectionViewDiffableDataSource?.diffableDataSource?.apply(snapshot, animatingDifferences: true)
                            }
                        }
                        sleep(1) // иммитация задержки помню что так нельзя но чтоб было видно наглядно
                        group.leave()
                    }
                    serialOperationQueue.addOperation(upgradeImageOperation)
                }
                group.notify(queue: DispatchQueue.main) {
                    self.customView.segmentActivate()
                }
            }
        }
        return action
    }()
    
    private lazy var stopAction: UIAction = {
        let action = UIAction { _ in
            self.dataManager.isCancelled = true
        }
        return action
    }()
    
    private lazy var calculateAction: UIAction = {
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            customView.loadLabel.text = dataManager.loadingTitleBeginning
            customView.cancelLoading.isHidden = false
            customView.cancelLoading.addAction(stopAction, for: .touchUpInside)
            Task {
                let finished = await self.dataManager.loadImmitation { num in
                    self.customView.loadProgressView.progress = num
                }
                if finished {
                    self.customView.loadLabel.text = self.dataManager.loadingTitleFinished
                    self.customView.cancelLoading.isHidden = true
                } else {
                    self.customView.loadLabel.text = self.dataManager.loadingTitleCanceled
                    self.dataManager.isCancelled.toggle()
                    self.customView.loadProgressView.progress = 0
                }
            }
        }
        return action
    }()
    
    override func loadView() {
        super.loadView()
        view = PhotosView(segmentAction: segmentControllAction)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .white
        customView.setSegmentData(title: dataManager.obtainTitle())
        collectionViewDiffableDataSource = CollectionViewDiffableDataSource()
        collectionViewDiffableDataSource?.setupDataSource(with: customView.photosColletionView, photos: images)
        seupNavigationTitle()
    }
    
    private func seupNavigationTitle() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Начать вычисления", primaryAction: calculateAction)
    }
}

extension UIImage {
    func addFilter(filter : FilterType) -> UIImage {
        let filter = CIFilter(name: filter.rawValue)
        
        let ciInput = CIImage(image: self)
        filter?.setValue(ciInput, forKey: "inputImage")
        
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)

        return UIImage(cgImage: cgImage!)
    }
}

