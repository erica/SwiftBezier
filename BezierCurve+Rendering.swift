#if os(OSX)
    import Cocoa
#else
    import UIKit
#endif

#if os(OSX)
    fileprivate func drawImage(to targetSize: CGSize, _ block: () -> Void) -> Image? {
        guard let representation = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(targetSize.width),
            pixelsHigh: Int(targetSize.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: NSCalibratedRGBColorSpace,
            bytesPerRow: 0,
            bitsPerPixel: 0) else { return nil }
        representation.size = targetSize
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.setCurrent(NSGraphicsContext(bitmapImageRep: representation))
        block()
        NSGraphicsContext.restoreGraphicsState()
        guard let data = representation.representation(using: .PNG, properties: [:]) else { return nil }
        guard let image = NSImage(data: data) else { return nil }
        return image
    }
#else
    
    /// Draw into an image
    fileprivate func drawImage(to targetSize: CGSize, _ block: () -> Void) -> Image? {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0)
        block()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
#endif

fileprivate func currentGraphicsContext() -> CGContext? {
    #if os(OSX)
        guard let graphicsContext = NSGraphicsContext.current() else { return nil }
        return unsafeBitCast(graphicsContext, to: CGContext.self)
    #else
        return UIGraphicsGetCurrentContext()
    #endif
}


/// Render path into a reasonably attractive image
public extension BezierPath {
    public var renderedImage: Image? {
        let path = zeroed()
        let insetX: CGFloat = 8 // path.bounds.size.width * 0.10
        let insetY: CGFloat = 8 // path.bounds.size.height * 0.10
        var rect = path.bounds.insetBy(dx: -insetX, dy: -insetY); rect.origin = .zero
        let backdrop = BezierPath(roundedRect: rect, cornerRadius: max(insetX, insetY))
        let image = drawImage(to: rect.size) {
            Color.white.setFill(); backdrop.fill()
            path.translate(to: CGPoint(x: insetX, y: insetY))
            path.stroke()
        }
        return image
    }
}
