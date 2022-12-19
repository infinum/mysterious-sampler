import SwiftUI

struct FileLimitView: View {
    let conductor = FileLimitConductor()

    var body: some View {
        VStack {
            Button(
                action: { conductor.start() },
                label: { Text("Start") }
            )
        }
    }
}
