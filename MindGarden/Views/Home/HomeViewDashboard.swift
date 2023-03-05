//
//  HomeViewDashboard.swift
//  MindGarden
//
//  Created by Vishal Davara on 02/07/22.
//

import SwiftUI
// Font sizes: 12, 16, 28
struct HomeViewDashboard: View {
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @EnvironmentObject var medModel: MeditationViewModel
    @EnvironmentObject var bonusModel: BonusViewModel
    @Binding var showModal : Bool
    @Binding var totalBonuses : Int
    @Binding var greeting : String
    @State var name : String
    @Binding var activeSheet: Sheet?
    @Binding var showIAP: Bool
    @Binding var streakNumber: Int
    @State var showRecFavs = false
    @State var sheetType: [Int] = []
    @State var sheetTitle: String = ""
    let height = 20.0
    var body: some View {
        ZStack {
            VStack(spacing: 30){
                HStack {
                    VStack(alignment:.leading) {
                        HStack {
                            Text("\(Date().toString(withFormat: "EEEE, MMM dd"))")
                                .font(Font.fredoka(.regular, size: 20))
                                .foregroundColor(Clr.darkGray)

                        }
                   
                        Text("\(greeting), \(name)")
                            .font(Font.fredoka(.medium, size: 28))
                            .foregroundColor(Clr.black2)
                    }
                    Spacer()
                }
                .padding(.top,32)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 8)
        }
    }
}
