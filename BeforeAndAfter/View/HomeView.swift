//
//  HomeView.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/03/06.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .navigationBarTitle("Home", displayMode: .inline)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
