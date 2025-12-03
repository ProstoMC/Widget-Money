//
//  MediumWidgetView.swift
//  Time
//
//  Created by  slm on 08.02.2024.
//

import Foundation
import SwiftUI


struct MediumWidgetView: View {
    var widgetCellModels: [WidgetCellModel]
    
    init(widgetCellModels: [WidgetCellModel]) {
        self.widgetCellModels = widgetCellModels
    }
    
    var body: some View {
        VStack {
            if 0 < widgetCellModels.count && widgetCellModels.count < 4 {
                VStack (spacing: 0) {
                    if widgetCellModels.count > 0 {
                        BigCell(cellModel: widgetCellModels[0])
                    }
                    if widgetCellModels.count > 1 {
                        Divider()
                        BigCell(cellModel: widgetCellModels[1])
                    }
                    if widgetCellModels.count > 2 {
                        Divider()
                        BigCell(cellModel: widgetCellModels[2])
                    }
                }
            }
            
            if widgetCellModels.count == 4 {
                HStack {
                    VStack (spacing: 10) {
                        SmallCell(cellModel: widgetCellModels[0])
                        Divider()
                        SmallCell(cellModel: widgetCellModels[1])
                    }
                    Divider()
                    VStack (spacing: 10) {
                        
                        SmallCell(cellModel: widgetCellModels[2])
                        Divider()
                        SmallCell(cellModel: widgetCellModels[3])
                    }
                }
            }
            if widgetCellModels.count == 5 {
                HStack {
                    VStack (spacing: 0) {
                        SmallCell(cellModel: widgetCellModels[0])
                        Divider()
                        SmallCell(cellModel: widgetCellModels[1])
                        Divider()
                        SmallCell(cellModel: widgetCellModels[2])
                    }
                    Divider()
                    VStack (spacing: 0) {
                        SmallCell(cellModel: widgetCellModels[3])
                        Divider()
                        SmallCell(cellModel: widgetCellModels[4])
                    }
                }
            }
            if widgetCellModels.count > 5 {
                HStack {
                    VStack (spacing: 0) {
                        SmallCell(cellModel: widgetCellModels[0])
                        Divider()
                        SmallCell(cellModel: widgetCellModels[1])
                        Divider()
                        SmallCell(cellModel: widgetCellModels[2])
                    }
                    Divider()
                    VStack (spacing: 0) {
                        SmallCell(cellModel: widgetCellModels[3])
                        Divider()
                        SmallCell(cellModel: widgetCellModels[4])
                        Divider()
                        SmallCell(cellModel: widgetCellModels[5])
                    }
                }
            }
        }
        
        
    }
    
}
