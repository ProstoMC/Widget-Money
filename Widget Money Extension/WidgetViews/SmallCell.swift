//
//  SmallCell.swift
//  Time
//
//  Created by  slm on 04.02.2024.
//

import Foundation
import SwiftUI
import AppIntents
import WidgetKit


struct SmallCell: View {
    
    var cellModel: WidgetCellModel
    var colorFlow: Color
    var flowText: String
    
    static let formatterWithFraction: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = " "
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    
    init(cellModel: WidgetCellModel) {
        self.cellModel = cellModel
        
        colorFlow = Color.red
        flowText = String(format: "%.2f",  cellModel.flow) + cellModel.baseSymbol
        if cellModel.flow >= 0 {
            colorFlow = .green
            flowText = "+" + flowText
        }
        
    }
    
    var body: some View {
        if #available(iOS 17.0, *) {
            Button(intent: WidgetControlIntent(mainCode: cellModel.valueCode, baseCode: cellModel.baseCode)) {
                SmallCellContentView(cellModel: cellModel, colorFlow: colorFlow, flowText: flowText)
            }.buttonStyle(.plain)
        } else {
            // Fallback on earlier versions
            SmallCellContentView(cellModel: cellModel, colorFlow: colorFlow, flowText: flowText)
        }
    }
    
}


struct SmallCellContentView: View {
    
    var cellModel: WidgetCellModel
    var colorFlow: Color
    var flowText: String
    
    var body: some View {
        HStack (spacing: 0) {
            HStack(spacing: 2) {
                TwoIconsView(mainImageData: cellModel.imageData)
                    .frame(width: 27, height: 27)
                    .scaledToFit()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(cellModel.valueCode)
                        .font(.subheadline)
                        .lineLimit(1)
                        .foregroundColor(Color.white.opacity(0.85))
                    Text("to \(cellModel.baseCode)")
                        .font(.caption)
                        .fontWeight(.light)
                        .lineLimit(1)
                        .foregroundColor(Color.white.opacity(0.5))
                        .minimumScaleFactor(0.01)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            HStack {
                VStack(alignment: .trailing, spacing: 0) {
                    Text("\(SmallCell.formatterWithFraction.string(for: (cellModel.value)) ?? "0")\(cellModel.baseSymbol)")
                        .font(.subheadline)
                        .minimumScaleFactor(0.01)
                        .layoutPriority(1)
                        .lineLimit(1)
                        .foregroundColor(Color.white.opacity(0.7))
                    
                    Text(flowText)
                        .font(.caption)
                        .fontWeight(.light)
                        .minimumScaleFactor(0.01)
                        .layoutPriority(1)
                        .lineLimit(1)
                        .foregroundColor(colorFlow.opacity(0.9))
                    
                }.frame(maxHeight: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
        }
        .padding(.vertical, 2)
    }
}
