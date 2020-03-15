//
//  BATabView.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/15.
//

import SwiftUI

struct BATabView: View {
    @State var presentTutorial = false
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = BAColor.navigationBarBackground
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .foregroundColor(Color(BAColor.navigationBarBackground))
                .edgesIgnoringSafeArea(.top)
                .frame(height: 0)
            
            TabView {
                HomeView()
                    .tabItem {
                        Image("home-24px")
                            .renderingMode(.template)
                            .foregroundColor(.blue)
                        Text("Home")
                }
                ChartView()
                    .tabItem {
                        Image("show_chart-24px")
                            .renderingMode(.template)
                            .foregroundColor(.blue)
                        Text("Chart")
                }
                HistoryView(viewModel: HistoryViewModel(recordRepository: RecordRepository()))
                    .tabItem {
                        Image("history-24px")
                            .renderingMode(.template)
                            .foregroundColor(.blue)
                        Text("History")
                    }
                SettingsView()
                    .tabItem {
                        Image("settings-24px")
                            .renderingMode(.template)
                            .foregroundColor(.blue)
                        Text("Settings")
                }
            }
            .onAppear() {
                self.presentTutorial = !UserDefaults.haveLaunchAppBefore
            }
            .overlay(presentTutorial ? TutorialView(presentTutorial: $presentTutorial) : nil)
        }
    }
}

struct BATabView_Previews: PreviewProvider {
    static var previews: some View {
        BATabView()
    }
}
