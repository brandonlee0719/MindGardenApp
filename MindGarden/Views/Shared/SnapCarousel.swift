//
//  SnapCarousel.swift
//  MindGarden
//
//  Created by Dante Kim on 11/14/21.
//

import SwiftUI

struct SnapCarousel: View {
    let cardWidth = UIScreen.screenWidth*0.8
    let images = [ Card(title: "2", img: Img.review2),  Card(title: "4", img: Img.review4), Card(title: "5", img: Img.review5), Card(title: "1", img: Img.review1), Card(title: "3", img: Img.review3)]
    @State var index: Int = 1
    @State private var offset: CGFloat = 0

    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(images, id: \.self) { item in
                        ZStack(alignment: .center) {
                            VStack(alignment: .center, spacing: 5) {
                                item.img
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                }
                            }
                            .padding()
                            
                    }.frame(width: cardWidth, height:UIScreen.screenHeight*0.225, alignment: .center)
                        .foregroundColor(Color.white)
                        .background(Clr.review
                        )
                        .cornerRadius(8)
                        .shadow(color: Clr.lightGray, radius: 4, x: 0, y: 4)
                        .transition(AnyTransition.slide)
                        .animation(.spring())
                    }
                }
            .content.offset(x: self.offset)
            .frame(width: cardWidth, height: nil, alignment: .leading)
            .gesture(DragGesture()
                .onChanged({ value in
                    self.offset = value.translation.width - cardWidth * CGFloat(self.index)
                })
                    .onEnded({ value in
                        if abs(value.predictedEndTranslation.width) >= cardWidth / 2 {
                            var nextIndex: Int = (value.predictedEndTranslation.width < 0) ? 1 : -1
                            nextIndex += self.index
                            self.index = nextIndex.keepIndexInRange(min: 0, max: images.count - 1)
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                        withAnimation { self.offset = (-cardWidth * CGFloat(self.index)) - CGFloat((self.index * 10)) }
                    })
            )
        }
}
}
struct Card: Hashable {
    let title: String
    let img: Image
    let id = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.title == rhs.title
    }

}
