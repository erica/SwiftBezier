/*
 
 Erica Sadun, http://ericasadun.com
 Shape initializers
 Requires Sizeomat.swift, Affinomat.swift
 
 */

#if os(OSX)
    import Cocoa
#else
    import UIKit
#endif

public extension BezierPath {
    
    /// Return a copy of the path
    public func clone() -> BezierPath {
        let path = BezierPath(); path.append(self); return path
    }

    // MARK: Centered Application
    
    /// Return the path's center location
    public var center: CGPoint { return bounds.center }
    
    /// Apply a transform with respect to the path center
    public func apply(centered transform: CGAffineTransform) {
        let centerPoint = center
        apply(Affineomat.translate(by: centerPoint.negative.size))
        apply(transform)
        apply(Affineomat.translate(by: centerPoint.size))
    }    
    
    public func applying(centered transform: CGAffineTransform) -> BezierPath {
        let path = clone(); path.apply(centered: transform); return path
    }
    
    public func applying(_ transform: CGAffineTransform) -> BezierPath {
        apply(transform); return self
    }
    
    
    // MARK: Common Transforms
    
    /// Scales in place by CGSize
    public func scale(by factor: CGSize) { apply(centered: Affineomat.scale(by: factor)) }
    
    /// Returns a copy scaled by CGSize
    public func scaled(by factor: CGSize) -> BezierPath {
        return applying(centered: Affineomat.scale(by: factor))
    }
    
    /// Scales in place by (sx, sy)
    public func scale(sx: CGFloat, sy: CGFloat) { scale(by: CGSize(width: sx, height: sy)) }
    
    /// Returns a copy scaled by (sx, sy)
    public func scaled(sx: CGFloat, sy: CGFloat) -> BezierPath {
        return applying(centered: Affineomat.scale(sx, sy))
    }
    
    /// Scales in place by (factor, factor)
    public func scale(factor: CGFloat) { scale(sx: factor, sy: factor) }
    
    /// Returns a copy scaled by (factor, factor)
    public func scaled(factor: CGFloat) -> BezierPath { return scaled(sx: factor, sy: factor) }
    
    /// Rotates in place by radians
    public func rotate(by radians: CGFloat) { apply(centered: Affineomat.rotate(by: radians)) }
    
    /// Returns a copy rotated by radians
    public func rotated(by radians: CGFloat) -> BezierPath {
        return clone().applying(centered: Affineomat.rotate(by: radians))
    }
    
    /// Offsets by CGSize
    public func offset(by offset: CGSize) {
        apply(Affineomat.translate(by: offset))
    }
    
    /// Returns a copy offset by CGSize
    public func offsetting(by offset: CGSize) -> BezierPath {
        return clone().applying(Affineomat.translate(by: offset))
    }
    
    /// Offsets by dx, dy
    public func offset(dx: CGFloat, dy: CGFloat) {
        apply(Affineomat.translate(by: CGSize(w: dx, h: dy)))
    }
    
    /// Returns a copy offset by dx, dy
    public func offsetting(dx: CGFloat, dy: CGFloat) -> BezierPath {
        return clone().applying(Affineomat.translate(by: CGSize(w: dx, h: dy)))
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
    public func flipVertically() {
        apply(centered: Affineomat.vflip(height: bounds.height))
    }
    
    /// Returns a copy flipped vertically in place
    public func flippedVertically() -> BezierPath {
        return clone().applying(centered: Affineomat.vflip(height: bounds.height))
    }
    
    /// Flips horizontally in-place
    public func flipHorizontally() {
        apply(centered: Affineomat.hflip(width: bounds.width))
    }
    
    /// Flips vertically in-place
    public func flippedHorizontally() -> BezierPath {
        return clone().applying(centered: Affineomat.hflip(width: bounds.width))
    }
    
    // MARK: Fitting
    
    /// Fits to destination rectangle
    public func fit(to destRect: CGRect) {
        let fitRect = bounds.fitting(to: destRect)
        let aspect = destRect.aspectScale(of: bounds.size)
        center(at: fitRect.center)
        scale(sx: aspect, sy: aspect)
    }
    
    /// Returns a copy fitted to destination rectangle
    public func fitted(to destRect: CGRect) -> BezierPath {
        let dupe = clone()
        dupe.fit(to: destRect)
        return dupe
    }
}
