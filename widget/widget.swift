//
//  widget.swift
//  widget
//
//  Created by emh on 4/6/25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct widgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Time:")
                Text(entry.date, style: .time)
                
                Text(entry.configuration.library.rawValue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            if family != WidgetFamily.systemSmall  {
                HStack {
                    Image(entry.configuration.library.rawValue)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 170, height: 400, alignment: .bottomTrailing)
                        .clipped()
                        .cornerRadius(10)
                        .padding(.trailing, -16)
                }
            }
        }
    }
}
            
struct widget: Widget {
    let kind: String = "widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            widgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
            }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var maryIdemaPew: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.library = Library.maryIdemaPew
        return intent
    }
    
    fileprivate static var steelcase: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.library = Library.steelcase
        return intent
    }
    
    fileprivate static var freyFoundation: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.library = Library.freyFoundation
        return intent
    }
    
    fileprivate static var lemmen: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.library = Library.lemmen
        return intent
    }
}

#Preview(as: .systemSmall) {
    widget()
} timeline: {
    SimpleEntry(date: .now, configuration: .maryIdemaPew)
    SimpleEntry(date: .now, configuration: .steelcase)
    SimpleEntry(date: .now, configuration: .freyFoundation)
    SimpleEntry(date: .now, configuration: .lemmen)
}
