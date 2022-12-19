import AVFAudio

class OscillatorConductor: ObservableObject {
    let engine = AVAudioEngine()
    let oscillator = OscillatorConductor.oscillator()
    let distortion = AVAudioUnitDistortion()
    let equalizer = AVAudioUnitEQ(numberOfBands: 3)

    @Published private(set) var isStarted = false

    init() {
        engine.attach(oscillator)
        engine.attach(distortion)
        engine.connect(distortion, to: engine.mainMixerNode, format: nil)
        engine.connect(oscillator, to: distortion, format: nil)
        oscillator.volume = 0.1
    }

    func start() {
        isStarted = true
        try! engine.start()
    }

    func stop() {
        isStarted = false
        engine.stop()
    }

    func reconnectDynamically() {
        if distortion.engine != nil {
            engine.attach(equalizer)
            engine.connect(equalizer, to: engine.mainMixerNode, format: nil)
            engine.connect(oscillator, to: equalizer, format: nil)
            engine.detach(distortion)
        } else {
            engine.attach(distortion)
            engine.connect(distortion, to: engine.mainMixerNode, format: nil)
            engine.connect(oscillator, to: distortion, format: nil)
            engine.detach(equalizer)
        }
        print(engine)
    }
}

private extension OscillatorConductor {
    static func oscillator() -> AVAudioSourceNode {
        let twoPi = 2 * Float.pi
        let phaseIncrement = (twoPi / 44100) * 440
        var currentPhase: Float = 0

        return AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            for frame in 0..<Int(frameCount) {
                let value = sin(currentPhase)
                currentPhase += phaseIncrement
                if currentPhase >= twoPi {
                    currentPhase -= twoPi
                }
                if currentPhase < 0.0 {
                    currentPhase += twoPi
                }
                for buffer in ablPointer {
                    let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                    buf[frame] = value
                }
            }
            return noErr
        }
    }
}
