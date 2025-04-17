# WidgetKit Code Tutorial

## Overview

For this iOS programming tutorial, we will be creating an app to tell us the hours of GVSU's libraries. Using WidgetKit, we will be able to create widgets that show up to date information at a glance. Since we don't have room to show all four libraries, we'll have to allow the user to select an individual library to focus on and must decide what information to show/omit at different sizes.

## Getting Started

All we need to get started on this app is Xcode. On macos, you can install Xcode through the App Store. 

![](./app_store_xcode.png)

Once it's installed, you will be prompted to install the iOS simulator and other parts of the development toolchain. Once you have those installed, we can move on to starting our app.

## Steps

### Creating Our Project

Once you start Xcode for the first time, you will be prompted to create a new project from a template. Select App from the iOS tab and click "Next".

![](./xcode_project_template.png)

On the next page, you will be prompted for some more information about this app. The product name and organization identifier are up to you, but make sure to choose Swift for the language and SwiftUI for the interface. Then click "Next"

![](./xcode_project_options.png)

Finally, you have to choose where this project will go. Once you've chosen the destination, click "Create". Congrats! You now have a working app in Xcode.

![](./xcode_project_location.png)

### Adding a Widget

From Xcode, go to File > New > Target

![](./xcode_new_target.png)

On the next screen, select "Widget Extension" and click "Next".

![](./xcode_target_template.png)

You'll be prompted to give this extension a name. Once you're done, click "Finish".

![](./xcode_target_options.png)

Make sure to activate the scheme for our new target when prompted.

![](./xcode_activate_scheme.png)

### Widget Configuration

Since we want users to be able to select a specific library to show, we need to add that option. We start by defining an enum that stores each possible option. 

```swift
//  AppIntent.swift
import WidgetKit
import AppIntents

enum LibraryEnum : String {
    case maryIdemaPew = "Mary Idema Pew Library"
    case steelcase = "Steelcase Library"
    case freyFoundation = "Frey Foundation Learning Commons"
    case lemmen = "Lemmen Library & Archives"
}
```

Then we need to tell Swift how to display each enum case using an extension.

```swift
//  AppIntent.swift
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
```

Finally, we describe the widget configuration (what shows up when you tap "Edit Widget" on iOS) and add our enum as one of the parameters.

```swift
//  AppIntent.swift
struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "WidgetKit demo" }
    
    @Parameter(title: "Library", default: .maryIdemaPew)
    var library: LibraryEnum
}
```

### Building the ViewModel

To store the information we have on each library, we need to create a ViewModel that we can watch for updates. To get started, all we need to do is create a dictionary mapping the enum we just created to a physical building.

```swift
//  LibraryViewModel.swift
import SwiftUI

class LibrariesViewModel: ObservableObject {
    @Published var libraries: [LibraryEnum: Location] = [:]
}
```

Now that we have the ViewModel, we need to write the `Location` struct. Once we start talking to the api, this will let us parse the response and get the data we need.

```swift
//  LibraryViewModel.swift
struct Location: Codable, Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let times: Times
    let rendered: String
    enum CodingKeys: String, CodingKey {
        case name
        case category
        case times
        case rendered
    }
}

struct Hours: Codable {
    let from: String
    let to: String
}

struct Times: Codable {
    let currently_open: Bool
    let hours: [Hours]?
}

struct LibrariesResponse: Codable {
    let locations: [Location]
}
```

### Talking to the API

Now that we're ready to parse the API response, it's time to start talking to it. To do this, we create a URL from a string, call `JSONDecoder().decode()` with the `LibrariesResponse` struct we created earlier, and put the locations we want in the ViewModel.

```swift
//  LibrariesHelper.swift
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
```

## Conclusions

## See Also
Apple's documentation for [WidgetKit](https://developer.apple.com/documentation/widgetkit/) is a valuable resource.