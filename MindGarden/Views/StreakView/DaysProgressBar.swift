//
//  DaysProgressBar.swift
//
//
//  Created by Vishal Davara on 11/03/22.
//

import SwiftUI
import MindGardenWidgetExtension

struct DayItem: Identifiable {
    var id = UUID()
    var title: String
    var plant: Plant?
    var mood: Mood?
}

struct DaysProgressBar: View {
    @EnvironmentObject var gardenModel: GardenViewModel

    
    @State var progress: CGFloat  = 0.0
    @State var circleProgress: CGFloat  = 0.0
    
    var body: some View {
        HStack {
            Spacer()
                ForEach(0..<gardenModel.lastFive.count) { index in
                    VStack {
                        Text("\(gardenModel.lastFive[index].0)")
                            .foregroundColor(index == gardenModel.lastFive.count - 1 ? Clr.redGradientBottom : Clr.black2)
                            .frame(width:44)
                            .font(Font.fredoka(index == gardenModel.lastFive.count - 1 ? .bold : .medium, size: 20))
                        ZStack {
                            Rectangle()
                                .fill(getColor(index: index))
                                .frame(width:index == 0 ? 0 : index == gardenModel.lastFive.count - 1 ? (50 * progress) : 50, height: 15, alignment: .leading)
                                .neoShadow()
                                .offset(x:-25)
                            Circle()
                                .fill(getColor(index: index))
                                .frame(width: index == gardenModel.lastFive.count - 1 ? (50 * circleProgress) : 50, height: 50)
                                .rightShadow()
                            if let plant = gardenModel.lastFive[index].1 {
                                plant.head
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 35, height: 35)
                            }
                        }
                    }.zIndex(Double(5-index))
                Spacer()
            }
        }.frame(width: UIScreen.main.bounds.width * 0.9, alignment: .center).onAppear {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut){
                    progress = 1.0
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeInOut){
                    circleProgress = 1.0
                }
            }
        }
    }
    
    private func getColor(index:Int) -> Color {
        if let mood = gardenModel.lastFive[index].2 {
            return mood.color
        } else if let plant = gardenModel.lastFive[index].1  {
            if plant.title == "Ice Flower" {
                return Clr.freezeBlue
            } else {
                return Clr.orange
            }
        } else if index == gardenModel.lastFive.count - 1 {
            return Clr.orange
        }
        return Clr.darkWhite
    }
}

struct DaysProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        DaysProgressBar()
    }
}
