import SwiftUI

struct SamplerWorksView: View {
    @StateObject var conductor = SamplerWorksConductor()

    var body: some View {
        if conductor.isStarted {
            Button(
                action: { conductor.reconnectDynamically() },
                label: { Text("Reconnect dynamically") }
            )
            .onDisappear { conductor.stop() }
        } else {
            Button(
                action: { conductor.start() },
                label: { Text("Start") }
            )
        }
    }
}
