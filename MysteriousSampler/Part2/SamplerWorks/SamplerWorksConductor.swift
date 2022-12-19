import AVFAudio

class SamplerWorksConductor: ObservableObject {
    let engine = AVAudioEngine()
    let sampler = AVAudioUnitSampler()
    let distortion = AVAudioUnitDistortion()
    let staticDistortion = AVAudioUnitDistortion()
    let staticDistortion2 = AVAudioUnitDistortion()
    let equalizer = AVAudioUnitEQ()

    @Published private(set) var isStarted = false

    init() {
        engine.attach(sampler)
        engine.attach(staticDistortion)
        engine.attach(staticDistortion2)
        engine.attach(distortion)

        // This creates internal multi splitter
        // We need two static nodes for multisplitter to work correctly
        // when dynamically adding removing nodes.
        engine.connect(
            sampler,
            to: [
                AVAudioConnectionPoint(node: staticDistortion, bus: 0),
                AVAudioConnectionPoint(node: staticDistortion2, bus: 0),
                AVAudioConnectionPoint(node: distortion, bus: 0),
            ],
            fromBus: 0,
            format: nil
        )
        engine.connect(distortion, to: engine.mainMixerNode, format: nil)
        engine.connect(staticDistortion, to: engine.mainMixerNode, format: nil)
        engine.connect(staticDistortion2, to: engine.mainMixerNode, format: nil)
        sampler.volume = 0.1
        print(engine)
    }

    func start() {
        isStarted = true
        try! engine.start()
        sampler.startNote(100, withVelocity: 127, onChannel: 0)
        sampler.sendController(64, withValue: 127, onChannel: 0)
    }

    func stop() {
        isStarted = false
        engine.stop()
    }

    func reconnectDynamically() {
        let node: AVAudioNode
        let previous: AVAudioNode
        if distortion.engine != nil {
            engine.attach(equalizer)
            node = equalizer
            previous = distortion
        } else {
            engine.attach(distortion)
            node = distortion
            previous = equalizer
        }

        // We now can detach the effect that we don't need and chain is in a good state
        engine.disconnectNodeOutput(previous)
        engine.detach(previous)
        print(engine)
        engine.connect(node, to: engine.mainMixerNode, format: nil)

        // This doesn't work
        // engine.connect(sampler, to: node, format: nil)

        // This has to be done this way. If we only connect to reverb2 and mainMixerNode, it will cleanup the sampler
        engine.connect(
            sampler,
            to: [
                AVAudioConnectionPoint(node: staticDistortion, bus: 0),
                AVAudioConnectionPoint(node: staticDistortion2, bus: 0),
                AVAudioConnectionPoint(node: node, bus: 0),
            ],
            fromBus: 0,
            format: nil
        )

        print(engine)
    }
}
