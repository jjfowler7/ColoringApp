import SwiftUI

// Canvas top toolbar — back button, title, mute toggle, overflow menu
struct CanvasTopToolbarView: View {
    @ObservedObject var viewModel: CanvasViewModel
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        HStack {
            // Back button
            Button {
                router.pop()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(PBTokens.Colors.richTeal)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("Back to content browser")

            Spacer()

            // Page title
            Text(viewModel.pageTitle)
                .font(PBTokens.Typography.nunitoSans(.semibold, size: 16))
                .foregroundColor(PBTokens.Colors.deepNavy)
                .lineLimit(1)

            Spacer()

            // Mute toggle
            Button {
                viewModel.toggleMute()
            } label: {
                Image(systemName: viewModel.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                    .font(.system(size: 18))
                    .foregroundColor(viewModel.isMuted ? PBTokens.Colors.softGraphite : PBTokens.Colors.richTeal)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel(viewModel.isMuted ? "Unmute" : "Mute")

            // Overflow menu — appears anchored to the button
            Menu {
                Button {
                    viewModel.saveToGallery()
                } label: {
                    Label("Save to Gallery", systemImage: "square.and.arrow.down")
                }
                Button {
                    // Sprint 3.4 — celebration
                } label: {
                    Label("Done!", systemImage: "checkmark.circle")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(PBTokens.Colors.softGraphite)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("More options")
        }
        .padding(.horizontal, PBTokens.Spacing.sm)
        .frame(height: 44)
        .background(PBTokens.Colors.softCanvas)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(PBTokens.Colors.lightDivider)
                .frame(height: 1)
        }
    }
}
