//
//  TutorialView.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/03/09.
//

import SwiftUI

struct TutorialView: View {
    @Binding var presentTutorial: Bool
    
    var body: some View {
        Rectangle()
            .foregroundColor(Color(UIColor.black.withAlphaComponent(0.5)))
            .gesture(TapGesture().onEnded {
//                UserDefaults.haveLaunchAppBefore = true
                self.presentTutorial = false
            })
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView(presentTutorial: .constant(true))
    }
}
