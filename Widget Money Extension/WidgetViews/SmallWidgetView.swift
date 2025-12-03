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
        
        VStack (spacing: 2) {
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

#Preview {
    SmallWidgetView(widgetCellModels: [])
}
