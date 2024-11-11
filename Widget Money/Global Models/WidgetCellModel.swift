//
//  StoredColor.swift
//  Time
//
//  Created by  slm on 03.02.2024.
//

import Foundation

public struct WidgetCellModel: Codable {
    var id: Int
    var valueCode: String
    var baseCode: String
    var value: Double
    var flow: Double
    var valueName: String
    var baseSymbol: String
    var imageData: Data?
    var baseImageData: Data?
}


public struct WidgetModel: Codable {
    var cellModels: [WidgetCellModel]
    var date: String
}
