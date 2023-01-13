import AVFAudio

class VoiceCountConductor {
    let engine = AVAudioEngine()
    let sampler = AVAudioUnitSampler()

    init() {
        let preset = Bundle.main.url(
            forResource: "Test Instrument",
            withExtension: "aupreset"
        )!
        engine.attach(sampler)
        engine.connect(sampler, to: engine.outputNode, format: nil)

        try! sampler.loadPreset(at: preset)
        try! engine.start()

    }

    func startNote() {
        sampler.startNote(100, withVelocity: 127, onChannel: 0)
    }

    func stopNote() {
        sampler.stopNote(100, onChannel: 0)
    }

    func activeVoiceCount() -> Int {
        Int(self.sampler.activeVoiceCount())
    }
}

extension AVAudioUnit {
    func activeVoiceCount() -> UInt32 {
        var current: UInt32 = 0
        var currentSize: UInt32 = UInt32(MemoryLayout<UInt32>.size)
        AudioUnitGetProperty(
            self.audioUnit,
            4104,
            kAudioUnitScope_Global,
            0,
            &current,
            &currentSize
        )
        return current
    }
}
