import Foundation

/// Centralized error types for PaperBrush.
/// Errors surface as toasts, inline text, or alerts — never crashes.
enum AppError: LocalizedError {
    // Canvas
    case canvasRenderingFailed
    case strokeDataCorrupted

    // Persistence
    case artworkSaveFailed
    case artworkLoadFailed
    case galleryCorrupted

    // Purchase
    case purchaseFailed(underlying: Error)
    case restoreFailed(underlying: Error)
    case noProductsFound

    // Content
    case contentPackDownloadFailed
    case pageDataCorrupted

    // Export
    case pdfGenerationFailed
    case photoLibraryPermissionDenied

    var errorDescription: String? {
        switch self {
        case .canvasRenderingFailed:
            return "Something went wrong with the canvas. Try again."
        case .strokeDataCorrupted:
            return "This artwork's data is damaged."
        case .artworkSaveFailed:
            return "Couldn't save — check storage or permissions"
        case .artworkLoadFailed:
            return "Couldn't load this artwork."
        case .galleryCorrupted:
            return "Gallery data is damaged. Try restarting the app."
        case .purchaseFailed:
            return "Something went wrong. Please try again."
        case .restoreFailed:
            return "Couldn't restore purchases. Check your connection and try again."
        case .noProductsFound:
            return "No products available right now."
        case .contentPackDownloadFailed:
            return "Download failed. Check your connection and try again."
        case .pageDataCorrupted:
            return "This page's data is damaged."
        case .pdfGenerationFailed:
            return "Couldn't create the PDF. Try again."
        case .photoLibraryPermissionDenied:
            return "Couldn't save — check storage or permissions"
        }
    }
}
