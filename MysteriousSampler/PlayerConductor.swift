import AVFAudio

class PlayerConductor {
    let file = try! AVAudioFile(forReading: Bundle.main.url(forResource: "file", withExtension: "mp3")!)
    let engine = AVAudioEngine()
    let player = AVAudioPlayerNode()
    let distortion = AVAudioUnitDistortion()

    init() {
        engine.attach(player)
        engine.attach(distortion)


        // This creates internal multi splitter
        engine.connect(
            player,
            to: [
                AVAudioConnectionPoint(node: distortion, bus: 0),
                AVAudioConnectionPoint(node: engine.mainMixerNode, bus: 0),
            ],
            fromBus: 0,
            format: nil
        )
        engine.connect(distortion, to: engine.mainMixerNode, format: nil)

/*
        engine.connect(distortion, to: engine.mainMixerNode, format: nil)
        engine.connect(player, to: distortion, format: nil)
*/



        player.scheduleFile(file, at: nil)
        player.scheduleFile(file, at: nil)
        player.scheduleFile(file, at: nil)
        try! engine.start()
        player.play()
    }

    func reconnectDynamically1() {
        engine.connect(player, to: engine.mainMixerNode, format: nil)
        engine.detach(distortion)
        print(player.isPlaying)
    }

    func reconnectDynamically() {
        let reverb2 = AVAudioUnitReverb()
        engine.attach(reverb2)

        // This has to be done this way. If we only connect to reverb2 and mainMixerNode, it will cleanup the sampler
        engine.connect(
            player,
            to: [
                AVAudioConnectionPoint(node: distortion, bus: 0),
                AVAudioConnectionPoint(node: engine.mainMixerNode, bus: 0),
                AVAudioConnectionPoint(node: reverb2, bus: 0),
            ],
            fromBus: 0,
            format: nil
        )

        engine.connect(reverb2, to: engine.mainMixerNode, format: nil)

        // We now can detach the effect that we don't need and chain is in a good state
        engine.disconnectNodeOutput(distortion)
        engine.detach(distortion)
        print(engine)
    }
}
