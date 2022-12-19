import SwiftUI

@main
struct MysteriousSamplerApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                List {
                    Section() {
                        NavigationLink("File limit") { FileLimitView() }
                    }
                    Section() {
                        NavigationLink("Oscillator") { OscillatorView() }
                        NavigationLink("Sampler") { SamplerView() }
                        NavigationLink("Sampler works") { SamplerWorksView() }
                    }
                }
            }
        }
    }
}
