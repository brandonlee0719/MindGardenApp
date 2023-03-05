//
//  RealTrees.swift
//  MindGarden
//
//  Created by Dante Kim on 7/8/22.
//

import SwiftUI

struct RealTrees: View {
    @EnvironmentObject var userModel: UserViewModel
    @Binding var buyRealTree: Bool
    
    var body: some View {
        let width = UIScreen.screenWidth
        let height = UIScreen.screenHeight
        ZStack {
            Clr.darkWhite.edgesIgnoringSafeArea(.all)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30){
                    ZStack {
                        Rectangle()
                            .fill(LinearGradient(colors: [Clr.brightGreen.opacity(0.8), Clr.yellow], startPoint: .leading, endPoint: .trailing))
                            .frame(height: height * 0.125)
                            .addBorder(.black, width: 1.5, cornerRadius: 14)
                            .neoShadow()
                        HStack {
                            Img.mgLogo
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width * 0.35)
                            Text("X")
                                .font(Font.fredoka(.bold, size: 20))
                                .offset(x: -7)
                            Img.treesLogo
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width * 0.3)
                        }
                    }.padding(.top, 15)
                    HStack {
                        Text("Trees planted\nby you")
                            .font(Font.fredoka(.regular, size: 20))
                            .foregroundColor(Clr.black2)
                            .lineSpacing(3)
                            .frame(width: width * 0.35)
                            .offset(x: 7)
                            .lineLimit(2)
                        Spacer()
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .frame(width: width * 0.4, height: height * 0.07)
                                .addBorder(.black, width: 1.5, cornerRadius: 14)
                                .neoShadow()
                            HStack {
                                Img.realTree
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: width * 0.12)
                                Text("\(userModel.plantedTrees.count)")
                                    .font(Font.fredoka(.bold, size: 32))
                                    .foregroundColor(Clr.brightGreen)
                                Text("trees")
                                    .font(Font.fredoka(.regular, size: 20))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    Img.treesKid
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                        .addBorder(.black, width: 1.5, cornerRadius: 20)
                        .neoShadow()
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        Analytics.shared.log(event: .store_tapped_buy_real_tree)
                        withAnimation {
                            userModel.willBuyPlant = Plant.allPlants.first(where: { plt in
                                plt.title == "Real Tree"
                            })
                            buyRealTree = true
                        }
                    } label: {
                        Rectangle()
                            .fill(Clr.yellow)
                            .overlay(
                                HStack {
                                    Text("Plant a Real Tree")
                                        .foregroundColor(Clr.darkgreen)
                                        .font(Font.fredoka(.bold, size: 20))
                                    Img.coin
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 25)
                                    Text("1000")
                                        .foregroundColor(Clr.black2)
                                        .font(Font.fredoka(.medium, size: 20))
                                }
                            ).addBorder(Color.black, width: 1.5, cornerRadius: 24)
                    }.frame(height: 60)
                     .buttonStyle(NeoPress())
                    (Text("Trees for the Future (TREES) trains communities on sustainable  land use so that they can grow vibrant economies, thriving food systems, and a healthier planet.")
                        .font(Font.fredoka(.medium, size: 16))
                        .foregroundColor(Clr.black2)
                     + Text(" Learn More")
                        .font(Font.fredoka(.semiBold, size: 16))
                        .foregroundColor(Clr.darkgreen)
                    )
                    .frame(width: width * 0.8)
                    .onTapGesture {
                        guard let url = URL(string: "https://trees.org/our-work/") else { return }
                        UIApplication.shared.open(url)
                    }
                    Spacer()
                }.frame(width: width * 0.85)
            }.padding(.bottom, 50)
        }
    }
}

struct RealTrees_Previews: PreviewProvider {
    static var previews: some View {
        RealTrees(buyRealTree: .constant(false))
    }
}

