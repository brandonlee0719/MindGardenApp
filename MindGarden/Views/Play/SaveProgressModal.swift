//
//  NewUpdateModal.swift
//  MindGarden
//
//  Created by Dante Kim on 10/4/21.
//

import SwiftUI

struct SaveProgressModal: View {
    @Binding var shown: Bool
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        GeometryReader { g in
            VStack(spacing: 10) {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center, spacing: 0) {
                        HStack {
                            Spacer()
                            Text("✍️  Save Your Progress?")
                                .font(Font.fredoka(.bold, size: 24))
                                .foregroundColor(Clr.black2)
                                .frame(height: g.size.height * 0.12)
                            Spacer()
                        }.padding([.horizontal, .top])
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation {
                                Analytics.shared.log(event: .finished_save_progress)
                                fromOnboarding = true
                                shown = false
                                viewRouter.currentPage = .authentication
                                UserDefaults.standard.setValue(true, forKey: "saveProgress")
                            }
                        } label: {
                            Capsule()
                                .fill(Clr.brightGreen)
                                .overlay(
                                    Text("Yes")
                                        .font(Font.fredoka(.semiBold, size: 20))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                )
                                .frame(width: g.size.width * 0.7 * 0.6, height: g.size.height * 0.06)
                        }.neoShadow()
                            .padding([.horizontal, .bottom])
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation {
                                Analytics.shared.log(event: .finished_not_now)
                                shown = false
                                UserDefaults.standard.setValue(true, forKey: "saveProgress")
                            }
                        } label: {
                            Capsule()
                                .fill(Color.gray)
                                .overlay(
                                    Text("Not Now")
                                        .font(Font.fredoka(.semiBold, size: 20))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                )
                                .frame(width: g.size.width * 0.7 * 0.6, height: g.size.height * 0.06)
                        }.neoShadow()
                        .padding([.horizontal, .bottom])
                        Spacer()
                    }
                    .font(Font.fredoka(.regular, size: 18))                    .frame(width: g.size.width * 0.85, height: g.size.height * 0.35, alignment: .center)
                    .minimumScaleFactor(0.05)
                    .background(Clr.darkWhite)
                    .neoShadow()
                    .cornerRadius(12)
                    .offset(y: -50)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct SaveProgressModalPreview: PreviewProvider {
    static var previews: some View {
        SaveProgressModal(shown: .constant(true))
    }
}
