//
//  HomeWidget.swift
//  HomeWidget
//
//  Created by 邱慧珊 on 2023/7/18.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

import SwiftUI

struct HomeWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            // Background image
            GeometryReader { geo in
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            }

            VStack {
                Spacer()

                HStack {
                    // "專注" Button and label
                    VStack {
                        Button(action: {
                            // Add action for "專注" button tap
                        }) {
                            Image(systemName: "plus")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                        Text("專注")
                            .foregroundColor(.white)
                            .font(.headline)
                    }

                    Spacer()

                    // "任務" Button and label
                    VStack {
                        Button(action: {
                            // Add action for "任務" button tap
                        }) {
                            Image(systemName: "plus")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .clipShape(Circle())
                        }
                        Text("任務")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)

            }
        }
    }
}

//struct HomeWidgetEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        // Text(entry.date, style: .time)
//        ZStack {
//
//            GeometryReader { geo in
//
//                Image("background")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: geo.size.width,
//                           height: geo.size.height,
//                           alignment: .center)
//                    .clipped()
//            }
//
//            VStack {
//                HStack {
//                    Text("☘️開始專注吧！！")
//                        .foregroundColor(Color.white)
//                }
//            }
//
////            Text(entry.date, style: .time)
////                .font(Font.system(size: 24,
////                                  weight: .semibold,
////                                  design: .default))
////                .foregroundColor(Color.white)
//        }
//    }
//}

struct HomeWidget: Widget {
    let kind: String = "HomeWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            HomeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct HomeWidget_Previews: PreviewProvider {
    static var previews: some View {
        HomeWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
