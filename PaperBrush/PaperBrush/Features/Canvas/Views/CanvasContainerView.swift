import SwiftUI
import PencilKit

// BRUSH-001: Canvas container — Screen 03
struct CanvasContainerView: View {
    @StateObject private var viewModel: CanvasViewModel
    @EnvironmentObject private var router: AppRouter

    init(pageId: String) {
        _viewModel = StateObject(wrappedValue: CanvasViewModel(pageId: pageId))
    }

    init(resumeArtworkId: UUID) {
        _viewModel = StateObject(wrappedValue: CanvasViewModel(resumeArtworkId: resumeArtworkId))
    }

    var body: some View {
        VStack(spacing: 0) {
            CanvasTopToolbarView(viewModel: viewModel)

            // Canvas area with overlays
            ZStack {
                // PencilKit canvas
                CanvasPencilKitView(
                    colorIndex: viewModel.selectedColorIndex,
                    brushTypeRaw: viewModel.currentBrushType.rawValue,
                    inkWidth: viewModel.currentBrushSize,
                    viewModel: viewModel,
                    canUndo: $viewModel.canUndo,
                    canRedo: $viewModel.canRedo,
                    canvasViewProvider: viewModel.canvasViewProvider,
                    isStampMode: viewModel.isStampMode
                )

                // Stamp overlay
                StampOverlayView(
                    stamps: viewModel.placedStamps,
                    isStampMode: viewModel.isStampMode,
                    isEraserMode: viewModel.isEraser,
                    onTap: { position in
                        viewModel.placeStamp(at: position)
                    },
                    onEraseStamp: { stampId in
                        viewModel.eraseStamp(id: stampId)
                    }
                )

                // Eraser cursor rendered as UIView inside PKCanvasView (UIKit, no lag)
            }
            .clipped()

            UndoRedoBarView(viewModel: viewModel)

            Rectangle()
                .fill(PBTokens.Colors.lightDivider)
                .frame(height: 1)

            BrushToolbarView(viewModel: viewModel)

            Rectangle()
                .fill(PBTokens.Colors.lightDivider)
                .frame(height: 1)

            ColorTrayView(viewModel: viewModel)
                .padding(.bottom, 4)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $viewModel.showStampPicker) {
            StampShapePickerView(
                selectedShape: $viewModel.selectedStampShape,
                isPresented: $viewModel.showStampPicker
            )
            .presentationDetents([.medium])
        }
        // GALLERY-003: Save toast overlay
        .overlay(alignment: .top) {
            if viewModel.showSaveToast {
                PBToast("Saved!", style: .success)
                    .padding(.top, PBTokens.Spacing.xxl)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(PBTokens.Animation.spring, value: viewModel.showSaveToast)
            }
        }
        // GALLERY-003: Auto-save timer + resume on appear
        .task {
            // Try to load saved canvas — either from explicit resume or by finding
            // an existing artwork for this pageId
            await viewModel.loadCanvasIfAvailable()
            // Start 30-second auto-save
            viewModel.startAutoSave()
        }
    }
}
