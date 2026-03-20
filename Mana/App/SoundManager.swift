import AVFoundation
import AppKit

class SoundManager: ObservableObject {
    static let shared = SoundManager()

    private var loopSound: NSSound?
    private var oneShots: [AVAudioPlayer] = []

    @Published var isMuted: Bool {
        didSet { UserDefaults.standard.set(isMuted, forKey: "soundMuted") }
    }
    @Published var volume: Float {
        didSet { UserDefaults.standard.set(volume, forKey: "soundVolume") }
    }

    private init() {
        isMuted = UserDefaults.standard.bool(forKey: "soundMuted")
        let stored = UserDefaults.standard.float(forKey: "soundVolume")
        volume = stored > 0 ? stored : 1.0
    }

    func play(_ name: String, loop: Bool = false) {
        guard !isMuted else { return }
        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else {
            NSLog("[SoundManager] Missing sound: \(name)")
            return
        }
        if loop {
            stopLoop()
            guard let sound = NSSound(contentsOf: url, byReference: false) else {
                NSLog("[SoundManager] NSSound failed to load: \(name)")
                return
            }
            sound.loops = true
            sound.volume = volume
            let ok = sound.play()
            NSLog("[SoundManager] loop play(\(name)) started=\(ok)")
            loopSound = sound
        } else {
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.volume = volume
                let ok = player.play()
                NSLog("[SoundManager] one-shot play(\(name)) started=\(ok)")
                oneShots.append(player)
                oneShots.removeAll { !$0.isPlaying && $0 !== player }
            } catch {
                NSLog("[SoundManager] one-shot player error for \(name): \(error)")
            }
        }
    }

    func stopLoop() {
        loopSound?.stop()
        loopSound = nil
    }

    func onStateChange(to state: CompanionState) {
        switch state {
        case .working:
            let taskStartSounds = [
                "ok.wav",
                "okie-dokie-1.mp3",
                "okie-dokie-2.mp3",
                "hmm-whatever.mp3",
                "hmmm.mp3",
                "hmm-ok-2.mp3",
                "hmm-ok-1.mp3",
            ]
            play(taskStartSounds.randomElement()!)
        case .needsInput:
            stopLoop()
            play("hmmm.mp3")
        case .success:
            stopLoop()
            let finishedSounds = [
                "all-done.mp3",
                "there-you-go.mp3",
                "finished.mp3",
            ]
            play(finishedSounds.randomElement()!)
        case .idle, .spinning:
            stopLoop()
        }
    }

    func onTap() {
        play("giggle.mp3")
    }
}
