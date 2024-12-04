//
//  Color+StringExtension.swift
//  Set Buddy
//
//  Created by Christian Schuster on 23.09.23.
//

import Foundation
import SwiftUI
import UIKit

extension Color {
    func rgbaString() -> String {
        
        // Prepare the individual values
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        // Convert to UIColor and read out
        let convertedColor = UIColor(self)
        convertedColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        
        // Array of float values to array of string values
        let rgba = [r, g, b, a]
            .map {
                String(format: "%f", Float($0))
            }
            .joined(separator: ",")
        
        // - TEST - Log to inspect string separation - TEST -
        //        let finalString = rgba.components(separatedBy: ",")
        //        print("Array:\(finalString)")
        
        
        
        return rgba
        //return uppercased ? rgba.uppercased() : rgba
        
        
    }
    
    init (from rgbaString: String) {
        
        let components = rgbaString.components(separatedBy: ",")
        
        // Prepare RGBA values
        var colors: [CGFloat] = [0.0, 0.0, 0.0, 0.0]
        
        
        components.enumerated().forEach { (index, item) in
            
            // Read element from provided values
            if let elementDouble = Double(item) {
                if (colors.count > index) { // Protect against too long string elements
                    colors[index] = CGFloat(elementDouble) // Change the color to the provided value
                }
            }
        }
        
//        let _: [String] = components.enumerated().map { (index, element) in
//            
//            // Adjust the value according to the provided element
//            if let elementDouble = Double(element) {
//                colors[index] = CGFloat(elementDouble)
//            }
//            
//            return String("Index \(index), element \(element)")
//        }
        
        
        
        
        let generatedColor = UIColor(red: colors[0],
                                     green: colors[1],
                                     blue: colors[2],
                                     alpha: colors[3])
        
        self = Color(generatedColor)
        
    }
    
}

