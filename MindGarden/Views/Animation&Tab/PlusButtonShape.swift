//
//  PlusButtonShape.swift
//  MindGarden
//
//  Created by Vishal Davara on 20/02/22.
//

import SwiftUI

struct PlusButtonShape: Shape {
    let cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: .allCorners,
                                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        return Path(path.cgPath)
    }
}
