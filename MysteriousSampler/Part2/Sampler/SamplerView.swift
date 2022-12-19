import SwiftUI

struct SamplerView: View {
    @StateObject var conductor = SamplerConductor()

    var body: some View {
        VStack {
            Button(
                action: { conductor.reconnectDynamically() },
                label: { Text("Reconnect dynamically") }
            )
            .onDisappear { conductor.stop() }
            Button(
                action: { conductor.start() },
                label: { Text("Start") }
            )
        }
    }
}
