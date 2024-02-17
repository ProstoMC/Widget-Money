//
//  EmptyCell.swift
//  Widget Money
//
//  Created by  slm on 12.02.2024.
//

import Foundation
import SwiftUI


struct EmptyCell: View {
    
    var body: some View {
        ZStack {
            Color.init(uiColor: UIColor(red: 22/255, green: 30/255, blue: 49/255, alpha: 1))
            VStack {
                Image("WidgetCellImage")
            }
        }
    }
    
}
