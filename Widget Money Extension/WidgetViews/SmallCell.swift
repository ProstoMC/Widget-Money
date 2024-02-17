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
    var image: UIImage!
    
    init(cellModel: WidgetCellModel) {
        self.cellModel = cellModel
            
        colorFlow = Color.red
        flowText = String(format: "%.2f",  cellModel.flow)
        if cellModel.flow >= 0 {
            colorFlow = .green
            flowText = "+" + flowText
        }
        
        image = createImage(data: cellModel.imageData)
  
    }
                          
    private func createImage(data: Data?) -> UIImage {
        let defaultImage = UIImage(systemName: "dollarsign.circle")!.withRenderingMode(.alwaysTemplate)
        defaultImage.withTintColor(
            UIColor(red: 244/255, green: 177/255, blue: 121/255, alpha: 0.85),
            renderingMode: .alwaysTemplate)
        guard let imageData = data else {
            return defaultImage
        }
        guard let newImage = UIImage(data: imageData) else {
            return defaultImage
        }
        
        return newImage
    }
    
    var body: some View {
        GeometryReader { reader in //For Image size
            ZStack {
                Color.init(uiColor: UIColor(red: 22/255, green: 30/255, blue: 49/255, alpha: 1))
                HStack {
                    HStack(spacing: 5) {
        
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: reader.size.width/6, height: reader.size.width/6)
                            .scaledToFill()
                            .clipShape(Circle())
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


