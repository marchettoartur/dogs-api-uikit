//
//  UIColor+.swift
//  DogsApp
//
//  Created by Artur Marchetto on 30/05/2022.
//

import UIKit

@available(iOS 13.0, OSX 10.15, *)
extension UIColor {
    
    public static func dynamic(light: String, dark: String) -> UIColor {
        
        let lightColor: UIColor? = UIColor(hex: light)
        let darkColor: UIColor? = UIColor(hex: dark)
        
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            
            if traitCollection.userInterfaceStyle == .light {
                return lightColor ?? UIColor.clear
            } else {
                return darkColor ?? UIColor.clear
            }
        }
    }
    
    public static func dynamic(light: UIColor, dark: UIColor) -> UIColor {
        
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            
            if traitCollection.userInterfaceStyle == .light {
                return light
            } else {
                return dark
            }
        }
    }
    
    public convenience init?(hex color: String) {
        
        let r, g, b, a: CGFloat
        
        var startIndex: String.Index?
        
        if color.hasPrefix("#") {
            startIndex = color.index(color.startIndex, offsetBy: 1)
        } else {
            startIndex = color.startIndex
        }
        
        let hexColorTmp = String(color[startIndex!...])
        var hexColor = String()
        
        if hexColorTmp.count == 8 {
            hexColor = hexColorTmp
        } else if hexColorTmp.count == 6 {
            hexColor = hexColorTmp + "FF"
        }
        
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexInt64(&hexNumber) {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8)  / 255
            a = CGFloat(hexNumber  & 0x000000ff)        / 255
            
            self.init(red: r, green: g, blue: b, alpha: a)
            return
        }
        
        return nil
    }
}
