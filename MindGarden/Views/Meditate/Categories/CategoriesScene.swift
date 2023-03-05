//
//  CategoriesScene.swift
//  MindGarden
//
//  Created by Dante Kim on 7/14/21.
//

import SwiftUI
import Combine
import Amplitude

@available(iOS 14.0, *)
struct CategoriesScene: View {
    var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: -35), count: 2)
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var model: MeditationViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var searchText: String = ""
    var isSearch: Bool = false
    @Binding var showSearch: Bool
    @Binding var isBack: Bool
    let isFromQuickstart: Bool
    var selectedCategory: QuickStartType
    @State private var tappedMed = false
    @State private var showModal = false

    init(isSearch: Bool = false, showSearch: Binding<Bool>, isBack: Binding<Bool>, isFromQuickstart: Bool = false, selectedCategory: QuickStartType = .minutes3) {
        self.isSearch = isSearch
        self._showSearch = showSearch
        self._isBack = isBack
        self.isFromQuickstart = isFromQuickstart
        self.selectedCategory = selectedCategory
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }

    var body: some View {
            GeometryReader { g in
                ZStack {
                Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                VStack(alignment: .center) {
                    if !isFromQuickstart {
                        if !isSearch {
                            HStack {
                                backButton
                                Spacer()
                                Text("Categories")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.fredoka(.bold, size: 20))
                                Spacer()
                                backButton
                                    .opacity(0)
                                    .disabled(true)
                            }.padding(.top, 50)
                        } else {
                            //Search bar
                            HStack {
                                backButton.padding()
                                HStack {
                                    TextField("Search...", text: $searchText) { startedEditing in
                                        if startedEditing {
                                            
                                        }
                                    }
                                    Spacer()
                                    Image(systemName: "magnifyingglass")
                                }
                                .padding()
                                .foregroundColor(.gray)
                                .frame(height: 40)
                                .cornerRadius(13)
                                .background(Clr.darkWhite)
                                .padding(.trailing)
                                .oldShadow()
                            }.padding(.top)
                        }
                    } else {
                        HStack {
                        }
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        if isSearch {
                            HStack {
                                CategoryButton(category: .all, selected: $model.selectedCategory)
                                CategoryButton(category: .breathwork, selected: $model.selectedCategory)
                                CategoryButton(category: .unguided, selected: $model.selectedCategory)
                                CategoryButton(category: .beginners, selected: $model.selectedCategory)
                                CategoryButton(category: .anxiety, selected: $model.selectedCategory)
                                CategoryButton(category: .focus, selected: $model.selectedCategory)
                                CategoryButton(category: .growth, selected: $model.selectedCategory)
                                CategoryButton(category: .sadness, selected: $model.selectedCategory)
                                CategoryButton(category: .sleep, selected: $model.selectedCategory)
                                CategoryButton(category: .courses, selected: $model.selectedCategory)
                            }.padding()
                        }
                    }
                    ScrollView(showsIndicators: false) {
                        
                            LazyVGrid(columns: gridItemLayout, content: {
                                if selectedCategory == .breathwork || model.selectedCategory == .breathwork {
                                    ForEach(Breathwork.breathworks, id: \.self) { item in
                                        Button {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            withAnimation {
                                                fromPage = ""
                                                viewRouter.previousPage = .learn
                                                if !UserDefaults.standard.bool(forKey: "isPro") && Breathwork.lockedBreaths.contains(item.id) {
                                                    viewRouter.currentPage = .pricing
                                                } else {
                                                    model.selectedBreath = item
                                                    viewRouter.currentPage = .breathMiddle
                                                }
                                     
                                            }
                                        } label: {
                                            HomeSquare(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height * 0.75) , meditation: Meditation.allMeditations[0], breathwork: item)
                                                .padding(.vertical, 8)
                                        }.buttonStyle(NeoPress())
                                    }
                                } else {
                                    ForEach(meditations, id: \.self) { item in
                                        Button {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            viewRouter.previousPage = .learn
                                            withAnimation {
                                                didSelectcategory(item: item)
                                            }
                                        } label: {
                                            HomeSquare(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height * 0.75) , meditation: item, breathwork: nil)
                                                .padding(.vertical, 8)
                                        }.buttonStyle(NeoPress())
                                    }
                                }
                            })
                        VStack {
                            Text("Want a specific meditation?")
                                .font(Font.fredoka(.semiBold, size: 18))
                                .foregroundColor(Clr.black2)
                            Button {
                                Analytics.shared.log(event: .categories_tapped_request)
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                withAnimation {
                                    if let url = URL(string: "https://mindgarden.upvoty.com/b/feature-requests/") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text("Post a Request")
                                        .foregroundColor(.black)
                                        .font(Font.fredoka(.semiBold, size: 20))
                                }.frame(width: g.size.width * 0.65, height: 50)
                                .background(Clr.yellow)
                                .cornerRadius(25)
                            }.buttonStyle(NeumorphicPress())
                        }.frame(height: 140)
                            .padding(.bottom,isFromQuickstart ?  36 : 100)
                    }.frame(height: UIScreen.screenHeight * (isFromQuickstart ? 0.65 : 0.9))
                    if isFromQuickstart { Spacer().frame(height:100) }
                    Spacer()
                }
                .padding(.top, isFromQuickstart ? 40 : 0)
                .background(Clr.darkWhite)
                }
                if showModal {
                    Color.black
                        .offset(y: -100)
                        .frame( height: UIScreen.screenHeight*1.2)
                        .opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                    showModal.toggle()
                            }
                        }
                }
                MiddleModal(shown: $showModal)
                    .offset(y: showModal ? (isFromQuickstart ? -80 : 0)  : g.size.height)
                    .edgesIgnoringSafeArea(.top)
                    .animation(.default, value: showModal)
                    .transition(.move(edge: .bottom))
                if isFromQuickstart {
                    HStack {
                        backButton
                            .offset(x: -10)
                        Spacer()
                        Text(QuickStartMenuItem(title: selectedCategory).name)
                            .foregroundColor(Clr.black2)
                            .font(Font.fredoka(.semiBold, size: 20))
                        Spacer()
                        backButton.opacity(0).disabled(true)
                        Spacer()
                    }.frame(width: UIScreen.screenWidth, height: 50)
                        .padding(.horizontal, 35)
                }
            }
        .onAppear {
            DispatchQueue.main.async {
                model.selectedCategory = .all
            }
        }
        .transition(.move(edge: .trailing))
        .onDisappear {
            medSearch = false
            searchScreen = false
            if tappedMed {
                if model.selectedMeditation?.type == .course {
                    viewRouter.currentPage = .middle
                } else {
                    viewRouter.currentPage = .play
                }
            }
        }
        .onAppearAnalytics(event: .screen_load_categories)
    }
    
    var meditations : [Meditation ] {
        if isFromQuickstart {
            return filterMeditation()
        } else {
            return !isSearch ? model.selectedMeditations : model.selectedMeditations.filter({ (meditation: Meditation) -> Bool in
                return meditation.title.lowercased().contains(searchText.lowercased()) || searchText == ""
            })
        }
    }
    
    private func filterMeditation() -> [Meditation] {
        return model.selectedMeditations.filter({ (meditation: Meditation) -> Bool in
            switch selectedCategory {
            case .newMeditations: return meditation.isNew
            case .minutes3: return meditation.duration.isLess(than: 250) && meditation.type != .course
            case .minutes5: return meditation.duration <= 400 && meditation.duration >= 250
            case .minutes10: return meditation.duration <= 700 && meditation.duration >= 500
            case .minutes20: return meditation.duration >= 900 && meditation.duration <= 1250
            case .popular: return Meditation.popularMeditations.contains(meditation.id)
            case .morning: return Meditation.morningMeds.contains(meditation.id)
            case .sleep: return meditation.category == .sleep
            case .anxiety: return (meditation.category == .anxiety || meditation.category == .sadness)
            case .unguided: return meditation.category == .unguided
            case .courses: return meditation.type == .course
            case .focus: return meditation.category == .focus
            default: return true
            }
        })
    }

    var backButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            if !isFromQuickstart {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                middleToSearch = ""
                medSearch = false
                if isSearch {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    DispatchQueue.main.async {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            viewRouter.currentPage = .meditate
                        }
                    }
                }
            } else {
                withAnimation {
                    isBack = false
                }
            }
        } label: {
            Image(systemName: "arrow.backward")
                .foregroundColor(Clr.darkgreen)
                .font(.system(size: 22))
                .padding(.leading, 10)
        }
    }

    var searchButton: some View {
        Button {
        } label: {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 22))
                .foregroundColor(Clr.darkgreen)
        }
    }
    
    private func didSelectcategory(item: Meditation){
        withAnimation {
            
            viewRouter.previousPage = .learn
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            if !UserDefaults.standard.bool(forKey: "isPro") && Meditation.lockedMeditations.contains(item.id) {
                fromPage = ""
                Analytics.shared.log(event: .pricing_from_locked)
                Analytics.shared.log(event: .categories_tapped_locked_meditation)
                presentationMode.wrappedValue.dismiss()
                viewRouter.currentPage = .pricing
            } else {
                Analytics.shared.log(event: .categories_tapped_meditation)
                model.selectedMeditation = item
                if isSearch {
                    tappedMed = true
                    presentationMode.wrappedValue.dismiss()
                } else {
                    if model.selectedMeditation?.type == .course {
                        viewRouter.currentPage = .middle
                    } else {
                        DispatchQueue.main.async {
                            withAnimation {
                                showModal = true
                            }
                        }
                    }
                }
            }
        }
    }

    struct CategoryButton: View {
        var category: Category
        @Binding var selected: Category?

        var body: some View {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                Amplitude.instance().logEvent("search_selected_category", withEventProperties: ["category": category.value])
                withAnimation {
                    selected = category                    
                }
            } label: {
                HStack {
                    Text(category.value)
                        .font(Font.fredoka(selected == category ? .semiBold : .regular, size: 16))
                        .foregroundColor(Clr.black2)
                        .font(.footnote)
                        .padding(.horizontal)
                }
                .padding(8)
                .background(selected == category ? Clr.yellow : Clr.darkWhite)
                .cornerRadius(16)
                .addBorder(.black, width: 1.5, cornerRadius: 16)
            }
            .frame(height:32)
            .buttonStyle(NeumorphicPress())
            .padding(0)
        }
    }
}

struct CategoriesScene_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 14.0, *) {
            CategoriesScene(showSearch: .constant(false), isBack: .constant(false))
        }
    }
}
