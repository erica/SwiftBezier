/*
 
 Erica Sadun, http://ericasadun.com
 Shape initializers
 
 */

#if os(OSX)
    import Cocoa
#else
    import UIKit
#endif

// MARK: Support Math
// Included to avoid geometry library requirements

extension BezierPath {
    func centerOf(_ rect: CGRect) -> CGPoint {
        return CGPoint(x: rect.midX, y: rect.midY)
    }
    
    func rect(around center: CGPoint, size:CGSize) -> CGRect {
        let origin = CGPoint(x: center.x - size.width / 2.0, y: center.y - size.height / 2)
        return CGRect(origin: origin, size: size)
    }
    
    func aspectScale(of sourceSize: CGSize, to destRect: CGRect) -> CGFloat {
        let destSize = destRect.size
        let scaleW = destSize.width / sourceSize.width
        let scaleH = destSize.height / sourceSize.height
        return fmin(scaleW, scaleH)
    }
    
    func fitting(sourceRect: CGRect, to destinationRect: CGRect) -> CGRect {
        let aspect = aspectScale(of: sourceRect.size, to: destinationRect)
        let targetSize = CGSize(width: sourceRect.size.width * aspect, height: sourceRect.size.height * aspect)
        return rect(around: centerOf(destinationRect), size: targetSize)
    }
}

public extension BezierPath {

    // MARK: Centered Application
    
    public var center: CGPoint { return centerOf(bounds) }
    
    public func apply(centered transform: CGAffineTransform) {
        let centerPoint = center
        var t: CGAffineTransform = .identity
        t = t.translatedBy(x: centerPoint.x, y: centerPoint.y)
        t = t.concatenating(transform) // check for accuracy
        t = t.translatedBy(x: -centerPoint.x, y: -centerPoint.y)
        apply(t)
    }
    
    public func dupe() -> BezierPath {
        let path = BezierPath(); path.append(self); return path
    }

    
    public func applying(centered transform: CGAffineTransform) -> BezierPath {
        let path = dupe(); path.apply(centered: transform); return path
    }
    
    public func applying(_ transform: CGAffineTransform) -> BezierPath {
        apply(transform); return self
    }
    
    
    // MARK: Common Transforms
    
    public func scale(by sx: CGFloat, _ sy: CGFloat) {
        return apply(centered: CGAffineTransform(scaleX: sx, y: sy))
    }
    
    public func scaled(by sx: CGFloat, _ sy: CGFloat) -> BezierPath {
        return applying(centered: CGAffineTransform(scaleX: sx, y: sy))
    }
    
    public func offset(by offset: CGSize) {
        apply(CGAffineTransform(translationX: offset.width, y: offset.height))
    }
    
    public func offsetting(by offset: CGSize) -> BezierPath {
        return dupe().applying(CGAffineTransform(translationX: offset.width, y: offset.height))
    }
    
    public func rotate(by radians: CGFloat) {
        apply(centered: CGAffineTransform(rotationAngle: radians))
    }
    
    public func rotated(by radians: CGFloat) -> BezierPath {
        return dupe().applying(centered: CGAffineTransform(rotationAngle: radians))
    }

    public func zero() {
        offset(by: CGSize(width: -bounds.origin.x, height: -bounds.origin.y))
    }

    public func zeroed() -> BezierPath {
        return dupe().offsetting(by: CGSize(width: -bounds.origin.x, height: -bounds.origin.y))
    }
    
    public func translate(to point: CGPoint) {
        self.zero(); self.offset(by: CGSize(width: point.x, height: point.y))
    }
    
    public func translated(to point: CGPoint) -> BezierPath {
        return dupe().zeroed().offsetting(by: CGSize(width: point.x, height: point.y))
    }
    
    public func flipVertically() {
        apply(centered: CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: -1.0, tx: 0.0, ty: -bounds.height))
    }

    public func flippedVertically() -> BezierPath {
        return dupe().applying(centered: CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: -1.0, tx: 0.0, ty: -bounds.height))
    }
    
    public func flipHorizontally() {
        apply(centered: CGAffineTransform(a: -1.0, b: 0.0, c: 0.0, d: 1.0, tx: -bounds.width, ty: 0.0))
    }

    public func flippedHorizontally() -> BezierPath {
        return dupe().applying(centered: CGAffineTransform(a: -1.0, b: 0.0, c: 0.0, d: 1.0, tx: -bounds.width, ty: 0.0))
    }
    
    public func mirrorVertically(through height: CGFloat) {
        apply(CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: -1.0, tx: 0.0, ty: -height))
    }
    
    public func mirroredVertically(through height: CGFloat) -> BezierPath {
        return dupe().applying(CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: -1.0, tx: 0.0, ty: -height))
    }
    
    public func mirrorHorizontally(through width: CGFloat) {
        apply(CGAffineTransform(a: -1.0, b: 0.0, c: 0.0, d: 1.0, tx: -width, ty: 0.0))
    }
    
    public func mirroredHorizontally(through width: CGFloat) -> BezierPath {
        return dupe().applying(CGAffineTransform(a: -1.0, b: 0.0, c: 0.0, d: 1.0, tx: -width, ty: 0.0))
    }
    
    public func center(at destPoint: CGPoint) {
        var vector = CGSize(width: destPoint.x - bounds.origin.x, height: destPoint.y - bounds.origin.y)
        vector.width -= bounds.size.width / 2.0
        vector.height -= bounds.size.height / 2.0
        offset(by: CGSize(width: vector.width, height: vector.height))
    }
    
    public func centered(at destPoint: CGPoint) -> BezierPath {
        var vector = CGSize(width: destPoint.x - bounds.origin.x, height: destPoint.y - bounds.origin.y)
        vector.width -= bounds.size.width / 2.0
        vector.height -= bounds.size.height / 2.0
        return dupe().offsetting(by: CGSize(width: vector.width, height: vector.height))
    }

    // MARK: Fitting
    
    public func fit(to destRect: CGRect) {
        let fitRect = fitting(sourceRect: bounds, to: destRect)
        let aspect = aspectScale(of: bounds.size, to: destRect)
        center(at: centerOf(fitRect))
        scale(by: aspect, aspect)
    }
    
    public func fitted(to destRect: CGRect) -> BezierPath {
        let fitRect = fitting(sourceRect: bounds, to: destRect)
        let aspect = aspectScale(of: bounds.size, to: destRect)
        return dupe()
            .centered(at: centerOf(fitRect))
            .scaled(by: aspect, aspect)
    }
    
    // MARK: Composition
    public func moveOff(h: Bool, v: Bool) {
        if h { offset(by: CGSize(width: bounds.width, height: 0)) }
        if v { offset(by: CGSize(width: 0, height: bounds.height)) }
    }
    
    public func movedOff(h: Bool, v: Bool) -> BezierPath {
        let myDupe = dupe(); myDupe.moveOff(h: h, v: v); return myDupe
    }
   
}

