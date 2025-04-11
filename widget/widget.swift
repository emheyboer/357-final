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
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), hours: "Hours")
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, hours: "Hours")
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        let viewModel = LibrariesViewModel()
        await fetchLibraries(viewModel: viewModel)
        
        let library: LibraryEnum = configuration.library
        print(library)
        print(viewModel.libraries)
        let location = viewModel.libraries[library]!

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, hours: location.rendered)
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
    let hours: String
}

struct widgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hours:")
                Text(entry.hours)
                
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
        intent.library = LibraryEnum.maryIdemaPew
        return intent
    }
    
    fileprivate static var steelcase: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.library = LibraryEnum.steelcase
        return intent
    }
    
    fileprivate static var freyFoundation: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.library = LibraryEnum.freyFoundation
        return intent
    }
    
    fileprivate static var lemmen: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.library = LibraryEnum.lemmen
        return intent
    }
}

#Preview(as: .systemSmall) {
    widget()
} timeline: {
    SimpleEntry(date: .now, configuration: .maryIdemaPew, hours: "7:30am - 6:00pm")
    SimpleEntry(date: .now, configuration: .steelcase, hours: "8:00am - 6:00pm")
    SimpleEntry(date: .now, configuration: .freyFoundation, hours: "8:00am - 5:00pm")
    SimpleEntry(date: .now, configuration: .lemmen, hours: "8:00am - 4:30pm")
}
