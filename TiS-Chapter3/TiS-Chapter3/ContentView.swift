//
//  ContentView.swift
//  TiS-Chapter3
//
//  Created by Rahul Sharma on 18/05/22.
//

import SwiftUI

struct KnobShape: Shape {
    
    var pointerSize: CGFloat = 0.1 // these are relative values
    var pointerWidth: CGFloat = 0.1
    
    func path(in rect: CGRect) -> Path {
        let pointerHeight = rect.height * pointerSize
        let pointerWidth = rect.width * self.pointerWidth
        let circleRect = rect.insetBy(dx: pointerHeight, dy: pointerHeight)
        return Path { p in
            p.addEllipse(in: circleRect)
            p.addRect(CGRect(x: rect.midX - pointerWidth/2, y: 0, width: pointerWidth, height: pointerHeight + 2))
        }
    }
    
}

fileprivate struct PointerSizeKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0.1
}

fileprivate struct KnobColorKey: EnvironmentKey {
    static let defaultValue: Color? = nil
}

extension EnvironmentValues {
    var knobPointerSize: CGFloat {
        get { self[PointerSizeKey.self] }
        set { self[PointerSizeKey.self] = newValue }
    }
}

extension EnvironmentValues {
    var knobColor: Color? {
        get { self[KnobColorKey.self] }
        set { self[KnobColorKey.self] = newValue }
    }
}

extension View {
    func knobPointerSize(_ size: CGFloat) -> some View {
        self.environment(\.knobPointerSize, size)
    }
    func knobColor(_ color: Color) -> some View {
        self
            .environment(\.knobColor, color)
    }
}

struct Knob: View {
    
    @Binding var value: Double // should be between 0 and 1
    
    var pointerSize: CGFloat? = nil
    
    @Environment(\.knobPointerSize) var envPointerSize
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.knobColor) var knobColor
    
    var body: some View {
        KnobShape(pointerSize: pointerSize ?? envPointerSize)
            .fill(knobColor ?? (colorScheme == .dark ? Color.white : .black))
            .rotationEffect(Angle(degrees: value * 330))
            .onTapGesture {
                withAnimation(.default) {
                    self.value = self.value < 0.5 ? 1 : 0
                }
            }
    }
    
}

struct ContentView: View {
    
    @State var value: Double = 0.5
    @State var knobSize: CGFloat = 0.1
    @State var knobColorHue: Double = 0.1
    
    var body: some View {
        VStack {
            Knob(value: $value)
                .frame(width: 100, height: 100)
                .knobPointerSize(knobSize)
                .knobColor(Color(hue: knobColorHue, saturation: 0.5, brightness: 0.9))
            HStack {
                Text("Value")
                Slider(value: $value, in: 0...1)
            }
            HStack {
                Text("Knob Size")
                Slider(value: $knobSize, in: 0...0.4)
            }
            HStack {
                Text("Knob Color")
                Slider(value: $knobColorHue, in: 0...1)
            }
            Button("Toggle") {
                withAnimation(.default) {
                    value = value == 0 ? 1 : 0
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
