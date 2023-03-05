//
//  PlantTile.swift
//  MindGarden
//
//  Created by Dante Kim on 6/14/21.
//

import SwiftUI

struct PlantTile: View {
    @EnvironmentObject var userModel: UserViewModel
    let width, height: CGFloat
    let plant: Plant
    let isShop: Bool
    var isOwned: Bool = false
    var isBadge: Bool = false

    var body: some View {
            ZStack {
                Rectangle()
                    .foregroundColor(isBadge ? isOwned ? Clr.darkWhite : .gray.opacity(0.2): isOwned ? .gray.opacity(0.2) : Clr.darkWhite)
                    .frame(width: width * 0.35, height: height * 0.3)
                    .cornerRadius(16)
                    .addBorder(!isShop && plant == userModel.selectedPlant ? Clr.yellow : Clr.black2 ,width: !isShop && plant == userModel.selectedPlant ? 3 : isShop ? 2 : 0, cornerRadius: 16)
                    .padding()
                VStack(alignment: isShop ? .leading : .center, spacing: 0) {
                    isShop ?
                   (!isBadge ?
                    plant.packetImage
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width * 0.30, height: height * 0.18)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 4, y: 4)
                        .opacity(isOwned ? 0.4 : 1)
                        .offset(x: -5, y: -5)
                    :
                    plant.coverImage
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width * 0.30, height: height * 0.18)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 4, y: 4)
                        .opacity(1)
                        .offset(x: 0, y: 0)
                   )
                        : plant.coverImage
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width * 0.30, height: height * 0.18)
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 4, y: 4)
                        .opacity(1)
                        .offset(x: 0, y: 0)
                    Text(plant.title)
                        .font(Font.fredoka(.bold, size: 20))
                        .foregroundColor(Clr.black1)
                        .opacity(isOwned ? 0.4 : 1)
                        .lineLimit(1)
                        .minimumScaleFactor(0.05)
                        .frame(width: width * 0.35 * 0.85, alignment: .leading)
                        .padding(.leading, isBadge ? 3 : isShop ? 3 : 5)
                        .padding(.top, 5)
                    if isShop {
                        if isOwned && !isBadge {
                            Text("Bought")
                                .font(Font.fredoka(.bold, size: 20))
                                .foregroundColor(Clr.darkgreen)
                                .opacity(0.4)
                                .padding(.leading, 3)
                        } else {
                            HStack(spacing: isBadge ? 0 : 5) {
                                if isBadge {
                                    if userModel.ownedPlants.contains(plant) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(Clr.brightGreen)
                                    } else {
                                        Image(systemName: "lock.fill")
                                            .renderingMode(.original)
                                    }
                                } else {
                                    Img.coin
                                        .renderingMode(.original)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 20)
                                        .padding(.leading, 3)
                                }

                                Text(isBadge ? Plant.badgeDict[plant.price] ?? "" : String(plant.price))
                                    .font(Font.fredoka(.semiBold, size: isBadge ? 16 : 20))
                                    .foregroundColor(Clr.black2)
                                    .multilineTextAlignment(.trailing)
                                    .padding(.leading, 5)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.05)
                                    .offset(x: -2)
                                if plant.title == "Real Tree" {
                                    Img.leaf
                                        .renderingMode(.original)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30)
                                    Text("\(userModel.plantedTrees.count)")
                                        .font(Font.fredoka(.semiBold, size: isBadge ? 16 : 20))
                                        .foregroundColor(Clr.black2)
                                        .multilineTextAlignment(.trailing)
                                        .offset(x: -3)
                                }
                                
                            }.frame(width: width * 0.35 * 0.85, alignment: .leading)
                        }
                    } else {
                        Capsule()
                            .fill(plant == userModel.selectedPlant  ? Clr.yellow : Clr.brightGreen)
                            .overlay(Text(plant == userModel.selectedPlant ? "Selected" : "Select")
                                        .font(Font.fredoka(.semiBold, size: 18))
                                        .foregroundColor(plant == userModel.selectedPlant ? Clr.black2 : .white)
                                        .padding()
                            )
                            .frame(width: width * 0.30, height: height * 0.04)
                            .buttonStyle(NeumorphicPress())
                            .padding(.top, 5)
                            .neoShadow()
                    }
                }
            }.opacity(isBadge && !isOwned ? 0.55 : 1)
    }
}

struct PlantTile_Previews: PreviewProvider {
    static var previews: some View {
        PlantTile(width: 300, height: 700, plant: Plant(title: "Red Tulip", price: 90, selected: false, description: "Red Tulips are a genus of spring-blooming perennial herbaceous bulbiferous geophytes. Red tulips symbolize eternal love, undying love, perfect love, true love.", packetImage: Img.redTulipsPacket, one: Img.redTulips1, two: Img.redTulips2,  coverImage: Img.redTulips3, head: Img.daisyHead, badge: Img.redTulipsBadge), isShop: false)
    }
}
