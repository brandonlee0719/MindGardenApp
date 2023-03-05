//
//  MediumWidget.swift
//  MindGardenWidgetExtension
//
//  Created by Vishal Davara on 30/07/22.
//

import SwiftUI
import WidgetKit

struct MediumEntry {
    let lastDate:String
    let lastMood:Image
    let meditationId:Int?
    let breathworkId:Int?
    
    let breathworkImg:Image?
    let meditationImg:Image?
    
    var meditation:Meditation {
        return Meditation.allMeditations.first(where: { $0.id == meditationId } ) ?? Meditation.allMeditations[0]
    }
    
    var breathWork:Breathwork {
        return Breathwork.breathworks.first(where: { $0.id == breathworkId } ) ?? Breathwork.breathworks[0]
    }
    
    func getImage(type:MediumType) -> Any? {
        switch type {
        case .journel:
            return Image("mediumWidgetJournel")
        case .meditate:
            return Image("meditatingTurtle")
//            return meditation.img
        case .logmood:
            return Image("mediumWidgetMood")
        case .breathwork:
            return Image("mediumWidgetBreathwork")
//            return breathWork.img
        }
    }
    
    func getSubtile(type:MediumType) -> String{
        switch type {
        case .journel:
            return "Last: \(lastDate)"
        case .meditate:
            return "Discover"
        case .logmood:
            return "Last Check:"
        case .breathwork:
            return "Discover"
        }
    }
}

enum MediumType {
    case journel, meditate, logmood, breathwork
    var title: String {
        switch self {
        case .journel:
            return "Journal"
        case .meditate:
            return "Meditate"
        case .logmood:
            return "Log Mood"
        case .breathwork:
            return "Breathwork"
        }
    }
    var url: String {
        switch self {
        case .journel:
            return "gratitude://io.bytehouse.mindgarden"
        case .breathwork:
            return "breathwork://io.bytehouse.mindgarden"
        case .logmood:
            return "mood://io.bytehouse.mindgarden"
        default:
            return "meditate://io.bytehouse.mindgarden"
        }
    }
}

struct NewMediumWidget: View {
    
   let mediumEntry:MediumEntry
    
    var body: some View {
        VStack(spacing:0) {
            HStack(spacing:0) {
                MediumWidgetRow(mediumEntry:mediumEntry, type: .journel)
                MediumWidgetRow(mediumEntry:mediumEntry, type: .meditate)
            }
            HStack(spacing:0) {
                MediumWidgetRow(mediumEntry:mediumEntry, type: .logmood)
                MediumWidgetRow(mediumEntry:mediumEntry, type: .breathwork)
            }

        }
        .padding(5)
    }
}


struct MediumWidgetRow: View {
    
    let mediumEntry:MediumEntry
    @State var type:MediumType
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("darkWhite"))
                .addBorder(Color.black, width: 1.5, cornerRadius: 20)
            Link(destination: URL(string: type.url)!)  {
            HStack {
                if let img = mediumEntry.getImage(type: type) as? Image {
                    img
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:35)
                }
                VStack(alignment:.leading) {
                    Text(type.title)
                        .font(Font.fredoka(.bold, size: 16))
                        .foregroundColor(Color("black2"))
                        .padding(.bottom,1)
                    HStack {
                        Text(mediumEntry.getSubtile(type: type))
                            .lineLimit(1)
                            .font(Font.fredoka(.regular, size: 10))
                            .foregroundColor(Color("black2"))
                            .frame(maxWidth:.infinity,alignment: .leading)
                            .overlay(
                                HStack {
                                    if type == .logmood {
                                        HStack(spacing:0){
                                            Text(mediumEntry.getSubtile(type: type))
                                                .lineLimit(1)
                                                .font(Font.fredoka(.regular, size: 12))
                                                .opacity(0)
                                                .padding(.horizontal,0)
                                            getImage()
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height:20)
                                            Spacer()
                                        }
                                    } else {
                                        EmptyView()
                                    }
                                }
                            )
                        Spacer()
                    }
                }.frame(maxWidth:.infinity, maxHeight: .infinity)
            }.padding(10)
            }
        }
        .background(Color("darkWhite").cornerRadius(20).neoShadow())
        .padding(5)
        .frame(maxWidth:.infinity, maxHeight: .infinity)
    }
    
    private func getImage() -> Image {
            return mediumEntry.lastMood
    }
}
