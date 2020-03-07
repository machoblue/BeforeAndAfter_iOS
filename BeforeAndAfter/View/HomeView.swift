//
//  HomeView.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/03/06.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
//            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            List {
                Text(viewModel.countOfElapsedDay.description)
                Text(viewModel.countOfDayKeepRecording.description)
                Text(viewModel.weightSummary.latest.description)
                Text(viewModel.weightSummary.first.description)
                Text(viewModel.weightSummary.best.description)
                Text(viewModel.weightSummary.target.description)
                Text(viewModel.weightSummary.lost.description)
                Text(viewModel.weightSummary.remainig.description)
                Text(viewModel.fatPercentSummary.latest.description)
                Text(viewModel.fatPercentSummary.first.description)
//                Text(viewModel.fatPercentSummary.best.description)
//                Text(viewModel.fatPercentSummary.target.description)
//                Text(viewModel.fatPercentSummary.lost.description)
//                Text(viewModel.fatPercentSummary.remainig.description)
            }
                .navigationBarTitle("Home", displayMode: .inline)
        }
        .onAppear() {
            self.viewModel.apply(.onAppear)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
