//
//  CourseScene.swift
//  MindGarden
//
//  Created by Dante Kim on 2/18/22.
//

import SwiftUI
import Lottie

struct CourseScene: View {
    @State var viewState = CGSize.zero
    @Environment(\.presentationMode) var presentationMode
    @State private var index = 0
    @State private var progressValue = 0.3
    @Binding var course: LearnCourse
    @Binding var completedCourses: [Int]
    @State private var completed: Bool = false
    
    @State var isPlaying = false
//    let lottieView = LottieAnimationView(filename: "check2", loopMode: .playOnce, isPlaying:isPlaying)

    var body: some View {
        ZStack {
            Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
            Img.pencil
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 75)
                .rotationEffect(.degrees(270))
                .position(x: 20, y: 70)
            Img.brain
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .position(x: 30, y: UIScreen.main.bounds.height * (K.isSmall() ? 0.79 : 0.75))
            Img.books
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .position(x: UIScreen.main.bounds.width - 30, y: UIScreen.main.bounds.height * (K.isSmall() ? 0.79 : 0.75))
            GeometryReader { g in
                let width = g.size.width
                VStack {
                    Text("💯 Great Job!")
                        .font(Font.fredoka(.bold, size: 40))
                        .foregroundColor(Clr.darkgreen)
                        .offset(x: 65, y: UIScreen.main.bounds.height * 0.55)
                    HStack {
                        LottieAnimationView(filename: "check2", loopMode: .playOnce, isPlaying: $isPlaying)
                    }
                    .offset(x: width/6, y: K.isSmall() ? -50 : -25)
                    .frame(width: width, height: 400)
                    Button {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Capsule()
                            .fill(Clr.yellow)
                            .overlay(
                                Text("Done")
                                    .font(Font.fredoka(.bold, size: 22))
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                            )
                            .frame(width: width * 0.5, height: 50)
                    }.offset(x: width/6, y: 80)
                    .buttonStyle(NeumorphicPress())
                }.offset(x: -width/6, y: completed ? 0 : UIScreen.main.bounds.height)
                Spacer()
                VStack(){
                    Spacer()
                    HStack {
                        ZStack {}.frame(width: 50, height: 50)
                        .cornerRadius(25)
                        .opacity(0)
                        Spacer()
                        Text("\(course.title)")
                            .foregroundColor(Clr.black2)
                            .lineLimit(2)
                            .font(Font.fredoka(.bold, size: 20))
                            .frame(width: width - 125, height: 50, alignment: .center)
                        Spacer()
                        Button {} label: {
                            ZStack {
                                Circle()
                                    .fill(Clr.darkWhite)
                                    .frame(width: 50, height: 50)
                                Image(systemName: "xmark")
                                    .foregroundColor(.gray)
                                    .frame(width: 50, height: 50)
                                    .padding()
                             
                            }.frame(width: 50, height: 50)
                            .cornerRadius(25)
                            .onTapGesture {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                presentationMode.wrappedValue.dismiss()
                            }
                        }.buttonStyle(NeumorphicPress())
                            .padding(.trailing)
                    }.frame(width: g.size.width - 75, height: 50, alignment: .top)
                    Spacer()
                    TabView(selection: $index) {
                        ForEach(course.slides.indices, id: \.self) { idx in
                            GeometryReader { proxy in
                                FeaturedItem(slide: course.slides[idx])
                                    .modifier(OutlineModifier(cornerRadius: 30))
                                    .rotation3DEffect(
                                        .degrees(proxy.frame(in: .global).minX / -10),
                                        axis: (x: 0, y: 1, z: 0), perspective: 1
                                    )
                                    .blur(radius: abs(proxy.frame(in: .global).minX) / 40)
                                    .accessibilityElement(children: .combine)
                                    .neoShadow()
                            }
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(width: width, height: UIScreen.main.bounds.height * (K.isSmall() ? 0.7 : 0.6), alignment: .center)
                    .offset(y: !completed ? 0 : UIScreen.main.bounds.height)
                    Spacer()
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Clr.brightGreen)
                                .cornerRadius(25)
                                .frame(width: min(CGFloat(progressValue * (width * 0.65)), width * 0.65), height: 50)
                                .padding(.leading, 40)
                                .shadow(radius: 5)
                            HStack {
                            Button {} label: {
                                ZStack {
                                    Circle()
                                        .fill(Clr.darkWhite)
                                        .frame(width: 60, height: 60)
                                    Image(systemName: "chevron.left")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60)
                                        .foregroundColor(Clr.black2)
                                        .padding()
                                        .onTapGesture {
                                            withAnimation {
                                                if completed {
                                                    completed = false
                                                }
                                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                                index -= 1
                                                progressValue -= 1.0/Double(course.slides.count)
                                            }
                                        }
                                }.frame(width: 60, height: 60)
                                .cornerRadius(30)
                            }.buttonStyle(NeumorphicPress())
                            .padding()
                            Spacer()
                            Spacer()
                            Button {} label: {
                                ZStack {
                                    Circle()
                                        .fill(Clr.darkWhite)
                                        .frame(width: 60, height: 60)
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60)
                                        .foregroundColor(Clr.black2)
                                        .padding()
                                        .onTapGesture {
                                            isPlaying = false
                                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                            withAnimation {
                                                index += 1
                                                progressValue += 1.0/Double(course.slides.count)
                                                if progressValue > 1.0 {
                                                    // update what courses user has finished
                                                    if let ids = UserDefaults.standard.array(forKey: "completedCourses") as? [Int] {
                                                        var courseIds = ids
                                                        if !courseIds.contains(where: {$0 == course.id }) {
                                                            courseIds.append(course.id)
                                                            completedCourses = courseIds
                                                            UserDefaults.standard.setValue(courseIds, forKey: "completedCourses")
                                                        }
                                                    } else {
                                                        completedCourses = [course.id]
                                                        UserDefaults.standard.setValue([course.id], forKey: "completedCourses")
                                                    }
                                                   if course.category == "meditation" {
                                                        Analytics.shared.log(event: .learn_finished_meditation_course)
                                                   } else {
                                                       Analytics.shared.log(event: .learn_finished_life_course)
                                                   }
                                                    completed = true
                                                    isPlaying = true
                                                }
                                            }
                                        }
                                }.frame(width: 60, height: 60)
                                .cornerRadius(30)
                            }.buttonStyle(NeumorphicPress())
                            .padding()
                        }
                    }.frame(width: width * 0.85, height: 80)
                    .background(Clr.darkWhite)
                    .cornerRadius(35)
                    .neoShadow()
                }.frame(width: g.size.width, height: g.size.height, alignment: .center)
            }
        }.onAppear {
            progressValue = 1.0/Double(course.slides.count)
        }
       
