import Foundation

/// Protocol for all audio playback in PaperBrush.
/// Real implementation: AudioManager.shared. Tests inject mocks.
protocol AudioManagerProtocol {
    // Global state
    var isMuted: Bool { get set }
    var isSoundEffectsEnabled: Bool { get set }
    var isBackgroundMusicEnabled: Bool { get set }
    var musicVolume: Float { get set }

    // Sound effects
    func playBrushSound(_ brush: BrushType)
    func playUISound(_ sound: UISound)
    func playCelebrationSound(for category: ContentCategory)
    func playPassAndPlaySound(_ sound: PassAndPlaySound)

    // Music
    func startBackgroundMusic()
    func stopBackgroundMusic()
    func fadeOutMusic(duration: TimeInterval)
    func fadeInMusic(duration: TimeInterval)

    // AUDIO-002: Color selection pitch varies by hue position
    func playColorSelectTone(hue: CGFloat)
}

// MARK: - Sound Type Enums

enum UISound: String {
    case toolSwitch     = "sfx-ui-tool-switch"
    case colorSelect    = "sfx-ui-color-select"
    case pageOpen       = "sfx-ui-page-open"
    case galleryOpen    = "sfx-ui-gallery-open"
    case save           = "sfx-ui-save"
    case buttonTap      = "sfx-ui-button-tap"
    case sheetPresent   = "sfx-ui-sheet-present"
    case undo           = "sfx-ui-undo"
    case redo           = "sfx-ui-redo"
}

enum PassAndPlaySound: String {
    case countdownBeep  = "sfx-pnp-countdown-beep"
    case timesUp        = "sfx-pnp-times-up"
    case handoff        = "sfx-pnp-handoff"
}
