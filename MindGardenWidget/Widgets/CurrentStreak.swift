//
//  CurrentStreak.swift
//  MindGarden
//
//  Created by Vishal Davara on 25/05/22.
//

import SwiftUI
import WidgetKit
import Intents

struct CurrentStreakWidget : View {
    @State var streakNumber : Int
    var body: some View {
        GeometryReader { g in
            ZStack {
                Color("darkWhite")
                VStack(spacing:0) {
                    HStack(spacing:0) {
                        Spacer()
                        VStack{
                            Spacer()
                            Text("\(streakNumber)")
                                .foregroundColor(Color("textNumber"))
                                .font(Font.fredoka(.bold, size: 32))
                                .padding(.bottom,0)
                        }.padding(0)
                        Image("smallWidget")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: g.size.width * 0.6)
                    }
                    .padding(.trailing,10)
                    .padding(.top,20)
                    HStack {
                        Text("Days")
                            .foregroundColor(Color("black2"))
                            .font(Font.fredoka(.bold, size: 32))
                        Spacer()
                        Image("fire")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15)
                    }
                    .padding(.horizontal)
                    .padding(.bottom,20)
                }
            }
            .frame(width: g.size.width, height: g.size.height, alignment: .center)
        }
    }
}
