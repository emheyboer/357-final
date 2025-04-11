//
//  AppIntent.swift
//  widget
//
//  Created by emh on 4/6/25.
//

import WidgetKit
import AppIntents

enum LibraryEnum : String {
    case maryIdemaPew = "Mary Idema Pew Library"
    case steelcase = "Steelcase Library"
    case freyFoundation = "Frey Foundation Learning Commons"
    case lemmen = "Lemmen Library & Archives"
}

extension LibraryEnum: AppEnum {
    static var caseDisplayRepresentations: [LibraryEnum: DisplayRepresentation] = [
        .maryIdemaPew: DisplayRepresentation(title: "Mary Idema Pew Library"),
            .steelcase: DisplayRepresentation(title: "Steelcase Library"),
        .freyFoundation: DisplayRepresentation(title: "Frey Foundation Learning Commons"),
        .lemmen: DisplayRepresentation(title: "Lemmen Library & Archives"),
    ]
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(
            name: LocalizedStringResource("Library", table: "AppIntents"),
            numericFormat: LocalizedStringResource("\(placeholder: .int) libraries", table: "AppIntents")
        )
    }
}

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "This is an example widget." }
    
    @Parameter(title: "Library", default: .maryIdemaPew)
    var library: LibraryEnum
}
