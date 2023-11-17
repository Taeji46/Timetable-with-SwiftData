import SwiftUI

struct ColorTemplate: Identifiable {
    let id = UUID()
    let color: Color
    let name: String
}

let courseColorTemplates: [ColorTemplate] = [
    ColorTemplate(color: .blue, name: "Blue"),
    ColorTemplate(color: .red, name: "Red"),
    ColorTemplate(color: .orange, name: "Orange"),
    ColorTemplate(color: .yellow, name: "Yellow"),
    ColorTemplate(color: .green, name: "Green"),
]

let themeColorTemplates: [ColorTemplate] = [
    ColorTemplate(color: .blue, name: "Blue"),
    ColorTemplate(color: .red, name: "Red"),
    ColorTemplate(color: .orange, name: "Orange"),
    ColorTemplate(color: .yellow, name: "Yellow"),
    ColorTemplate(color: .green, name: "Green"),
]
