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
        
        Task {
            
            guard let widgetModel = try? JSONDecoder().decode(WidgetModel.self, from: widgetData) else { return }
            
            let fetcher = LiteFetcherForWidget()
            
            fetcher.updateRatesFromEth(widgetModel: widgetModel, completion: { newWidgetModel in
                
                let entry = SimpleEntry(date: Date(), widgetModel: newWidgetModel)
                
                // Next fetch happens 15 minutes later
                let nextUpdate = Calendar.current.date(
                    byAdding: DateComponents(minute: 30),
                    to: Date()
                )!
                
                let timeline = Timeline(
                    entries: [entry],
                    policy: .after(nextUpdate)
                )
                
                completion(timeline)
                
            })
            
            
        }
    }
    
    
    
    
}

struct SimpleEntry: TimelineEntry {
    let date: Date
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
                    Text("🕗 \(entry.widgetModel.date)")
                        .font(.caption)
                        .fontWeight(.light)
                        .scaledToFill()
                        .foregroundColor(Color.white.opacity(0.5))
                        .frame(width: reader.size.width-16, height: reader.size.height/15, alignment: .trailing)
                        .padding(.top, reader.size.height/20)
                        .padding(.bottom, reader.size.height/40)
                    //.background(.yellow)
                    
                    if family == .systemSmall {
//                        CustomDivider(percent: 0.55)
//                            .frame(width: reader.size.width-16, height: 0.5)
                        SmallWidgetView(widgetCellModels: entry.widgetModel.cellModels)
                            .background(ContainerRelativeShape())
                    } else 
                    if family == .systemMedium {
//                       CustomDivider(percent: 0.25)
//                           .frame(width: reader.size.width-16, height: 0.5)
                        MediumWidgetView(widgetCellModels: entry.widgetModel.cellModels)
                            .background(ContainerRelativeShape())
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



