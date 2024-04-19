//
//  Widget_Money_Extension.swift
//  Widget Money Extension
//
//  Created by  slm on 12.02.2024.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    @AppStorage("WidgetModel", store: UserDefaults(suiteName: "group.com.sloniklm.WidgetMoney"))
    var widgetData = Data()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), widgetModel: WidgetModel(cellModels: [], date: "no date"))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
       
        guard let widgetModel = try? JSONDecoder().decode(WidgetModel.self, from: widgetData) else { return }
        print("Widget got data")
        
        let entry = SimpleEntry(date: Date(), widgetModel: widgetModel)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
        for _ in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            
            guard let widgetModel = try? JSONDecoder().decode(WidgetModel.self, from: widgetData) else { return }
            print("Widget got data")
            
            let entry = SimpleEntry(date: Date(), widgetModel: widgetModel)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    //let widgetCellModels: [WidgetCellModel]
    let widgetModel: WidgetModel
}

struct Widget_Money_ExtensionEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
    
    
    @ViewBuilder
    var body: some View {
        GeometryReader { reader in //For Image size
            ZStack {
                VStack(spacing: 0){
                    Text("Actual to \(entry.widgetModel.date)")
                        .font(.caption)
                        .fontWeight(.light)
                        .foregroundColor(Color.white.opacity(0.5))
                        .frame(width: reader.size.width-16, height: reader.size.height/15, alignment: .trailing)
                        .padding(.top, reader.size.height/20)
                        //.background(.yellow)
                    switch family {
                    case .systemSmall: SmallWidgetView(widgetCellModels: entry.widgetModel.cellModels)
                    case .systemMedium: MediumWidgetView(widgetCellModels: entry.widgetModel.cellModels)
                    case .systemLarge:
                        MediumWidgetView(widgetCellModels: entry.widgetModel.cellModels)
                    case .systemExtraLarge:
                        MediumWidgetView(widgetCellModels: entry.widgetModel.cellModels)
                    case .accessoryCircular:
                        SmallWidgetView(widgetCellModels: entry.widgetModel.cellModels)
                    case .accessoryRectangular:
                        SmallWidgetView(widgetCellModels: entry.widgetModel.cellModels)
                    case .accessoryInline:
                        SmallWidgetView(widgetCellModels: entry.widgetModel.cellModels)
                    @unknown default:
                        SmallWidgetView(widgetCellModels: entry.widgetModel.cellModels)
                    }
                }
                
                
            }.widgetBackground(backgroundView: BackgroundViewForIOS17.init())
        }
    }
}

struct Widget_Money_Extension: Widget {
    let kind: String = "Widget_Money_Extension"

    var body: some WidgetConfiguration {
        
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Widget_Money_ExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("WidgetMoney")
        .description("Widget for showing last course of currency")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabledIfAvailable() // For iOS 17 and later
    }
}

struct Widget_Money_Extension_Previews: PreviewProvider {
    static var previews: some View {
        Widget_Money_ExtensionEntryView(entry: SimpleEntry(date: Date(), widgetModel: WidgetModel(cellModels: [], date: "no data")))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}



