#if os(OSX)
    import Cocoa
#else
    import UIKit
#endif

extension BezierPath {
    /// Returns a copy of the path with an action closure applied to it
    /// allowing the one-line creation of non-mutating variants
    fileprivate func applyToCopy(_ action: (BezierPath) -> Void) -> BezierPath {
        let path = BezierPath()
        path.append(self)
        action(path)
        return path
    }
}

extension BezierPath {
    /// Move path's origin to the point (x, y)
    public func translatePath(to x: CGFloat, _ y: CGFloat) -> Void {
        let zero = CGAffineTransform(translationX: -bounds.origin.x, y: -bounds.origin.y)
        let translate = CGAffineTransform(translationX: x, y: y)
        apply(zero); apply(translate)
    }
    
    /// Move path's origin to the specified point
    public func translatePath(to point: CGPoint) -> Void {
        translatePath(to: point.x, point.y)
    }
    
    /// Returns a copy of the path's whose origin is set to the point (x, y)
    public func translated(to x: CGFloat, _ y: CGFloat) -> BezierPath {
        return applyToCopy({ $0.translatePath(to: x, y) })
    }
    
    /// Returns a copy of the path's whose origin is set to the specified point
    public func translated(to point: CGPoint) -> BezierPath {
        return translated(to: point.x, point.y)
    }
    
    /// Move path's origin to the point (x, y)
    public func center(around x: CGFloat, _ y: CGFloat) -> Void {
        let translate = CGAffineTransform(
            translationX: x - bounds.size.width / 2.0,
            y: y - bounds.size.height / 2.0)
        translatePath(to: .zero)
        apply(translate)
    }
    
    /// Move path's origin to the specified point
    public func center(around point: CGPoint) -> Void {
        center(around: point.x, point.y)
    }
    
    /// Returns a copy of the path's whose origin is set to the point (x, y)
    public func centered(around x: CGFloat, _ y: CGFloat) -> BezierPath {
        return applyToCopy({ $0.center(around: x, y) })
    }
    
    /// Returns a copy of the path's whose origin is set to the specified point
    public func centered(around point: CGPoint) -> BezierPath {
        return centered(around: point.x, point.y)
    }
    
    /// Returns the geometric center of the path's bounds
    public var center: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    /// Flips around y
    public func flipVertically() -> Void {
        let point = center
        translatePath(to: .zero)
        apply(CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: -1.0, tx: 0.0, ty: -bounds.height))
        translatePath(to: point)
    }
    
    /// Returns a copy with flipped y coordinates
    public func flippedVertically() -> BezierPath {
        return applyToCopy({ $0.flipVertically() })
    }
}
