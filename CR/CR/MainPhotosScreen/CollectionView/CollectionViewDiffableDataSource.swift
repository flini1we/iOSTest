//
//  CollectionViewDiffableDataSource.swift
//  CR
//
//  Created by Данил Забинский on 21.11.2024.
//

import Foundation
import UIKit

class CollectionViewDiffableDataSource: NSObject {
    var diffableDataSource: UICollectionViewDiffableDataSource<CollectionViewSections, UIImage>?
    
    func setupDataSource(with collectionView: UICollectionView, photos: [UIImage]) {
        diffableDataSource = UICollectionViewDiffableDataSource<CollectionViewSections, UIImage>(collectionView: collectionView, cellProvider: { collectionView, indexPath, image in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
            cell.setupWithImage(image)
            return cell
        })
        applySnapshot(photos: photos)
    }
    
    private func applySnapshot(photos: [UIImage]) {
        var snaphot = NSDiffableDataSourceSnapshot<CollectionViewSections, UIImage>()
        
        snaphot.appendSections([.main])
        snaphot.appendItems(photos)
        
        diffableDataSource?.apply(snaphot, animatingDifferences: false)
    }
}
