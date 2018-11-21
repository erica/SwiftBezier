import Foundation
import QuartzCore

/// Vends affine transforms
public struct BezierAffineomat {
    /// Translation by dx, dy
    public static func translate(dx: CGFloat, dy: CGFloat) -> CGAffineTransform {
        return CGAffineTransform(translationX: dx, y: dy)
    }
    
    /// Translation by CGSize
    public static func translate(by offset: CGSize) -> CGAffineTransform {
        return CGAffineTransform(translationX: offset.width, y: offset.height)
    }
    
    /// Translation by CGVector
    public static func translate(through offset: CGVector) -> CGAffineTransform {
        return CGAffineTransform(translationX: offset.dx, y: offset.dy)
    }
    
    /// Scale by sx, sy
    public static func scale(sx: CGFloat, sy: CGFloat) -> CGAffineTransform {
        return CGAffineTransform(scaleX: sx, y: sy)
    }
    
    /// Scale by CGSize
    public static func scale(by size: CGSize) -> CGAffineTransform {
        return CGAffineTransform(scaleX: size.width, y: size.height)
    }
    
    /// Scale by Factor
    public static func scale(factor: CGFloat) -> CGAffineTransform {
        return CGAffineTransform(scaleX: factor, y: factor)
    }
    
    /// Rotate by radians
    public static func rotate(by radians: CGFloat) -> CGAffineTransform {
        return CGAffineTransform(rotationAngle: radians)
    }
    
    /// Rotate by degrees
    public static func rotate(degrees: CGFloat) -> CGAffineTransform {
        return CGAffineTransform(rotationAngle: CGFloat(Double.pi) * (degrees / 180.0))
    }
    
    /// Flip vertically
    public static func vflip(height: CGFloat) -> CGAffineTransform {
        return CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: -1.0, tx: 0.0, ty: -height)
    }
    
    /// Flip horizontally
    public static func hflip(width: CGFloat) -> CGAffineTransform {
        return CGAffineTransform(a: -1.0, b: 0.0, c: 0.0, d: 1.0, tx: -width, ty: 0.0)
    }
}

