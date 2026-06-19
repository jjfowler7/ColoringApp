import Foundation

// FAMILY-001: Player model for Pass & Play mode
struct Player: Identifiable, Hashable {
    let id: UUID
    var name: String
    var avatarName: String   // e.g., "avatar-bear", "avatar-cat"
    var turnDuration: Int    // seconds: 30, 60, or 90

    init(id: UUID = UUID(), name: String = "", avatarName: String = "avatar-bear", turnDuration: Int = 60) {
        self.id = id
        self.name = name
        self.avatarName = avatarName
        self.turnDuration = turnDuration
    }

    static let avatarOptions = [
        "avatar-bear", "avatar-cat", "avatar-owl", "avatar-fox",
        "avatar-rabbit", "avatar-penguin", "avatar-lion", "avatar-frog"
    ]
}
