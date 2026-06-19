import Foundation

/// Wrapper around UserDefaults for all app preferences.
/// All UserDefaults access must go through this class — never read/write directly.
final class UserPreferences {
    static let shared = UserPreferences()
    private let defaults = UserDefaults.standard

    // MARK: - Keys
    private enum Key: String {
        case selectedTier
        case hasCompletedOnboarding
        case artistName
        case isSoundEffectsEnabled
        case isBackgroundMusicEnabled
        case musicVolume
        case isWatermarkEnabled
        case isMuted
        case recentCustomColors
        case brushSizes
        case notifyForNewPacks
        case lastUsedPageId
        case inProgressArtworkId
    }

    // MARK: - Profile

    var selectedTier: AgeTier {
        get { AgeTier(rawValue: defaults.string(forKey: Key.selectedTier.rawValue) ?? "") ?? .explorer }
        set { defaults.set(newValue.rawValue, forKey: Key.selectedTier.rawValue) }
    }

    var hasCompletedOnboarding: Bool {
        get { defaults.bool(forKey: Key.hasCompletedOnboarding.rawValue) }
        set { defaults.set(newValue, forKey: Key.hasCompletedOnboarding.rawValue) }
    }

    var artistName: String {
        get { defaults.string(forKey: Key.artistName.rawValue) ?? "" }
        set { defaults.set(newValue, forKey: Key.artistName.rawValue) }
    }

    // MARK: - Audio (AUDIO-001, AUDIO-002, AUDIO-003)

    var isMuted: Bool {
        get { defaults.bool(forKey: Key.isMuted.rawValue) }
        set { defaults.set(newValue, forKey: Key.isMuted.rawValue) }
    }

    var isSoundEffectsEnabled: Bool {
        get { defaults.object(forKey: Key.isSoundEffectsEnabled.rawValue) as? Bool ?? true }
        set { defaults.set(newValue, forKey: Key.isSoundEffectsEnabled.rawValue) }
    }

    var isBackgroundMusicEnabled: Bool {
        get { defaults.object(forKey: Key.isBackgroundMusicEnabled.rawValue) as? Bool ?? true }
        set { defaults.set(newValue, forKey: Key.isBackgroundMusicEnabled.rawValue) }
    }

    var musicVolume: Float {
        get { defaults.object(forKey: Key.musicVolume.rawValue) as? Float ?? 0.7 }
        set { defaults.set(newValue, forKey: Key.musicVolume.rawValue) }
    }

    // MARK: - Display

    var isWatermarkEnabled: Bool {
        get { defaults.bool(forKey: Key.isWatermarkEnabled.rawValue) }
        set { defaults.set(newValue, forKey: Key.isWatermarkEnabled.rawValue) }
    }

    // MARK: - Color Picker

    var recentCustomColors: [String] {
        get { defaults.stringArray(forKey: Key.recentCustomColors.rawValue) ?? [] }
        set {
            let trimmed = Array(newValue.prefix(20))
            defaults.set(trimmed, forKey: Key.recentCustomColors.rawValue)
        }
    }

    // MARK: - Brush Sizes (BRUSH-004: persists per brush type)

    func brushSize(for brush: BrushType) -> CGFloat {
        let dict = defaults.dictionary(forKey: Key.brushSizes.rawValue) as? [String: Double] ?? [:]
        if let size = dict[brush.rawValue] {
            return CGFloat(size)
        }
        return brush.defaultSize
    }

    func setBrushSize(_ size: CGFloat, for brush: BrushType) {
        var dict = defaults.dictionary(forKey: Key.brushSizes.rawValue) as? [String: Double] ?? [:]
        dict[brush.rawValue] = Double(size)
        defaults.set(dict, forKey: Key.brushSizes.rawValue)
    }

    // MARK: - Session Resume

    var lastUsedPageId: String? {
        get { defaults.string(forKey: Key.lastUsedPageId.rawValue) }
        set { defaults.set(newValue, forKey: Key.lastUsedPageId.rawValue) }
    }

    var inProgressArtworkId: UUID? {
        get {
            guard let string = defaults.string(forKey: Key.inProgressArtworkId.rawValue) else { return nil }
            return UUID(uuidString: string)
        }
        set { defaults.set(newValue?.uuidString, forKey: Key.inProgressArtworkId.rawValue) }
    }

    // MARK: - Pack Store

    var notifyForNewPacks: Bool {
        get { defaults.bool(forKey: Key.notifyForNewPacks.rawValue) }
        set { defaults.set(newValue, forKey: Key.notifyForNewPacks.rawValue) }
    }
}
