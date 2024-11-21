//
//  PhotosModel.swift
//  CR
//
//  Created by Данил Забинский on 21.11.2024.
//

import Foundation
import UIKit

enum CollectionViewSections {
    case main
}

enum FilterType : String, CaseIterable {
    case Chrome = "CIPhotoEffectChrome"
    case Fade = "CIPhotoEffectFade"
    case Instant = "CIPhotoEffectInstant"
    case Mono = "CIPhotoEffectMono"
    case Noir = "CIPhotoEffectNoir"
    case Process = "CIPhotoEffectProcess"
    case Tonal = "CIPhotoEffectTonal"
    case Transfer =  "CIPhotoEffectTransfer"
}

class PhotosModel {
    
    var selectedIndex: Int = -1
    let loadingTitleBeginning = "Загрузка..."
    let loadingTitleFinished = "Загрузка завершена"
    let loadingTitleCanceled = "Загрузка отменена"
    var isCancelled = false
    
    private let images: [UIImage] = [
        .image1,
        .image2,
        .image3,
        .image4,
        .image5,
        .image6,
        .image7,
        .image8,
        .image9,
        .image10,
        .image11,
    ]
    
    func obtainImages() -> [UIImage] {
        return images
    }
    
    func obtainTitle() -> [String] {
        return ["Параллельно", "Последовательно"]
    }
    
    func obtainSelectedType() -> String {
        selectedIndex == 0 ? "Параллельно" : "Последовательно"
    }
    
    @MainActor
    func loadImmitation(progressHandler: @escaping (Float) -> Void) async -> Bool {
        let totalSteps = 10
        
        for i in 1...totalSteps {
            if isCancelled {
                return false
            }

            await withCheckedContinuation { continuation in
                DispatchQueue.global().async {
                    sleep(1)
                    continuation.resume()
                }
            }
            let progress = Float(i) / Float(totalSteps)
            progressHandler(progress)
        }
        return true
    }
}
