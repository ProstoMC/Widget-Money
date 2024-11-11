//
//  TwoIconsView.swift
//  Widget Money
//
//  Created by admin on 28.10.24.
//

import SwiftUI

struct TwoIconsView: View {
    
    var mainImage: UIImage!
    var baseImage: UIImage!
    
    init(mainImageData: Data?, baseImageData: Data?) {
        mainImage = createImage(data: mainImageData)
        baseImage = createImage(data: baseImageData)
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
    
    //MARK: - BODY
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Image(uiImage: baseImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width*0.55, height: geometry.size.height*0.55)
                            .clipShape(Circle())
                    }
                }
            }
            HStack {
                VStack {
                    Image(uiImage: mainImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width*0.7, height: geometry.size.height*0.7)
                        .clipShape(Circle())
                    Spacer()
                }
                Spacer()
            }
        }
        
    }
}

#Preview {
    TwoIconsView(mainImageData: nil, baseImageData: nil)
}
