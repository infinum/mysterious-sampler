import SwiftUI
import Combine

struct VoiceCountView: View {
    let conductor = VoiceCountConductor()

    @State private var active: Int = 0

    private var activeVoiceCount: AnyPublisher<Int, Never> {
        Timer.publish(every: 0.2, on: .main, in: .default)
            .autoconnect()
            .map { [conductor] _ in conductor.activeVoiceCount() }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    var body: some View {
        VStack {
            Button(
                action: { conductor.startNote() },
                label: { Text("Note on") }
            )
            Button(
                action: { conductor.stopNote() },
                label: { Text("Note off") }
            )
            Text("Active voice count: \(active)")
        }
        .onReceive(activeVoiceCount) { active = $0 }
    }
}
