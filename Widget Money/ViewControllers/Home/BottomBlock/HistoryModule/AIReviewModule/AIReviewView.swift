//
//  AIReviewView.swift
//  Widget Money
//
//  Created by Алексей Никитин on 05.02.26.
//

import SwiftUI

struct AIReviewView: View {
    
    @ObservedObject var colorModel = CoreWorker.shared.colorsWorker.colorsObservable
    @ObservedObject var historyVM: HistoryViewModel
    
    var body: some View {
        VStack {
            Text("✨ AI Review")
                .font(.title2)
                .foregroundStyle(colorModel.mainText)
            Spacer()
            ChartView(viewModel: historyVM)
        }
        .background(colorModel.background)
        
    }
}


