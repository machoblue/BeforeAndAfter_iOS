//
//  HomeView.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/03/06.
//

import SwiftUI
import UIKit

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State var showEditAdd = false
    
    init(viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Spacer(minLength: 36)
                    
                    Text(String(format: "home_message_elapsed_day_template".localized, viewModel.countOfElapsedDay as Int))
                        .font(.system(size: BAFontSize.small))
                    Text(String(format: "home_message_keep_recording_day_template".localized, viewModel.countOfDayKeepRecording as Int))
                        .font(.system(size: BAFontSize.large))
    
                    Spacer(minLength: 24)
                    
                    Separator(title: "common_weight".localized)
                    SummaryView(summary: $viewModel.weightSummary, suffix: "common_kg".localized)
                    
                    Spacer(minLength: 48)
    
                    Separator(title: "common_fat_percent".localized)
                    SummaryView(summary: $viewModel.fatPercentSummary, suffix: "common_percent".localized)
                    
                    Spacer(minLength: 48)
                }
            }
            .navigationBarTitle("home_title", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.showEditAdd.toggle()
                }) {
                    Text("common_record".localized)
                }.sheet(isPresented: $showEditAdd) {
                    AddRecordView(record: Record(time: Date().timeIntervalSince1970, weight: UserDefaults.latestWeight, fatPercent: UserDefaults.latestFatPercent),
                                  viewModel: EditAddRecordViewModel())
                }
            )
        }
        .onAppear() {
            self.viewModel.apply(.onAppear)
        }
    }
    
    struct Separator: View {
        var title: String
        var body: some View {
            ZStack {
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: geometry.size.width, height: geometry.size.height / 2)
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: geometry.size.width, height: 1)
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: geometry.size.width, height: geometry.size.height / 2 - 1)
                    }
                }
                Text(title)
                    .font(.system(size: BAFontSize.medium))
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                    .background(Color.gray)
                    .cornerRadius(16)
            }
        }
    }
    
    struct SummaryView: View {
        @Binding var summary: Summary
        var suffix: String
        var body: some View {
            VStack {
                Text("\(summary.latest, specifier: "%.2f")\(suffix)")
                    .font(.system(size: BAFontSize.xLarge))
                HStack {
                    Text("home_comparison_prefix".localized)
                        .font(.system(size: BAFontSize.small))
                    Text("\(summary.comparisonToLastTime == 0 ? "" : summary.comparisonToLastTime > 0 ? "+" : "-")\(abs(summary.comparisonToLastTime), specifier: "%.2f")\(suffix)")
                        .font(.system(size: BAFontSize.small))
                        .foregroundColor(summary.comparisonToLastTime == 0 ? .black : summary.comparisonToLastTime > 0 ? .red : .green)
                    Text("home_comparison_suffix".localized)
                        .font(.system(size: BAFontSize.small))
                }
                
                Spacer(minLength: 24)
                
                GeometryReader { geometry in
                    HStack {
                        VStack {
                            Text("home_start_prefix".localized)
                                .font(.system(size: BAFontSize.small))
                            Text("\(self.summary.first, specifier: "%.2f")\(self.suffix)")
                                .font(.system(size: BAFontSize.medium))
                        }
                        .frame(width: geometry.size.width / 6, height: geometry.size.height)
                        
                        Indicator(first: self.summary.first, target: self.summary.target, latest: self.summary.latest, best: self.summary.best)
                            .frame(height: 12)

                        VStack {
                            Text("home_goal_prefix".localized)
                                .font(.system(size: BAFontSize.small))
                            Text("\(self.summary.target, specifier: "%.2f")\(self.suffix)")
                                .font(.system(size: BAFontSize.medium))
                        }
                        .frame(width: geometry.size.width / 6, height: geometry.size.height)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))

                Spacer()
                    .frame(width: 1, height: 18) // これがないと下の凡例が、上のindicatorに食い込む。なぜかわからない。

                HStack {
                    Text("●")
                        .font(.system(size: BAFontSize.small))
                        .foregroundColor(.blue)
                    Text("home_legend_label_now".localized)
                        .font(.system(size: BAFontSize.small))
                        .foregroundColor(.black)
                    Text("●")
                        .font(.system(size: BAFontSize.small))
                        .foregroundColor(.gray)
                    Text("home_legend_label_best".localized)
                        .font(.system(size: BAFontSize.small))
                        .foregroundColor(.black)
                }

                Spacer()
                    .frame(width: 1, height: 24)
                
                Text(String(format: "home_total_loss_template".localized, summary.lost as Float, suffix as String))
                    .lineLimit(nil)
                    .font(.system(size: BAFontSize.medium))
                    .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))

                Text(String(format: "home_remain_template".localized, summary.remainig as Float, suffix as String))
                    .lineLimit(nil)
                    .font(.system(size: BAFontSize.medium))
                    .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))

            }
        }
    }
    
    struct Indicator: View {
        var first: Float
        var target: Float
        var latest: Float
        var best: Float
        
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    // frame
                    RoundedRectangle(cornerRadius: geometry.size.height / 2)
                        .stroke(Color.black)
                    ZStack {
                        // best
                        HStack {
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: geometry.size.width * CGFloat((self.best - self.first) / (self.target - self.first + 0.001)), height: geometry.size.height)
                            Spacer()
                        }
                        
                        // latest1
                        HStack {
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: geometry.size.width * CGFloat((self.latest - self.first) / (self.target - self.first + 0.001)), height: geometry.size.height)
                            Spacer()
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: geometry.size.height / 2))
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
    
}
