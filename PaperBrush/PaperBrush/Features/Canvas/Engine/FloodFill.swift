import UIKit

// BRUSH-002: Scanline flood fill algorithm
// Fills connected pixels of similar color starting from a seed point.
// Uses scanline approach for efficiency — processes entire horizontal spans at once.
enum FloodFill {

    /// Fill a region in the image starting from the seed point with the given color.
    /// - Parameters:
    ///   - image: The source image to fill
    ///   - seedPoint: The starting point (in image coordinates)
    ///   - fillColor: The color to fill with
    ///   - tolerance: How similar a pixel must be to the seed color to be filled (0–255)
    /// - Returns: A new image with the fill applied, or nil if the fill failed
    static func fill(
        image: UIImage,
        seedPoint: CGPoint,
        fillColor: UIColor,
        tolerance: Int = 32
    ) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }

        let width = cgImage.width
        let height = cgImage.height
        let x = Int(seedPoint.x)
        let y = Int(seedPoint.y)

        guard x >= 0, x < width, y >= 0, y < height else { return nil }

        // Create a bitmap context to work with pixel data
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let bitsPerComponent = 8
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue

        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else { return nil }

        // Draw the original image into the context
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        guard let pixelData = context.data else { return nil }
        let pixels = pixelData.bindMemory(to: UInt8.self, capacity: width * height * bytesPerPixel)

        // Get the seed color
        let seedIdx = (y * width + x) * bytesPerPixel
        let seedR = pixels[seedIdx]
        let seedG = pixels[seedIdx + 1]
        let seedB = pixels[seedIdx + 2]
        let seedA = pixels[seedIdx + 3]

        // Get the fill color components
        var fillR: CGFloat = 0, fillG: CGFloat = 0, fillB: CGFloat = 0, fillA: CGFloat = 0
        fillColor.getRed(&fillR, green: &fillG, blue: &fillB, alpha: &fillA)
        let fR = UInt8(min(255, max(0, Int(fillR * 255))))
        let fG = UInt8(min(255, max(0, Int(fillG * 255))))
        let fB = UInt8(min(255, max(0, Int(fillB * 255))))
        let fA = UInt8(min(255, max(0, Int(fillA * 255))))

        // Don't fill if seed color is already the fill color
        if abs(Int(seedR) - Int(fR)) < tolerance &&
           abs(Int(seedG) - Int(fG)) < tolerance &&
           abs(Int(seedB) - Int(fB)) < tolerance {
            return image
        }

        // Visited array
        var visited = [Bool](repeating: false, count: width * height)

        // Scanline flood fill using a stack
        var stack: [(Int, Int)] = [(x, y)]
        let tol = tolerance

        while let (cx, cy) = stack.popLast() {
            guard cx >= 0, cx < width, cy >= 0, cy < height else { continue }

            let idx = cy * width + cx
            guard !visited[idx] else { continue }

            let pIdx = idx * bytesPerPixel
            let pR = pixels[pIdx]
            let pG = pixels[pIdx + 1]
            let pB = pixels[pIdx + 2]
            let pA = pixels[pIdx + 3]

            // Check if this pixel is similar enough to the seed color
            guard abs(Int(pR) - Int(seedR)) <= tol &&
                  abs(Int(pG) - Int(seedG)) <= tol &&
                  abs(Int(pB) - Int(seedB)) <= tol &&
                  abs(Int(pA) - Int(seedA)) <= tol else { continue }

            visited[idx] = true

            // Fill this pixel
            pixels[pIdx] = fR
            pixels[pIdx + 1] = fG
            pixels[pIdx + 2] = fB
            pixels[pIdx + 3] = fA

            // Scanline: expand left and right from this pixel
            // Then push the row above and below

            // Expand left
            var leftX = cx - 1
            while leftX >= 0 {
                let li = cy * width + leftX
                if visited[li] { break }
                let lp = li * bytesPerPixel
                if abs(Int(pixels[lp]) - Int(seedR)) > tol ||
                   abs(Int(pixels[lp+1]) - Int(seedG)) > tol ||
                   abs(Int(pixels[lp+2]) - Int(seedB)) > tol ||
                   abs(Int(pixels[lp+3]) - Int(seedA)) > tol { break }
                visited[li] = true
                pixels[lp] = fR; pixels[lp+1] = fG; pixels[lp+2] = fB; pixels[lp+3] = fA
                leftX -= 1
            }
            leftX += 1

            // Expand right
            var rightX = cx + 1
            while rightX < width {
                let ri = cy * width + rightX
                if visited[ri] { break }
                let rp = ri * bytesPerPixel
                if abs(Int(pixels[rp]) - Int(seedR)) > tol ||
                   abs(Int(pixels[rp+1]) - Int(seedG)) > tol ||
                   abs(Int(pixels[rp+2]) - Int(seedB)) > tol ||
                   abs(Int(pixels[rp+3]) - Int(seedA)) > tol { break }
                visited[ri] = true
                pixels[rp] = fR; pixels[rp+1] = fG; pixels[rp+2] = fB; pixels[rp+3] = fA
                rightX += 1
            }
            rightX -= 1

            // Push rows above and below for the filled span
            for sx in leftX...rightX {
                if cy > 0 { stack.append((sx, cy - 1)) }
                if cy < height - 1 { stack.append((sx, cy + 1)) }
            }
        }

        // Create new image from modified pixel data
        guard let newCGImage = context.makeImage() else { return nil }
        return UIImage(cgImage: newCGImage, scale: image.scale, orientation: image.imageOrientation)
    }
}
