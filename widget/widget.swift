//
//  widget.swift
//  widget
//
//  Created by Emily Heyboer and Logan Scheurer on 4/6/25.
//

import WidgetKit
import SwiftUI

let preview_location = Location(name: "Library", category: "library",times: Times(currently_open: false, hours: []), rendered: "6:00am - 6:00pm")

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), location: preview_location)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, location: preview_location)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        let viewModel = LibrariesViewModel()
        await fetchLibraries(viewModel: viewModel)
        
        let library: LibraryEnum = configuration.library
        print(library)
        let location = viewModel.libraries[library] ?? preview_location

        let currentDate = Date()
        for hourOffset in 0 ..< 24 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, location: location)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let location: Location
}

struct widgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.configuration.library.rawValue)
                
                let has_hours = entry.location.times.hours != nil &&  entry.location.times.hours!.count > 0
                if entry.location.times.currently_open {
                    if has_hours {
                        Text("Open until \(entry.location.times.hours![0].to)")
                    } else {
                        Text("Open")
                    }
                } else {
                    if has_hours {
                        Text("Closed until \(entry.location.times.hours![0].from)")
                    } else {
                        Text("Closed")
                    }
                }
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
    SimpleEntry(date: .now, configuration: .maryIdemaPew, location: preview_location)
    SimpleEntry(date: .now, configuration: .steelcase, location: preview_location)
    SimpleEntry(date: .now, configuration: .freyFoundation, location: preview_location)
    SimpleEntry(date: .now, configuration: .lemmen, location: preview_location)
}
