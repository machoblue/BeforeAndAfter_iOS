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
        GeometryReader { geometry in
            ZStack {
                RectangleWithCircle(circleRect: CGRect(x: geometry.size.width - 85, y: -10, width: self.diameter, height: self.diameter))
                    .fill(Color(UIColor.black.withAlphaComponent(0.7)), style: FillStyle(eoFill: true))
                    .edgesIgnoringSafeArea([.top, .bottom])
                .gesture(
                    TapGesture().onEnded {
                         UserDefaults.haveLaunchAppBefore = true
                        self.presentTutorial = false
                    }
                )
                
                VStack {
                    Spacer()
                        .frame(height: 110)
                    Text("まずは右上のボタンから、\nいまの体重を記録してみましょう！")
                        .font(.system(size: BAFontSize.large))
                        .frame(alignment: .center)
                        .padding(16)
                        .background(MessageBubble())
                    Spacer()
                }
            }
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

struct MessageBubble: View {
    let padding: CGFloat = 16
    let cornerRadius: CGFloat = 8
    let tailWidth: CGFloat = 16
    let tailHeight: CGFloat = 16
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: self.cornerRadius)
                    .foregroundColor(.white)
                VStack {
                    Path { path in
                        path.move(to: CGPoint(x: geometry.size.width - self.cornerRadius - (self.tailWidth / 2), y: -self.padding)) // 三角の先っちょ。ここから時計回りに三角形を描く
                        path.addLine(to: CGPoint(x: geometry.size.width - self.cornerRadius - 6 /* 6: offset */, y: 0))
                        path.addLine(to: CGPoint(x: geometry.size.width - self.cornerRadius - self.tailWidth - 6 /* 6: offset */, y: 0))
                        path.addLine(to: CGPoint(x: geometry.size.width - self.cornerRadius - (self.tailWidth / 2), y: -self.padding)) // 三角の先っちょ。ここから時計回りに三角形を描く
                    }
                    .fill(Color.white)
                    .frame(height: 16)
                    Spacer()
                }
            }
        }
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView(presentTutorial: .constant(true))
    }
}
