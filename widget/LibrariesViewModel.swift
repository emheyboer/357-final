//
//  LibraryViewModel.swift
//  isTheLibraryOpen
//
//  Created by Emily Heyboer and Logan Scheurer on 4/11/25.
//
import SwiftUI

struct Location: Codable {
    let name: String
    let category: String
    let times: Times
    let rendered: String
}
struct Times: Codable {
    let currently_open: Bool
}

struct LibrariesResponse: Codable {
    let locations: [Location]
}

class LibrariesViewModel: ObservableObject {
    @Published var libraries: [LibraryEnum: Location] = [:]
}
