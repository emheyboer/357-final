//
//  ContentView.swift
//  isTheLibraryOpen
//
//  Created by Emily Heyboer and Logan Scheurer on 4/6/25.
//

import SwiftUI

enum LibraryEnum : String {
    case maryIdemaPew = "Mary Idema Pew Library"
    case steelcase = "Steelcase Library"
    case freyFoundation = "Frey Foundation Learning Commons"
    case lemmen = "Lemmen Library & Archives"
}

let preview_location = Location(name: "Library", category: "library",times: Times(currently_open: false, hours: []), rendered: "6:00am - 6:00pm")

struct ContentView: View {
    @State var locations = [preview_location]
    let viewModel = LibrariesViewModel()
    
    var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                List(locations) {location in
                    VStack {
                        Text(location.name)
                        
                        let has_hours = location.times.hours != nil &&  location.times.hours!.count > 0
                        if location.times.currently_open {
                            if has_hours {
                                Text("Open until \(location.times.hours![0].to)")
                            } else {
                                Text("Open")
                            }
                        } else {
                            if has_hours {
                                Text("Closed until \(location.times.hours![0].from)")
                            } else {
                                Text("Closed")
                            }
                        }
                        
                        Image(location.name)
                            .resizable()
                            .scaledToFill()
                    }
                }
            }
            .onAppear {
                Task {
                    await fetchLibraries(viewModel: viewModel)
                    locations = Array(viewModel.libraries.values)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
    }}

#Preview {
    ContentView()
}
