//
//  WidgetIntentHandler.swift
//  Widget Money
//
//  Created by sloniklm on 02.12.25.
//

import AppIntents
import Foundation

@available(iOS 17, *)
struct OpenPairIntent: AppIntent {
    static var title: LocalizedStringResource = "Open currency pair in app"
    
    static var openAppWhenRun: Bool = true // система откроет приложение

    @Parameter(title: "mainCode")
    var mainCode: String

    @Parameter(title: "baseCode")
    var baseCode: String

    init() {}
    
    init(mainCode: String, baseCode: String) {
        self.mainCode = mainCode
        self.baseCode = baseCode
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        // Сохраняем данные через Bridge / Notification
        AppIntentBridge.shared.callFromIntent(mainCode: mainCode, baseCode: baseCode)
        return .result()
    }
}

@MainActor
class AppIntentBridge: NSObject {
    static let shared = AppIntentBridge()

    @Published var mainCode: String = ""
    @Published var baseCode: String = ""

    func callFromIntent(mainCode: String, baseCode: String) {
        self.mainCode = mainCode
        self.baseCode = baseCode

        // Уведомляем UIKit
        NotificationCenter.default.post(
            name: .intentTriggered,
            object: nil,
            userInfo: ["main": mainCode, "base": baseCode]
        )
    }
}

extension Notification.Name {
    static let intentTriggered = Notification.Name("intentTriggered")
}
