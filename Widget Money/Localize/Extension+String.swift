//
//  Extension+String.swift
//  Widget Money
//
//  Created by  slm on 18.02.2024.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self
        )
    }
}
