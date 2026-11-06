// Cache the frosted backdrop once; WezTerm's macOS blur only affects content
// behind the window, not an image rendered inside the terminal.
import Accelerate
import CoreGraphics
import Foundation
import ImageIO

let root = FileManager.default.homeDirectoryForCurrentUser
    .appendingPathComponent(".config/wezterm/assets", isDirectory: true)
let source = root.appendingPathComponent("desktop-wallpaper.png")
let destination = root.appendingPathComponent("desktop-wallpaper-blurred.png")
guard let imageSource = CGImageSourceCreateWithURL(source as CFURL, nil),
      let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
    fatalError("Cannot read desktop-wallpaper.png")
}
let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
let rowBytes = image.width * 4
let byteCount = rowBytes * image.height
let pixelsA = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: 64)
let pixelsB = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: 64)
defer { pixelsA.deallocate(); pixelsB.deallocate() }
let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
guard let inputContext = CGContext(
    data: pixelsA, width: image.width, height: image.height,
    bitsPerComponent: 8, bytesPerRow: rowBytes, space: colorSpace,
    bitmapInfo: bitmapInfo
) else { fatalError("Cannot allocate wallpaper renderer") }
inputContext.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
var input = vImage_Buffer(
    data: pixelsA, height: vImagePixelCount(image.height),
    width: vImagePixelCount(image.width), rowBytes: rowBytes
)
var output = vImage_Buffer(
    data: pixelsB, height: vImagePixelCount(image.height),
    width: vImagePixelCount(image.width), rowBytes: rowBytes
)
// Three box passes approximate a Gaussian blur with sigma 40 pixels.
// CPU rendering also works without a graphical desktop or GPU access.
for kernel: UInt32 in [79, 79, 81] {
    let error = vImageBoxConvolve_ARGB8888(
        &input, &output, nil, 0, 0, kernel, kernel, nil, vImage_Flags(kvImageEdgeExtend)
    )
    guard error == kvImageNoError else { fatalError("Wallpaper blur failed: \(error)") }
    swap(&input, &output)
}
guard let outputContext = CGContext(
    data: input.data, width: image.width, height: image.height,
    bitsPerComponent: 8, bytesPerRow: rowBytes, space: colorSpace,
    bitmapInfo: bitmapInfo
), let blurred = outputContext.makeImage(),
let writer = CGImageDestinationCreateWithURL(destination as CFURL, "public.png" as CFString, 1, nil)
else { fatalError("Cannot write frosted wallpaper") }
CGImageDestinationAddImage(writer, blurred, nil)
guard CGImageDestinationFinalize(writer) else { fatalError("Cannot save frosted wallpaper") }
print("Rendered frosted wallpaper: \(destination.path)")
