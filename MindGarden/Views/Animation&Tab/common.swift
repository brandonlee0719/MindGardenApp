//
//  common.swift
//  MindGarden
//
//  Created by Vishal Davara on 20/02/22.
//

import SwiftUI

class Helper: NSObject {
    class func minuteandhours (seconds : Double, isNewLine : Bool = false) -> String {
        let min = seconds / 60
        let hour = Int(min / 60)
        let minute = Int(min) % 60
        
 
        
        if hour > 0 && minute > 0 {
            return "\((hour == 1) ? "\(hour)H" : "\(hour)H") \(isNewLine ? "\n" : "")\((minute == 1) ? "\(minute)m" : "\(minute)m")"
        }
        else if(hour > 0){
            return (hour == 1) ? "\(hour)H" : "\(hour)H"
        }
        else if(minute > 0) {
            return (minute == 1) ? "\(minute)m" : "\(minute)m"
        }
        if seconds > 0 {
            return "0.5m"
        } else {
            return "0 m"
        }
    }

}

extension View {

    func darkShadow() -> some View {
        self.modifier(DarkShadowViewModifier())
    }
    
    func roundedCapsule(color:Color = Clr.yellow) -> some View {
        self
            .padding(12)
            .background(Capsule().fill(color).darkShadow())
            .overlay(Capsule().stroke(.black, lineWidth: 1))
    }
    
    func plusPopupStyle(size:CGSize, scale:CGFloat) -> some View {
        self.frame(width: size.width/2, height: size.width/2)
            .scaleEffect(CGSize(width: scale, height: scale), anchor: .bottom)
            .animation(.spring())
    }
    
    func plusButtonStyle(scale:CGFloat) -> some View {
        self.frame(width: 48, height: 48)
            .overlay(Image(systemName: "plus")
                        .foregroundColor(Clr.darkgreen)
                        .font(Font.title.weight(.semibold))
                        .aspectRatio(contentMode: .fit)
                        .rotationEffect(scale < 1.0 ? .degrees(0) : .degrees(135) )
                        .animation(.spring())
                        )
            
    }
    
    func strokeStyle(cornerRadius: CGFloat = 30) -> some View {
        modifier(StrokeStyleNew(cornerRadius: cornerRadius))
    }
    
    func streakTitleStyle() -> some View {
        self
            .font(Font.fredoka(.bold, size: 32))
            .foregroundColor(Clr.gardenRed)
    }
    
    func streakBodyStyle() -> some View {
        self
            .font(Font.fredoka(.regular, size: 24))
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.05)
            .lineLimit(2)
            .padding()
    }
    
    func daysProgressTitleStyle() -> some View {
        self
            .foregroundColor(Clr.blackShadow)
            .frame(width:44)
            .font(Font.fredoka(.medium, size: 20))
    }
    func currentDayStyle() -> some View {
        self
            .foregroundColor(Clr.redGradientBottom)
            .frame(width:44)
            .font(Font.fredoka(.bold, size: 20))
    }
}

struct StrokeStyleNew: ViewModifier {
    var cornerRadius: CGFloat
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(
                    .linearGradient(
                        colors: [
                            .white.opacity(colorScheme == .dark ? 0.6 : 0.3),
                            .black.opacity(colorScheme == .dark ? 0.3 : 0.1)
                        ], startPoint: .top, endPoint: .bottom
                    )
                )
                .blendMode(.overlay)
        )
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        (UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero).insets
    }
}

extension EnvironmentValues {

    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    
    var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

//MARK: screen common
extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
}



struct ViewControllerHolder {
    weak var value: UIViewController?
}

struct ViewControllerKey: EnvironmentKey {
    static var defaultValue: ViewControllerHolder {
        return ViewControllerHolder(value: UIApplication.shared.windows.first?.rootViewController)
    }
}

extension EnvironmentValues {
    var viewController: UIViewController? {
        get { return self[ViewControllerKey.self].value }
        set { self[ViewControllerKey.self].value = newValue }
    }
}

extension UIViewController {
    func present<Content: View>(style: UIModalPresentationStyle = .automatic, @ViewBuilder builder: () -> Content) {
        let toPresent = UIHostingController(rootView: AnyView(EmptyView()))
        toPresent.modalPresentationStyle = style
        toPresent.rootView = AnyView(
            builder()
                .environment(\.viewController, toPresent)
        )
        self.presentController(toPresent)
    }
    
    func presentController(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false)
    }
    
    func dismissController() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false)
    }
}
