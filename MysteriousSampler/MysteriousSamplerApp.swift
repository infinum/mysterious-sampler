import SwiftUI

@main
struct MysteriousSamplerApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                List {
                    Section() {
                        NavigationLink("Voice count") { VoiceCountView() }
                    }
                    Section() {
                        NavigationLink("Oscillator") { OscillatorView() }
                        NavigationLink("Sampler") { SamplerView() }
                        NavigationLink("Sampler works") { SamplerWorksView() }
                    }
                    Section() {
                        NavigationLink("Resonance control") { ResonanceControlView() }
                    }
                }
            }
        }
    }
}
