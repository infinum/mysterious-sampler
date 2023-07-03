import SwiftUI

struct ResonanceControlView: View {
    @State private var value: Float = -3
    @StateObject var conductor = ResonanceControlConductor()

    var body: some View {
        VStack {
            Slider(
                value: $value,
                in: -3...40,
                label: { Text("\(value)") },
                minimumValueLabel: { Text("-3dB") },
                maximumValueLabel: { Text("40dB") }
            )
            .onDisappear { conductor.stop() }
            Button(
                action: { conductor.start() },
                label: { Text("Start") }
            )
        }
        .onChange(of: value) { newValue in
            conductor.setResonance(value: newValue)
            // conductor.setResonanceAUPreset(value: newValue)
        }
    }
}
