//
//  AppIntent.swift
//  widget
//
//  Created by emh on 4/6/25.
//

import WidgetKit
import AppIntents

enum Library : String {
    case maryIdemaPew = "Mary Idema Pew Library"
    case steelcase = "Steelcase Library"
    case freyFoundation = "Frey Foundation Learning Commons"
    case lemmen = "Lemmen Library & Archives"
}

extension Library: AppEnum {
    static var caseDisplayRepresentations: [Library: DisplayRepresentation] = [
        .maryIdemaPew: DisplayRepresentation(title: "Mary Idema Pew Library"),
        //                                       subtitle: "Mountain bike ride",
        //                                       image: imageRepresentation[.biking]),
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
    var library: Library
}
