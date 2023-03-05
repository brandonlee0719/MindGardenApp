//
//  shareStreak.swift
//
//
//  Created by Vishal Davara on 26/03/22.
//

import SwiftUI

struct ShareStreakGroup: Identifiable {
    var id = UUID()
    var item: [ShareStreakItem]
}

struct ShareStreak: View {
    
    let group = [ShareStreakGroup(item: streakItems),
                 ShareStreakGroup(item: streakItems1),
                 ShareStreakGroup(item: streakItems2)
    ]
    let title = "SHARE YOUR STREAK"
    
    var body: some View {
        ScrollView {
        ZStack(alignment: .top) {
            Clr.darkWhite
                .ignoresSafeArea()
            Text(title)
                .font(.fredoka(.bold, size: 20))
                .foregroundColor(Clr.black1)
                .padding(.top,20)
            HStack {
                ExitButton(action: {
                })
                Spacer()
                Spacer()
            }
            VStack {
                Spacer()
                    .frame( height: 80, alignment: .center)
                Rectangle()
                    .fill(Color.orange)
                    .cornerRadius(20)
                    .frame(width: 300, height: 300, alignment: .center)
                ForEach(group) { grp in
                VStack(alignment:.leading) {
                    ForEach(grp.item) { item in
                        Button {
                        } label: {
                            VStack(spacing: 0) {
                                HStack() {
                                    item.image
                                        .resizable()
                                        .frame(width: 20, height: 20, alignment: .center)
                                        .padding()
                                    Text(item.name)
                                        .font(.fredoka(.semiBold,size: 16))
                                        .foregroundColor(Clr.superBlack)
                                    Spacer()
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Clr.lightGray, lineWidth: 2)
                                )
                            }
                        }.frame(height:45)
                    }
                }
                .padding(.top, 20)
                }
            }.padding()
        }
        }
    }
    
    private func menuSelected(itemType:ShareStreakType){
        switch itemType {
        case .twitter:
            break
        case .instagram:
            break
        case .facebook:
            break
        case .messenger:
            break
        case .messages:
            break
        case .whatsapp:
            break
        case .saveimage:
            break
        case .more:
            break
        }
        
    }
}

struct ShareStreak_Previews: PreviewProvider {
    static var previews: some View {
        ShareStreak()
    }
}