//        .background(
//            Img.bee
//                .offset(x: 250, y: -100)
//                .accessibility(hidden: true)
//        )
//        .sheet(isPresented: $showCourse) {
//            CourseView(namespace: namespace, course: $selectedCourse, isAnimated: false)
//        }
    }
}

struct CourseScene_Previews: PreviewProvider {
    static var previews: some View {
        CourseScene(course: .constant(LearnCourse(id: 0, title: "", img: "", description: "", duration: "", category: "", slides: [Slide(topText: "", img: "", bottomText: "")])), completedCourses: .constant([0]))
    }
}

struct FeaturedItem: View {
    var slide: Slide
    @Environment(\.sizeCategory) var sizeCategory
    
    var body: some View {
        ZStack {
        VStack(alignment: .center, spacing: 8) {
            if slide.topText != "" {
                Text(slide.topText)
                    .font(Font.fredoka(.semiBold, size: 18))
                    .lineLimit(sizeCategory > .large ? 4 : 8)
                    .frame(width:  UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.17, alignment: .center)
                    .padding(.horizontal)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(Clr.black2)
                    .padding([.horizontal])
                    .offset(y: 25)

            }
            Spacer()
            UrlImageView(urlString: slide.img)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(20)
                .frame(width:  UIScreen.main.bounds.width * 0.85, height: 150)
                .padding(.horizontal, 10)
                .neoShadow()
            Spacer()
            if slide.bottomText != "" {
                Text(slide.bottomText)
                    .font(Font.fredoka(.semiBold, size: 18))
                    .lineLimit(sizeCategory > .large ? 4 : 8)
                    .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.185, alignment: .center)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(Clr.black2)
                    .padding(.horizontal)
                    .offset(y: -25)
            }
        }
            RoundedRectangle(cornerRadius: 32)
                .stroke(Clr.brightGreen, lineWidth: 8)
        }.frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * (K.isSmall() ? 0.7 : 0.6) , alignment: .center)
            .background(Clr.darkWhite)
            .cornerRadius(30)
            .padding((.horizontal), 20)
    }
}

struct FeaturedItem_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
//        FeaturedItem(course: LearnCourse(title: "Bruno", img: "https://firebasestorage.googleapis.com/v0/b/mindgarden-b9527.appspot.com/o/powerofgratitude.png?alt=media&token=bdfc4943-dbe2-4d18-a123-b260a9801b54", description: "Testing testing one two three", duration: "3-5", category: "meditation"))
//            FeaturedItem(course: courses[0])
//                .environment(\.sizeCategory, .accessibilityLarge)
    }
}
