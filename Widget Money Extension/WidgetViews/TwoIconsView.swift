//
//  TwoIconsView.swift
//  Widget Money
//
//  Created by admin on 28.10.24.
//

import SwiftUI
import WidgetKit

struct TwoIconsView: View {
    
    let mainImageData: Data?
    
    
    //MARK: - BODY
    
    var body: some View {
        
        if let data = mainImageData, let uiImage = UIImage(data: data) {
            if #available(iOS 18.0, *) {
                Image(uiImage: uiImage)
                    .resizable()
                    .widgetAccentedRenderingMode(.accentedDesaturated)
                    .scaledToFit()
                    .clipShape(Circle())
                    .padding(1)
            } else {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .padding(1)
            }
                
        }
        else {
            if #available(iOS 18.0, *) {
                Image(systemName: "dollarsign.circle") // плейсхолдер, если data nil
                    .resizable()
                    .widgetAccentedRenderingMode(.fullColor)
                    .scaledToFit()
                    .clipShape(Circle())
                    .tint(Color(red: 244/255, green: 177/255, blue: 121/255))
                    .padding(1)
            } else {
                // Fallback on earlier versions
                Image(systemName: "dollarsign.circle") // плейсхолдер, если data nil
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .tint(Color(red: 244/255, green: 177/255, blue: 121/255))
                    .padding(1)
            }
        }
    }
    
}

#Preview {
    TwoIconsView(mainImageData: nil)
}
