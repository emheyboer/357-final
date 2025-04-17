//
//  LibrariesHelper.swift
//  isTheLibraryOpen
//
//  Created by Emily Heyboer and Logan Scheurer on 4/11/25.
//
import SwiftUI

let api_url = "https://api3.libcal.com/api_hours_today.php?iid=1647&lid=0&format=json&systemTime=1"

func fetchLibraries(viewModel: LibrariesViewModel) async {
    guard let url = URL(string: api_url) else { return }

    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let response = try JSONDecoder().decode(LibrariesResponse.self, from: data)
        
        for location in response.locations {
            if location.category != "library" { continue }
            let library = LibraryEnum(rawValue: location.name)!
            viewModel.libraries[library] = location
        }
        
    } catch {
        print("Failed to fetch libary hours")
    }
}
