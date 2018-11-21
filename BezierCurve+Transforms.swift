/*
 
 Erica Sadun, http://ericasadun.com
 Shape initializers
 Requires Affineomat from Geometry, provided here as BezierAffineomat
 to remove dependencies
 
 */

#if os(OSX)
    import Cocoa
#else
    import UIKit
#endif

// Included to avoid additional dependencies on a geometry library
// but kept private to the file
fileprivate extension CGRect {
    /// Returns center
    fileprivate var _center: CGPoint { return CGPoint(x: midX, y: midY) }

    /// Constructs a rectangle around a center with the given size
    fileprivate static func _around(_ center: CGPoint, size: CGSize) -> CGRect {
        let origin = CGPoint(
            x: center.x - size.width / 2.0,
            y: center.y - size.height / 2.0)
        return CGRect(origin: origin, size: size)
    }
    
    /// Calculates the aspect scale between a source size
    /// and a destination rectangle
    fileprivate func _aspectScale(of sourceSize: CGSize) -> CGFloat {
        let scaleW = width / sourceSize.width
        let scaleH = height / sourceSize.height
        return fmin(scaleW, scaleH)
    }
    
    /// Fitting into a destination rectangle
    fileprivate func _fitting(to destination: CGRect) -> CGRect {
        let aspect = destination._aspectScale(of: size)
        let targetSize = CGSize(width: width * aspect, height: height * aspect)
        return CGRect._around(destination._center, size: targetSize)
    }
}

fileprivate extension CGPoint {
    /// Returns size representation
    fileprivate var size: CGSize { return CGSize(width: x, height: y) }
    
    /// Returns negative extents
    fileprivate var negative: CGPoint { return CGPoint(x: -x, y: -y) }
}

fileprivate extension CGSize {
    /// Returns point representation
    fileprivate var point: CGPoint { return CGPoint(x: width, y: height) }

    /// Returns negative extents
    fileprivate var negative: CGSize { return CGSize(width: -width, height: -height) }
}

public extension BezierPath {
    
    /// Return a copy of the path
    public func clone() -> BezierPath {
        let path = BezierPath(); path.append(self); return path
    }
    
    // MARK: Centered Transform Application
    
    /// Return the path's center location
    public var center: CGPoint { return bounds._center }
    
    /// Apply a transform with respect to the path center
    public func apply(centered transform: CGAffineTransform) {
        let centerPoint = center
        apply(BezierAffineomat.translate(by: centerPoint.negative.size))
        apply(transform)
        apply(BezierAffineomat.translate(by: centerPoint.size))
    }    
    
    public func applying(centered transform: CGAffineTransform) -> BezierPath {
        let path = clone(); path.apply(centered: transform); return path
    }
    
    public func applying(_ transform: CGAffineTransform) -> BezierPath {
        apply(transform); return self
    }
    
    // MARK: Common Transforms
    
    /// Scales in place by CGSize
    public func scaleInPlace(by factor: CGSize) {
        apply(centered: BezierAffineomat.scale(by: factor))
    }
    
    /// Returns a copy scaled by CGSize
    public func scaledInPlace(by factor: CGSize) -> BezierPath {
        return applying(centered: BezierAffineomat.scale(by: factor))
    }
    
    /// Scales in place by (sx, sy)
    public func scaleInPlace(sx: CGFloat, sy: CGFloat) {
        scaleInPlace(by: CGSize(width: sx, height: sy))
    }
    
    /// Returns a copy scaled by (sx, sy)
    public func scaledInPlace(sx: CGFloat, sy: CGFloat) -> BezierPath {
        return applying(centered: BezierAffineomat.scale(sx: sx, sy: sy))
    }
    
    /// Scales in place by (factor, factor)
    public func scaleInPlace(factor: CGFloat) {
        scaleInPlace(sx: factor, sy: factor)
    }
    
    /// Returns a copy scaled by (factor, factor)
    public func scaledInPlace(factor: CGFloat) -> BezierPath {
        return scaledInPlace(sx: factor, sy: factor)
    }
    
    /// Rotates in place by radians
    public func rotateInPlace(by radians: CGFloat) {
        apply(centered: BezierAffineomat.rotate(by: radians))
    }
    
    /// Returns a copy rotated in place by radians
    public func rotatedInPlace(by radians: CGFloat) -> BezierPath {
        return clone().applying(centered: BezierAffineomat.rotate(by: radians))
    }
    
    /// Offsets by CGSize
    public func offset(by offset: CGSize) {
        apply(BezierAffineomat.translate(by: offset))
    }
    
    /// Returns a copy offset by CGSize
    public func offsetting(by offset: CGSize) -> BezierPath {
        return clone().applying(BezierAffineomat.translate(by: offset))
    }
    
    /// Offsets by dx, dy
    public func offset(dx: CGFloat, dy: CGFloat) {
        apply(BezierAffineomat.translate(by: CGSize(width: dx, height: dy)))
    }
    
    /// Returns a copy offset by dx, dy
    public func offsetting(dx: CGFloat, dy: CGFloat) -> BezierPath {
        return clone().applying(BezierAffineomat.translate(by: CGSize(width: dx, height: dy)))
    }
    
    // Translation with anchoring
    
    /// Translates and anchors to point
    public func translate(to point: CGPoint, anchor: Anchor = .topleft) {
        offset(by: self[anchor].negative) // negative offset
        offset(by: point.size) // positive distance
    }
    
    /// Returns a copy translated and anchored to point
    public func translated(to point: CGPoint, anchor: Anchor = .topleft) -> BezierPath {
        let duplicate = clone()
        duplicate.translate(to: point, anchor: anchor)
        return duplicate
    }
    
    /// Translates and anchors to origin
    public func zero(around anchor: Anchor = .topleft) {
        translate(to: .zero, anchor: anchor)
    }
    
    /// Returns a copy translated and anchored to origin
    public func zeroed(around anchor: Anchor = .topleft) -> BezierPath {
        return translated(to: .zero, anchor: anchor)
    }
    
    /// Translates and centers at point
    public func center(at point: CGPoint) {
        translate(to: point, anchor: .center)
    }
    
    /// Returns a copy translated to and centered at point
    public func centered(at point: CGPoint) -> BezierPath {
        return translated(to: point, anchor: .center)
    }
    
    // Mirroring
    
    /// Flips vertically in-place
    public func flipVerticallyInPlace() {
        apply(centered: BezierAffineomat.vflip(height: bounds.height))
    }
    
    /// Returns a copy flipped vertically in place
    public func flippedVerticallyInPlace() -> BezierPath {
        return clone().applying(centered: BezierAffineomat.vflip(height: bounds.height))
    }
    
    /// Flips horizontally in-place
    public func flipHorizontallyInPlace() {
        apply(centered: BezierAffineomat.hflip(width: bounds.width))
    }
    
    /// Flips vertically in-place
    public func flippedHorizontallyInPlace() -> BezierPath {
        return clone().applying(centered: BezierAffineomat.hflip(width: bounds.width))
    }
    
    // MARK: Fitting
    
    /// Fits to destination rectangle
    public func fit(to destRect: CGRect) {
        let fitRect = bounds._fitting(to: destRect)
        let aspect = destRect._aspectScale(of: bounds.size)
        center(at: fitRect._center)
        scaleInPlace(sx: aspect, sy: aspect)
    }
    
    /// Returns a copy fitted to destination rectangle
    public func fitted(to destRect: CGRect) -> BezierPath {
        let dupe = clone()
        dupe.fit(to: destRect)
        return dupe
    }
}
