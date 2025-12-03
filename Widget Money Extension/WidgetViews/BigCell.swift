//
//  BigCell.swift
//  Time
//
//  Created by  slm on 08.02.2024.
//

import Foundation
import SwiftUI

struct BigCell: View {
    
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
        
        colorFlow = Color.green
        if cellModel.flow < 0 {
            colorFlow = .red
        }
        flowText = String(format: "%.2f",  cellModel.flow) + cellModel.baseSymbol
        if cellModel.flow >= 0 {
            colorFlow = .green
            flowText = "+" + flowText
        }
    }
        
    var body: some View {
        if #available(iOS 17.0, *) {
            Button(intent: WidgetControlIntent(mainCode: cellModel.valueCode, baseCode: cellModel.baseCode)) {
                BigCellContentView(cellModel: cellModel, colorFlow: colorFlow, flowText: flowText)
            }.buttonStyle(.plain)
        } else {
            // Fallback on earlier versions
            BigCellContentView(cellModel: cellModel, colorFlow: colorFlow, flowText: flowText)
        }
        
    }
}

struct BigCellContentView: View {
    var cellModel: WidgetCellModel
    var colorFlow: Color
    var flowText: String
    
    var body: some View {
        HStack {
            HStack(spacing: 5) {
                
                TwoIconsView(mainImageData: cellModel.imageData)
                    .scaledToFit()
                    .frame(width: 27, height: 27)
                    
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(cellModel.valueCode) - \(cellModel.valueName)")
                        .font(.subheadline)
                        .lineLimit(1)
                        .scaledToFill()
                        .foregroundColor(Color.white.opacity(0.85))
                    Text("to \(cellModel.baseCode)")
                        .font(.caption)
                        .fontWeight(.light)
                        .lineLimit(1)
                        .scaledToFill()
                        .foregroundColor(Color.white.opacity(0.5))
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(cellModel.value, specifier: "%.2f")\(cellModel.baseSymbol)")
                    .font(.subheadline)
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                    .foregroundColor(Color.white.opacity(0.7))
                Text(flowText)
                    .font(.caption)
                    .fontWeight(.light)
                    .lineLimit(1)
                    .foregroundColor(colorFlow.opacity(0.9))
            }
        }
        .padding(.vertical, 2)
    }
}
