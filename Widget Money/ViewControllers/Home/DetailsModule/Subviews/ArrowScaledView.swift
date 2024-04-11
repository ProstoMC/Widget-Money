//
//  ArrowScaledView.swift
//  Widget Money
//
//  Created by  slm on 27.02.2024.
//

import UIKit

class ArrowScaledView: UIView {
    
    let arrowView = UIImageView()
    let lineView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(arrowView)
        self.addSubview(lineView)
        
        NSLayoutConstraint.activate([
            arrowView.rightAnchor.constraint(equalTo: self.rightAnchor),
            arrowView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            arrowView.heightAnchor.constraint(equalTo: self.heightAnchor),
            arrowView.widthAnchor.constraint(equalTo: self.heightAnchor),
            
            lineView.leftAnchor.constraint(equalTo: self.leftAnchor),
            lineView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            lineView.rightAnchor.constraint(equalTo: arrowView.leftAnchor),
            lineView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
        
        arrowView.image = UIImage(named: "arrow.white.opacity20")
        lineView.image = UIImage(named: "line.white.opacity20")
        
        arrowView.contentMode = .scaleAspectFit
        arrowView.contentMode = .scaleToFill
        
        
    }

}
