//
//  TutorialView.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/03/09.
//

import SwiftUI

struct TutorialView: View {
    @Binding var presentTutorial: Bool
    
    let diameter: CGFloat = 100 // 直径
    
    var body: some View {
        GeometryReader { [diameter] geometry in
            RectangleWithCircle(circleRect: CGRect(x: geometry.size.width - 85, y: -10, width: diameter, height: diameter))
                .fill(Color(UIColor.black.withAlphaComponent(0.5)), style: FillStyle(eoFill: true))
                .edgesIgnoringSafeArea(.top)
            .gesture(
                TapGesture().onEnded {
                    // UserDefaults.haveLaunchAppBefore = true // TODO: uncomment
                    self.presentTutorial = false
                }
            )
        }
    }
}

struct RectangleWithCircle: Shape {
    let circleRect: CGRect
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRect(rect)
        let circleHole = Path(roundedRect: circleRect, cornerSize: CGSize(width: circleRect.width / 2, height: circleRect.height / 2))
        path.addPath(circleHole)
        
        return path
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView(presentTutorial: .constant(true))
    }
}
