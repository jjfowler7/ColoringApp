import SwiftUI
import UIKit

// GALLERY-001: Gallery card — shows saved artwork thumbnail with title/date overlay
struct GalleryArtworkCard: View {
    let artwork: Artwork
    let thumbnail: UIImage?
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .topLeading) {
                // Rounded card background + clipped thumbnail content
                RoundedRectangle(cornerRadius: PBTokens.CornerRadius.md)
                    .fill(PBTokens.Colors.softCanvas)
                    .overlay {
                        thumbnailView
                            .clipped()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: PBTokens.CornerRadius.md))
                    // Bottom gradient overlay sits inside the clip
                    .overlay(alignment: .bottom) {
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: .clear, location: 0),
                                .init(
                                    color: Color(red: 0.106, green: 0.165, blue: 0.290).opacity(0.78),
                                    location: 1
                                )
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 72)
                        .overlay(alignment: .bottomLeading) {
                            VStack(alignment: .leading, spacing: 1) {
                                Text(artwork.title)
                                    .font(PBTokens.Typography.nunito(.semibold, size: 12))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                Text(relativeDate)
                                    .font(PBTokens.Typography.nunitoSans(.regular, size: 10))
                                    .foregroundColor(.white.opacity(0.70))
                            }
                            .padding(.horizontal, 10)
                            .padding(.bottom, 9)
                        }
                    }

                // Tier dot — top-left, 9pt inset — outside clip so shadow renders cleanly
                Circle()
                    .fill(PBTokens.Colors.tierAccent(artwork.tier))
                    .frame(width: 9, height: 9)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1)
                    .padding(9)

                // CONTINUE badge — top-right, outside clip so it's never cut off
                if !artwork.isCompleted {
                    HStack {
                        Spacer()
                        Text("CONTINUE")
                            .font(PBTokens.Typography.nunito(.bold, size: 9))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(PBTokens.Colors.richTeal)
                            .clipShape(Capsule())
                            .shadow(
                                color: PBTokens.Colors.richTeal.opacity(0.4),
                                radius: 4, x: 0, y: 1
                            )
                    }
                    .padding(8)
                }
            }
        }
        .buttonStyle(GalleryCardPressStyle())
        .frame(height: 220)
        .pbShadow(PBTokens.Shadows.level1)
        .accessibilityLabel(accessibilityDescription)
    }

    // MARK: - Thumbnail

    @ViewBuilder
    private var thumbnailView: some View {
        if let image = thumbnail {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ZStack {
                PBTokens.Colors.warmCream
                Image(systemName: "photo")
                    .font(.system(size: 32))
                    .foregroundColor(PBTokens.Colors.lightDivider)
            }
        }
    }

    // MARK: - Helpers

    private var relativeDate: String {
        let calendar = Calendar.current
        let now = Date()
        if calendar.isDateInToday(artwork.lastModified) {
            return "Today"
        } else if calendar.isDateInYesterday(artwork.lastModified) {
            return "Yesterday"
        } else if let days = calendar.dateComponents([.day], from: artwork.lastModified, to: now).day,
                  days < 7 {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE"
            return formatter.string(from: artwork.lastModified)
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter.string(from: artwork.lastModified)
        }
    }

    private var accessibilityDescription: String {
        let status = artwork.isCompleted ? "Completed" : "In progress"
        return "\(artwork.title), \(status), \(relativeDate)"
    }
}

private struct GalleryCardPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.18, dampingFraction: 0.7), value: configuration.isPressed)
    }
}
