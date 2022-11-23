//
//  Extensions.swift
//  Stocks
//
//  Created by Sherzod on 15/11/22.
//

import Foundation
import UIKit

// MARK: - Framing

extension UIView {
    var width: CGFloat{
        frame.size.width
    }
    
    var height: CGFloat{
        frame.size.height
    }
    
    var left: CGFloat{
        frame.origin.x
    }
    
    var right: CGFloat{
        left + width
    }
    
    var top: CGFloat{
        frame.origin.y
    }
    
    var bottom: CGFloat{
        top + height
    }
}
