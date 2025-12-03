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
        print("Widget got Snapshot")
        
        let entry = SimpleEntry(date: Date(), widgetModel: widgetModel)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        Task {
            
            //GET actual model
            
            guard let widgetModel = try? JSONDecoder().decode(WidgetModel.self, from: widgetData) else { return }
            print("Widget got data by Timeline")
            
            //Create Entry with info from App
            var entry = SimpleEntry(date: Date(), widgetModel: widgetModel)
            
            //Update rates from eth
            let fetcher = LiteFetcherForWidget()
            //Get model with new rates and update entry
            fetcher.updateFromBackend(widgetModel: widgetModel, completion: { newWidgetModel in
                entry = SimpleEntry(date: Date(), widgetModel: newWidgetModel)
                
                // Next fetch happens 30 minutes later
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
        
        //For lockscreen
        if family == .accessoryRectangular {
            AccessoryRectangularView(widgetCellModels: entry.widgetModel.cellModels)
                .widgetBackground(backgroundView: BackgroundViewForIOS17.init())
        }
        else {
            
            ZStack {
                VStack(spacing: 0){
                    Spacer()
                    HStack (spacing: 4) {
                        Spacer()
                        if #available(iOS 18.0, *) {
                            Image(systemName: "clock")
                                .resizable()
                                .widgetAccentedRenderingMode(.accentedDesaturated)
                                .scaledToFit()
                                .frame(width: 12, height: 12)
                                .foregroundColor(Color.white.opacity(0.5))
                        } else {
                            // Fallback on earlier versions
                            Image(systemName: "clock")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12, height: 12)
                                .foregroundColor(Color.white.opacity(0.5))
                        }
                        Text("\(entry.widgetModel.date)")
                            .font(.caption)
                            .fontWeight(.light)
                            .scaledToFill()
                            .foregroundColor(Color.white.opacity(0.5))
                            .padding(.trailing, 2)
                        
                    }
                    Spacer()
                    
                    if family == .systemSmall {
                        SmallWidgetView(widgetCellModels: entry.widgetModel.cellModels)
                    }
                    else if family == .systemMedium {
                        MediumWidgetView(widgetCellModels: entry.widgetModel.cellModels)
                    }
                    Spacer()
                }
            }
            .padding(8)
            .containerBackground(for: .widget) {
                Color(red: 22/255, green: 30/255, blue: 49/255)
            }
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
        .description("A widget that shows the latest currency rate")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryRectangular])
        .contentMarginsDisabledIfAvailable() // For iOS 17 and later
    }
}

struct Widget_Money_Extension_Previews: PreviewProvider {
    static var previews: some View {
        Widget_Money_ExtensionEntryView(entry: SimpleEntry(date: Date(), widgetModel: WidgetModel(cellModels: [], date: "no data")))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}



