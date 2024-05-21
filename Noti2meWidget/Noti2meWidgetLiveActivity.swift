//
//  Noti2meWidgetLiveActivity.swift
//  Noti2meWidget
//
//  Created by 細川泰智 on 2024/04/09.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct Noti2meWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct Noti2meWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Noti2meWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension Noti2meWidgetAttributes {
    fileprivate static var preview: Noti2meWidgetAttributes {
        Noti2meWidgetAttributes(name: "World")
    }
}

extension Noti2meWidgetAttributes.ContentState {
    fileprivate static var smiley: Noti2meWidgetAttributes.ContentState {
        Noti2meWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: Noti2meWidgetAttributes.ContentState {
         Noti2meWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: Noti2meWidgetAttributes.preview) {
   Noti2meWidgetLiveActivity()
} contentStates: {
    Noti2meWidgetAttributes.ContentState.smiley
    Noti2meWidgetAttributes.ContentState.starEyes
}
