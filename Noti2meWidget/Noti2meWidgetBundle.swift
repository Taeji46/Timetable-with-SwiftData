//
//  Noti2meWidgetBundle.swift
//  Noti2meWidget
//
//  Created by 細川泰智 on 2024/04/09.
//

import WidgetKit
import SwiftUI

@main
struct Noti2meWidgetBundle: WidgetBundle {
    var body: some Widget {
        Noti2meWidget()
        Noti2meWidgetLiveActivity()
    }
}
