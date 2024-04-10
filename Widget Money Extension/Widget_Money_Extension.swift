//
//  Widget_Money_Extension.swift
//  Widget Money Extension
//
//  Created by  slm on 12.02.2024.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    @AppStorage("WidgetCellModels", store: UserDefaults(suiteName: "group.com.sloniklm.Widget-Money"))
    var widgetData = Data()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), widgetCellModels: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
       
        guard let widgetModels = try? JSONDecoder().decode([WidgetCellModel].self, from: widgetData) else { return }
        print("Widget got data")
        
        let entry = SimpleEntry(date: Date(), widgetCellModels: widgetModels)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
        for _ in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            
            guard let widgetModels = try? JSONDecoder().decode([WidgetCellModel].self, from: widgetData) else { return }
            print("Widget got data")
            
            let entry = SimpleEntry(date: Date(), widgetCellModels: widgetModels)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let widgetCellModels: [WidgetCellModel]
}

struct Widget_Money_ExtensionEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
    
    
    @ViewBuilder
    var body: some View {
        ZStack {
            switch family {
            case .systemSmall: SmallWidgetView(widgetCellModels: entry.widgetCellModels)
            case .systemMedium: MediumWidgetView(widgetCellModels: entry.widgetCellModels)
            case .systemLarge:
                MediumWidgetView(widgetCellModels: entry.widgetCellModels)
            case .systemExtraLarge:
                MediumWidgetView(widgetCellModels: entry.widgetCellModels)
            case .accessoryCircular:
                SmallWidgetView(widgetCellModels: entry.widgetCellModels)
            case .accessoryRectangular:
                SmallWidgetView(widgetCellModels: entry.widgetCellModels)
            case .accessoryInline:
                SmallWidgetView(widgetCellModels: entry.widgetCellModels)
            @unknown default:
                SmallWidgetView(widgetCellModels: entry.widgetCellModels)
            }
        }.widgetBackground(backgroundView: BackgroundViewForIOS17.init())

    }
}

struct Widget_Money_Extension: Widget {
    let kind: String = "Widget_Money_Extension"

    var body: some WidgetConfiguration {
        
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Widget_Money_ExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabledIfAvailable() // For iOS 17 and later
    }
}

struct Widget_Money_Extension_Previews: PreviewProvider {
    static var previews: some View {
        Widget_Money_ExtensionEntryView(entry: SimpleEntry(date: Date(), widgetCellModels: []))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}



