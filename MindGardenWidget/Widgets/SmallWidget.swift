//
//  smallWidget.swift
//  MindGardenWidgetExtension
//
//  Created by Vishal Davara on 30/07/22.
//

import SwiftUI

struct SmallWidget: View {
    @State var streak: Int
    
    var body: some View {
        ZStack {
            Image("smallWidgetBackground")
                .resizable()
                .aspectRatio(contentMode: .fit)
            HStack(spacing:0) {
                VStack(alignment:.leading,spacing:0) {
                    Text("\(streak)")
                        .font(Font.fredoka(.bold, size: 40))
                        .foregroundColor(Color("smallWidgetText"))
                        .shadow(color: .black, radius: 2, x: 2, y: 2)
                        .shadow(color: .black, radius: 2, x: -2, y: -2)
                        .padding(.vertical,0)
                    Text("day streak")
                        .font(Font.fredoka(.bold, size: 20))
                        .foregroundColor(Color.white)
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 2, y: 2)
                        .shadow(color: .black.opacity(0.5), radius: 2, x: -2, y: -2)
                        .offset(y:-8)
                    Spacer()
                }
                Spacer()
            }.padding(.leading, 24)
            .padding(.top,5)
        }

    }
}
