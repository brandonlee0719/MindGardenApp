//
//  ConfirmModal.swift
//  MindGarden
//
//  Created by Dante Kim on 5/1/22.
//

import SwiftUI

struct ConfirmModal: View {
    @EnvironmentObject var userModel: UserViewModel
    @Binding var shown: Bool
    @Binding var showMainModal: Bool
    @State private var showPlantAnimation = false

    var body: some View {
        GeometryReader { g in
            VStack {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center, spacing: 0) {
                        Text("Unlock this plant species?")
                            .foregroundColor(Clr.black1)
                            .font(Font.fredoka(.bold, size: 24))
                            .lineLimit(1)
                            .minimumScaleFactor(0.05)
                            .multilineTextAlignment(.center)
                            .padding(.vertical)
                        Text("Are you sure you want to spend \(userModel.willBuyPlant?.price ?? 0) coins on unlocking \(userModel.willBuyPlant?.title ?? "")")
                            .font(Font.fredoka(.medium, size: 18))
                            .foregroundColor(Clr.black2.opacity(0.7))
                            .lineLimit(2)
                            .minimumScaleFactor(0.05)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        HStack(alignment: .center, spacing: 10) {
                            Button {
                                Analytics.shared.log(event: .store_tapped_confirm_modal_cancel)
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    shown = false
                                }
                            } label: {
                                Text("Cancel")
                                    .font(Font.fredoka(.bold, size: 18))
                                    .foregroundColor(.white)
                                    .frame(width: g.size.width/3, height: 40)
                                    .background(Color.gray)
                                    .cornerRadius(20)
                                    .neoShadow()
                            }
                            Button {
                                Analytics.shared.log(event: .store_tapped_confirm_modal_confirm)
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    if userModel.willBuyPlant?.title == "Real Tree" {
                                        userModel.buyPlant(realTree: true)
//                                        if !userModel.ownedPlants.contains(where: { plt in
//                                            plt.title == "Real Tree"
//                                        }) {
//                                        }
                                        showPlantAnimation = true
                                        
                                    } else {
                                        userModel.buyPlant()
                                        showPlantAnimation = true
                                    }
                                    shown = false
                                    showMainModal = false
                                }
                            } label: {
                                Text("Confirm")
                                    .font(Font.fredoka(.bold, size: 18))
                                    .foregroundColor(.white)
                                    .frame(width: g.size.width/3, height: 40)
                                    .background(Clr.darkgreen)
                                    .clipShape(Capsule())
                                    .neoShadow()
                            }
                        }.padding()
                    }.frame(width: g.size.width * 0.85, height: g.size.height * 0.30, alignment: .center)
                        .background(Clr.darkWhite)
                        .cornerRadius(20)
                    Spacer()
                }
                Spacer()
            }
        }.fullScreenCover(isPresented: $showPlantAnimation) {
            PlantGrowing()
                .environmentObject(userModel)
        }
    }
}
