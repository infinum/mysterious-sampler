import Foundation
import AVFAudio

class FileLimitConductor {
    let url = Bundle.main.url(forResource: "Test Instrument", withExtension: "aupreset")!

    func start() {
        let samplers = (0...1000).map { _ in AVAudioUnitSampler() }
        samplers.forEach { try! $0.loadPreset(at: url) }
    }
}
