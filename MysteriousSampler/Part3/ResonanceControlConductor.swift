import AVFAudio

class ResonanceControlConductor: ObservableObject {
    let engine = AVAudioEngine()
    let sampler = AVAudioUnitSampler()

    @Published private(set) var isStarted = false

    init() {
        engine.attach(sampler)
        engine.connect(sampler, to: engine.mainMixerNode, format: nil)
        sampler.volume = 1
        try! engine.start()
        sampler.unbypassFilter()
    }

    func start() {
        isStarted = true
        sampler.startNote(100, withVelocity: 127, onChannel: 0)
        sampler.sendController(64, withValue: 127, onChannel: 0)
    }

    func stop() {
        isStarted = false
        engine.stop()
    }

    func setResonance(value: Float) {
        sampler.setResonance(value: value)
    }

    func setResonanceAUPreset(value: Float) {
        sampler.setResonanceAUPreset(value: value)
    }
}

extension AVAudioUnit {
    func setResonance(value: Float) {
         let instrument = auAudioUnit.fullState?["Instrument"] as? NSDictionary
         guard let layers = instrument?["Layers"] as? NSArray else { return }
         for layerIndex in 0..<UInt32(layers.count) {
             var value = value
             AudioUnitSetProperty(
                 self.audioUnit,
                 4162,
                 kAudioUnitScope_LayerItem,
                 0x40000000 + (0x100 * layerIndex),
                 &value,
                 UInt32(MemoryLayout<Float>.size)
             )
         }
     }

    func setResonanceAUPreset(value: Float) {
        let instrument = auAudioUnit.fullState!["Instrument"] as! NSDictionary
        let layers = instrument["Layers"] as! NSArray
        let layer = layers.firstObject as! NSDictionary
        let filters = layer["Filters"] as! NSDictionary
        filters.setValue(value, forKeyPath: "resonance")
        auAudioUnit.fullState?["Instrument"] = instrument
    }

    func unbypassFilter() {
        let instrument = auAudioUnit.fullState!["Instrument"] as! NSDictionary
        let layers = instrument["Layers"] as! NSArray
        let layer = layers.firstObject as! NSDictionary
        let filters = layer["Filters"] as! NSDictionary
        filters.setValue(true, forKeyPath: "enabled")
        auAudioUnit.fullState?["Instrument"] = instrument
    }
}
