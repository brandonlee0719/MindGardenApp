//
//  StatsBox.swift
//  MindGarden
//
//  Created by Dante Kim on 6/19/21.
//

import SwiftUI

struct StatBox: View {
    let label: String
    let img: Image
    let value: String

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Clr.darkWhite)
                .addBorder(.black, width: 1.5, cornerRadius: 14)
                .neoShadow()
            VStack(alignment:.center, spacing:5){
                Text(label)
                    .font(Font.fredoka(.semiBold, size: 12))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 5)
                    .padding(.top,10)
                    .foregroundColor(Clr.black2)
                HStack(spacing:5) {
                    img
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                    Text(value)
                        .font(Font.fredoka(.semiBold, size: 16))
                        .minimumScaleFactor(0.7)
                        .foregroundColor(Clr.black2)
                        .lineLimit(1)
                        .minimumScaleFactor(0.05)
                }
                .padding(.bottom,10)
                .padding(.horizontal, 5)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

struct StatsBox_Previews: PreviewProvider {
    static var previews: some View {
        StatBox(label: "Total Mins", img: Img.iconTotalTime, value: "255")
    }
}
