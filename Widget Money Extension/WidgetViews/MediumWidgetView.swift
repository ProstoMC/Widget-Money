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
        GeometryReader { reader in // For Cell Size
            
            ZStack {
                Color.init(uiColor: UIColor(red: 22/255, green: 30/255, blue: 49/255, alpha: 1))
                
                    if 0 < widgetCellModels.count && widgetCellModels.count < 4 {
                        VStack (spacing: 0) {
                            if widgetCellModels.count > 0 {
                                
                                BigCell(cellModel: widgetCellModels[0])
                                    //.frame(width: reader.size.width/2)
                            }
                            if widgetCellModels.count > 1 {
                                Divider()
                                BigCell(cellModel: widgetCellModels[1])
                                    //.frame(width: reader.size.width/2)
                            }
                            if widgetCellModels.count > 2 {
                                Divider()
                                BigCell(cellModel: widgetCellModels[2])
                                   //.frame(width: reader.size.width/2)
                            }
                        }
                    }
                    
                    if widgetCellModels.count == 4 {
                        HStack {
                            VStack (spacing: 0) {
                                SmallCell(cellModel: widgetCellModels[0])
                                Divider()
                                SmallCell(cellModel: widgetCellModels[1])
                            }
                            Divider()
                            VStack (spacing: 0) {
                                
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
                                SmallCell(cellModel: widgetCellModels[3])
                            }
                            Divider()
                            VStack (spacing: 0) {
                                SmallCell(cellModel: widgetCellModels[4])
                                Divider()
                                SmallCell(cellModel: widgetCellModels[5])
                                Divider()
                                SmallCell(cellModel: widgetCellModels[6])
                            }
                        }
                    }
                }
            
        }
    }
}
