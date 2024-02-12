////
////  SettingsList.swift
////  Currency Widget
////
////  Created by macSlm on 27.12.2023.
////
//
//import Foundation
//import RxSwift
//
//
//
//struct Property: Codable {
//    var key: PropertyType
//    var value: String
//}
//
//enum PropertyType: String, Codable {
//    case theme = "Theme"
//}
//
//protocol SettingsProtocol {
//    var rxSettingsUpdated: BehaviorSubject<PropertyType?> { get set }
//
//
//    func returnSettings() -> [Property]
//    func returnProperty(key: PropertyType) -> Property?
//    func changeProperty(key: PropertyType, newValue: String)
//}
//
//class SettingsWorker {
//
//    var rxSettingsUpdated = BehaviorSubject<PropertyType?>(value: nil)
//
//
//    let defaults = UserDefaults.standard
//
//    var settingsList: [Property] = []
//
//    init() {
//        settingsList = fetchFromDefaults()
//
//    }
//
//
//}
//
//extension SettingsWorker: SettingsProtocol {
//    func returnSettings() -> [Property] {
//        return settingsList
//    }
//
//    func returnProperty(key: PropertyType) -> Property? {
//        for item in settingsList {
//            if item.key == key {
//                return item
//            }
//        }
//        return nil
//    }
//
//    func changeProperty(key: PropertyType, newValue: String) {
//        for i in settingsList.indices {
//            if settingsList[i].key == key {
//                settingsList[i].value = newValue
//                rxSettingsUpdated.onNext(key)
//                return
//            }
//        }
//    }
//
//
//}
//
//
//// MARK: - USER DEFAULTS
//extension SettingsWorker {
//    private func saveToDefaults() {
//        let encoder = JSONEncoder()
//
//        if let settings = try? encoder.encode(settingsList) {
//            defaults.set(settings, forKey: "SettingsList")
//            print("--Settings was saved--")
//        }
//    }
//
//    private func fetchFromDefaults() -> [Property] {
//        var list: [Property] = [
//            Property(key: .theme, value: "System")
//        ]
//
//        if let savedData = defaults.object(forKey: "SettingsList") as? Data {
//            let decoder = JSONDecoder()
//            do {
//                let savedList = try decoder.decode([Property].self, from: savedData)
//                list = savedList
//            }
//            catch {
//                return list
//            }
//        }
//        return list
//    }
//}
//
//
//
