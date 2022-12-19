import AVFAudio

class SamplerConductor: ObservableObject {
    let engine = AVAudioEngine()
    let sampler = AVAudioUnitSampler()
    let distortion = AVAudioUnitDistortion()
    let equalizer = AVAudioUnitEQ()

    @Published private(set) var isStarted = false

    init() {
        let url = Bundle.main.url(forResource: "Test Instrument", withExtension: "aupreset")!
        try! sampler.loadPreset(at: url)
        engine.attach(sampler)
        engine.attach(distortion)
        engine.connect(sampler, to: distortion, format: nil)
        engine.connect(distortion, to: engine.mainMixerNode, format: nil)
        sampler.volume = 0.1
        try! engine.start()
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

    func reconnectDynamically() {
        if distortion.engine != nil {
            engine.attach(equalizer)
            engine.connect(equalizer, to: engine.mainMixerNode, format: nil)
            engine.connect(sampler, to: equalizer, format: nil)
            engine.detach(distortion)
        } else {
            engine.attach(distortion)
            engine.connect(distortion, to: engine.mainMixerNode, format: nil)
            engine.connect(sampler, to: distortion, format: nil)
            engine.detach(equalizer)
        }
        print(engine)
    }
}
