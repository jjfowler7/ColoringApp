import SwiftUI
import PencilKit

// BRUSH-001: PencilKit canvas wrapper for high-quality brush drawing
struct CanvasPencilKitView: UIViewRepresentable {
    let colorIndex: Int
    let brushTypeRaw: String
    let inkWidth: CGFloat
    let viewModel: CanvasViewModel
    @Binding var canUndo: Bool
    @Binding var canRedo: Bool
    let canvasViewProvider: CanvasViewProvider
    let isStampMode: Bool

    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = .white
        canvasView.isOpaque = true
        canvasView.delegate = context.coordinator
        canvasView.tool = buildTool()
        canvasViewProvider.canvasView = canvasView
        return canvasView
    }

    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        canvasView.tool = buildTool()
        canvasView.isUserInteractionEnabled = !isStampMode
    }

    private func buildTool() -> PKTool {
        if viewModel.isEraser {
            return PKEraserTool(.bitmap, width: viewModel.currentBrushSize)
        }
        return PKInkingTool(viewModel.pkInkType, color: viewModel.uiColor, width: viewModel.currentBrushSize)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(canUndo: $canUndo, canRedo: $canRedo)
    }

    final class Coordinator: NSObject, PKCanvasViewDelegate {
        @Binding var canUndo: Bool
        @Binding var canRedo: Bool

        init(canUndo: Binding<Bool>, canRedo: Binding<Bool>) {
            _canUndo = canUndo
            _canRedo = canRedo
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            Task { @MainActor in
                canUndo = canvasView.undoManager?.canUndo ?? false
                canRedo = canvasView.undoManager?.canRedo ?? false
            }
        }
    }
}

// MARK: - Shared reference for undo/redo access

final class CanvasViewProvider {
    weak var canvasView: PKCanvasView?

    func undo() {
        canvasView?.undoManager?.undo()
    }

    func redo() {
        canvasView?.undoManager?.redo()
    }

    // MARK: - Canvas Data Access (GALLERY-003)

    /// Returns the PKDrawing serialized as Data for persistence
    func getDrawingData() -> Data? {
        canvasView?.drawing.dataRepresentation()
    }

    /// Restores a PKDrawing from previously saved Data
    func setDrawing(from data: Data) {
        guard let drawing = try? PKDrawing(data: data) else { return }
        canvasView?.drawing = drawing
    }

    /// Generates a thumbnail image of the current drawing at the given size
    func generateThumbnail(size: CGSize = CGSize(width: 256, height: 256)) -> UIImage? {
        guard let canvasView else { return nil }
        let drawing = canvasView.drawing
        // Get the bounds of all strokes, or use a default rect if empty
        let bounds = drawing.bounds.isEmpty
            ? CGRect(origin: .zero, size: canvasView.bounds.size)
            : drawing.bounds
        // Render the drawing to an image
        let scale = min(size.width / bounds.width, size.height / bounds.height)
        return drawing.image(from: bounds, scale: scale)
    }
}
