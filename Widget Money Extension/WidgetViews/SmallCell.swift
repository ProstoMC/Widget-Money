//
//  SmallCell.swift
//  Time
//
//  Created by  slm on 04.02.2024.
//

import Foundation
import SwiftUI


struct SmallCell: View {
    
    var cellModel: WidgetCellModel
    var colorFlow: Color
    var flowText: String
    
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
        GeometryReader { reader in //For Image size
            ZStack {
                Color.init(uiColor: UIColor(red: 22/255, green: 30/255, blue: 49/255, alpha: 1))
                HStack {
                    HStack(spacing: 5) {
        
                        TwoIconsView(mainImageData: cellModel.imageData, baseImageData: cellModel.baseImageData)
                            .frame(width: reader.size.width/6, height: reader.size.width/6)
                        VStack(alignment: .leading, spacing: 0) {
                            Text(cellModel.valueCode)
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
            }.padding(.leading, 5).padding(.trailing, 8)
        }
    }

}


