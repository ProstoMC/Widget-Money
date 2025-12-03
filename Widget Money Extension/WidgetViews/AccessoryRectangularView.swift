//
//  AccessoryRectangularView.swift
//  Widget Money
//
//  Created by admin on 23.01.25.
//

import SwiftUI

struct AccessoryRectangularView: View {
    var widgetCellModels: [WidgetCellModel]  //Max 2 items
    

    
    init(widgetCellModels: [WidgetCellModel]) {
        self.widgetCellModels = []
        if widgetCellModels.count<2 {
            self.widgetCellModels = widgetCellModels
        } else {
            self.widgetCellModels.append(widgetCellModels[0])
            self.widgetCellModels.append(widgetCellModels[1])
            //self.widgetCellModels.append(widgetCellModels[2])
        }
    }
    

    
    var body: some View {
        VStack (spacing: 3) {
            ForEach(widgetCellModels, id: \.id) { model in
                LockScreenPairRow(model: model)
            }
            
        }
        .padding(5)

    }
}


struct LockScreenPairRow: View {
    var model: WidgetCellModel
    
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
        HStack {
            Image(uiImage: createImage(data: model.imageData))
                .resizable()
                .frame(maxWidth: 20, maxHeight: 20)
                .scaledToFit()
                .clipShape(Circle())
                .padding(1)
            Text(model.valueCode)
                .font(.callout)
            Spacer()
            ViewThatFits {
                Text("\(LockScreenPairRow.formatterWithFraction.string(for: (model.value)) ?? "0") \(model.baseSymbol)")
                    .font(.callout)
                
                Text("\(model.value, specifier: "%.0f") \(model.baseSymbol)")
                    .font(.callout)
                
                Text("\(model.value, specifier: "%.0f") \(model.baseSymbol)")
                    .font(.footnote)
                
                Text("~\((LockScreenPairRow.formatterWithFraction.string(for: (model.value/1000)) ?? "0"))K \(model.baseSymbol)")
                    .font(.footnote)
                
                Text("~\((LockScreenPairRow.formatterWithFraction.string(for: (model.value/1000000)) ?? "0"))M \(model.baseSymbol)")
                    .font(.footnote)            }
        }
    }
}

