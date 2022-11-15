//
//  TestWidgetExtension.swift
//  TestWidgetExtension
//
//  Created by iMac on 26/07/2022.
//

import WidgetKit
import SwiftUI
import Intents

private let widgetGroupId = "group.kotc"

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), title: "Placeholder Title",message: "Placeholder message")
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let data = UserDefaults.init(suiteName: widgetGroupId)
        let entry = SimpleEntry(date: Date(), title: data?.string(forKey: "title") ?? "Title error", message: data?.string(forKey: "message") ?? "Message Error")
       completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent,in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let sharedDefaults = UserDefaults.init(suiteName: widgetGroupId)
        if(sharedDefaults != nil) {
            do {
            }
let         flutterData = SimpleEntry(date: Date(), title: sharedDefaults?.string(forKey: "title") ?? "T Error", message: sharedDefaults?.string(forKey: "message") ?? "M Error")
            entries.append(flutterData)
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
//    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        getSnapshot(for: ConfigurationIntent, in: <#T##Context#>, completion: { @es
//        }) {(entry) in
//            let timeline = Timeline(entries: [entry], policy: .atEnd)
//            completion(timeline)
//        }
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let title: String
    let message: String
}

struct TestWidgetExtensionEntryView : View {
    var entry: Provider.Entry
    let data = UserDefaults.init(suiteName:widgetGroupId)
    
    var body: some View {
        VStack.init(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Text(entry.title).bold().font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            Text(entry.message)
                .font(.body)
                .widgetURL(URL(string: "homeWidgetExample://message?message=\(entry.message)&homeWidget"))
        }
        )
    }
}

@main
struct TestWidgetExtension: Widget {
    let kind: String = "TestWidgetExtension"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            TestWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct TestWidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        TestWidgetExtensionEntryView(entry: SimpleEntry(date: Date(),title: "Exaple Title",message: "Example message"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
