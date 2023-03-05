//
//  NewUpdateModal.swift
//  MindGarden
//
//  Created by Dante Kim on 10/4/21.
//

import SwiftUI

struct MiddleModal: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var model: MeditationViewModel
    @EnvironmentObject var userModel: UserViewModel
    @Binding var shown: Bool
    
    var body: some View {
        GeometryReader { g in
            VStack(spacing: 10) {
                Spacer()
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center, spacing: 0) {
                        Spacer()
                        Spacer()
                        VStack(spacing: 0) {
                            HStack {
                                Button {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation {
                                        shown.toggle()
                                    }
                                }label: {
                                    ZStack {
                                        Circle()
                                            .fill(Clr.darkWhite)
                                        Image(systemName: "xmark")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(Clr.black2)
                                            .opacity(0.5)
                                            .frame(width: 15, height: 15)
                                    }
                                }.frame(width: 30, height: 30)
                                .buttonStyle(BonusPress())
                                .padding(.trailing, 10)
                                Spacer()
                                Text(model.selectedMeditation?.title ?? "")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.fredoka(.semiBold, size: 20))
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                    .frame(height: 50)
                                Spacer()
                                Image(systemName: "xmark")
                                    .padding()
                                    .opacity(0)
                                    .frame(width: 30, height: 30)
                            }.frame(width: abs(g.size.width * 0.7), height: 35)
                                .padding(.top, 20)
                                .padding(.horizontal, 16)
                            HStack {
                                HStack(spacing: 0) {
                                    if model.selectedMeditation?.imgURL != "" {
                                        UrlImageView(urlString: model.selectedMeditation?.imgURL ?? "")
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: g.size.width/5)
                                            .padding(.horizontal, 5)
                                    } else {
                                        model.selectedMeditation?.img
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: g.size.width/6)
                                            .padding(.horizontal, 5)
                                    }
                                    VStack(alignment: .leading) {
                                        Text(model.selectedMeditation?.description ?? "")
                                            .foregroundColor(Clr.black2)
                                            .font(Font.fredoka(.regular, size: 18))
                                            .lineLimit(7)
                                            .minimumScaleFactor(0.05)
                                    }.frame(width: g.size.width/2)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                }.frame(height: g.size.height/(K.isSmall() ? 4.5 : 5))
                            }.padding([.horizontal], 20)
                                .padding(.horizontal, 32)
                            HStack {
                                Text("Instructor:")
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 15)
                                    .font(Font.fredoka(.medium, size: 18))
                                Text("\(model.selectedMeditation?.instructor ?? "Bijan")")
                                    .font(Font.fredoka(.semiBold, size: 18))
                            }.foregroundColor(Clr.black2)
                                .padding(.top)
                                .frame(width: abs(g.size.width * 0.7), alignment: .leading)
                                .padding(.leading, 16)
                            HStack {
                                Text("Your Plant:")
                                userModel.selectedPlant?.head
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                    .font(Font.fredoka(.medium, size: 18))
                                Text("\(userModel.selectedPlant?.title ?? "none")")
                                    .font(Font.fredoka(.semiBold, size: 18))
                            }.foregroundColor(Clr.black2)
                                .padding(.top, 10)
                                .frame(width: abs(g.size.width * 0.7), alignment: .leading)
                                .padding(.leading, 16)
                            HStack {
                                Text("Coins Given:")
                                Img.coin
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                    .font(Font.fredoka(.medium, size: 18))
                                Text("\(model.selectedMeditation?.reward ?? 0)")
                                    .font(Font.fredoka(.semiBold, size: 18))
                            }.foregroundColor(Clr.black2)
                                .padding(.top, 10)
                                .frame(width: abs(g.size.width * 0.7), alignment: .leading)
                                .padding(.leading, 16)
                            Spacer()
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation {
                                        shown = false
                                        viewRouter.currentPage = .play
                                        middleToSearch = ""
                                        medSearch = false
                                    }
                                }
                            } label: {
                                Capsule()
                                    .fill(Clr.yellow)
                                    .overlay(
                                        Text("Start Session")
                                            .font(Font.fredoka(.bold, size: 18))
                                            .foregroundColor(Clr.black2)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                    )
                                    .frame(height: 40)
                                    .addBorder(.black, width: 1.5, cornerRadius: 20)
                            }.buttonStyle(NeoPress())
                                .padding([.horizontal, .bottom])
                                .padding(.horizontal, 8)
                            Spacer()
                        }
                        .font(Font.fredoka(.regular, size: 18))
                        .frame(width: g.size.width * 0.85, height: g.size.height * (K.isSmall() ? 0.65 : 0.55), alignment: .center)
                        .minimumScaleFactor(0.05)
                        .background(Clr.darkWhite)
                        .neoShadow()
                        .cornerRadius(32)
                        .offset(y: -50)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
}

struct MiddleModalPreview: PreviewProvider {
    static var previews: some View {
        MiddleModal(shown: .constant(true))
    }
}
