//
//  WidgetControlIntent.swift
//  Widget Money
//
//  Created by sloniklm on 03.12.25.
//

import AppIntents
import Foundation

@available(iOS 17, *)
struct WidgetControlIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Widget control (forward)"

    @Parameter(title: "mainCode")
    var mainCode: String

    @Parameter(title: "baseCode")
    var baseCode: String

    init() {}
    
    init(mainCode: String, baseCode: String) {
        self.mainCode = mainCode
        self.baseCode = baseCode
    }

    func perform() async throws -> some IntentResult & OpensIntent {
        // Возвращаем интент, который будет выполнен в приложении
        return .result(opensIntent: OpenPairIntent(
            mainCode: mainCode,
            baseCode: baseCode)
        )
    }
}
