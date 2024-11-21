//
//  PhotoCollectionViewCell.swift
//  CR
//
//  Created by Данил Забинский on 21.11.2024.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    private lazy var titleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.ultraTiny
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(titleImage)
        NSLayoutConstraint.activate([
            titleImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func setupWithImage(_ image: UIImage) {
        self.titleImage.image = image
    }
}

extension PhotoCollectionViewCell {
    static var identifier: String {
        "\(self)"
    }
}
