import SwiftUI

// BRUSH-004, BRUSH-005: Undo/redo buttons + brush size slider with preview
struct UndoRedoBarView: View {
    @ObservedObject var viewModel: CanvasViewModel

    var body: some View {
        HStack(spacing: PBTokens.Spacing.sm) {
            // Undo button
            Button {
                viewModel.undo()
            } label: {
                Image(systemName: "arrow.uturn.backward")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(viewModel.canUndo ? PBTokens.Colors.richTeal : PBTokens.Colors.lightDivider)
            }
            .disabled(!viewModel.canUndo)
            .frame(width: 44, height: 44)
            .accessibilityLabel("Undo")

            // Brush/eraser size preview circle
            brushSizePreview
                .frame(width: 44, height: 44)

            // Brush size slider with visible track
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(PBTokens.Colors.lightDivider)
                    .frame(height: 6)

                GeometryReader { geo in
                    let fraction = CGFloat((viewModel.currentBrushSize - 2) / (80 - 2))
                    Capsule()
                        .fill(sliderFillColor)
                        .frame(width: geo.size.width * fraction, height: 6)
                }
                .frame(height: 6)

                Slider(
                    value: $viewModel.currentBrushSize,
                    in: 2...80,
                    step: 1
                )
                .tint(.clear)
                .accessibilityLabel("Brush size: \(Int(viewModel.currentBrushSize)) points")
            }

            // Redo button
            Button {
                viewModel.redo()
            } label: {
                Image(systemName: "arrow.uturn.forward")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(viewModel.canRedo ? PBTokens.Colors.richTeal : PBTokens.Colors.lightDivider)
            }
            .disabled(!viewModel.canRedo)
            .frame(width: 44, height: 44)
            .accessibilityLabel("Redo")
        }
        .padding(.horizontal, PBTokens.Spacing.md)
        .padding(.vertical, PBTokens.Spacing.sm)
        .background(PBTokens.Colors.softCanvas)
    }

    // MARK: - Brush Size Preview Circle

    /// Shows a circle representing the current brush/eraser size, in the current color
    private var brushSizePreview: some View {
        let previewSize = min(viewModel.currentBrushSize, 36) // cap at 36pt to fit in 44pt frame
        let displayColor: Color = viewModel.isEraser
            ? Color.gray.opacity(0.5)
            : Color(viewModel.currentUIColor)

        return ZStack {
            Circle()
                .fill(displayColor)
                .frame(width: previewSize, height: previewSize)

            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                .frame(width: previewSize, height: previewSize)
        }
        .animation(PBTokens.Animation.quick, value: viewModel.currentBrushSize)
    }

    private var sliderFillColor: Color {
        viewModel.isEraser
            ? Color.gray
            : Color(viewModel.currentUIColor)
    }
}
