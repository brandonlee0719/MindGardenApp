//
//  PlusCoins.swift
//  MindGarden
//
//  Created by Dante Kim on 4/3/22.
//

import SwiftUI

struct PlusCoins: View {
    @Binding var coins: Int
    
    var body: some View {
        HStack(spacing: -15) {
            Img.coin
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 30)
                .neoShadow()
                .zIndex(100)
            ZStack {
                Rectangle()
                    .fill(Clr.darkWhite)
                    .neoShadow()
                Text("\(coins)")
                    .font(Font.fredoka(.semiBold, size: coins >= 1000 ? 18 : 20))
                    .foregroundColor(Clr.black2)
            }.frame(width: 80, height: 20)
            Circle()
                .fill(Clr.brightGreen)
                .frame(height:35)
                .neoShadow()
                .zIndex(100)
                .overlay(
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(Font.system(size: 18, weight: .bold))
                        
                )
        }.frame(width: 110)
    }
}

struct PlusCoins_Previews: PreviewProvider {
    static var previews: some View {
        PlusCoins(coins: .constant(40))
        
    }
}
