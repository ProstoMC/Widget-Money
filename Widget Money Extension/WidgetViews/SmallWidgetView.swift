//
//  SmallWidgetView.swift
//  Time
//
//  Created by  slm on 08.02.2024.
//

import Foundation
import SwiftUI


struct SmallWidgetView: View {
    var widgetCellModels: [WidgetCellModel]
    
    init(widgetCellModels: [WidgetCellModel]) {
        self.widgetCellModels = widgetCellModels
    }
    
    var body: some View {
        ZStack  {
//            Color.init(uiColor: UIColor(
//                red: entry.storedColor.red, green: entry.storedColor.green, blue: entry.storedColor.blue, alpha: 1))
            Color.init(uiColor: UIColor(red: 22/255, green: 30/255, blue: 49/255, alpha: 1))
            VStack (spacing: 0) {
                if widgetCellModels.count == 0 {
                    EmptyCell()
                }
                if widgetCellModels.count > 0 {
                    SmallCell(cellModel: widgetCellModels[0])
                }
                if widgetCellModels.count > 1 {
                    Divider()
                    SmallCell(cellModel: widgetCellModels[1])
                }
                if widgetCellModels.count > 2 {
                    Divider()
                    SmallCell(cellModel: widgetCellModels[2])
                }
            }

        }
    }
}
