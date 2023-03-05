//
//  Numbers+Extension.swift
//  MindGarden
//
//  Created by Dante Kim on 8/27/21.
//

import UIKit

extension Double {
    func toInt() -> Int? {
        if self >= Double(Int.min) && self < Double(Int.max) {
            return Int(self)
        } else {
            return nil
        }
    }
}
