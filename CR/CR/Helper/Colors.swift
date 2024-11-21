//
//  Colors.swift
//  mathHW
//
//  Created by Данил Забинский on 09.11.2024.
//

import Foundation
import UIKit

class Colors {
    static let carribianSea = UIColor(hex: "#3C6E71")
    static let jetColor = UIColor(hex: "#353535")
    static let lightGray = UIColor(hex: "#D9D9D9")
    static let paynesGray = UIColor(hex: "#455D70")
    static let powderBlue = UIColor(hex: "#A6B9C9")
    static let dimGray = UIColor(hex: "#666666")
    static let whiteGray: UIColor = .systemGray6
    static let skyBlue = UIColor(hex: "#87cefa")
}


extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
