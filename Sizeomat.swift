/*
 
 Erica Sadun, http://ericasadun.com
 Sizeomat: Sizes and Anchors
 
 */

#if os(OSX)
    import Cocoa
#else
    import UIKit
#endif

/// Cardinal anchoring points
public enum Anchor {
    case topleft, topcenter, topright
    case centerleft, center, centerright
    case bottomleft, bottomcenter, bottomright
    public static var points: [Anchor] = [
        .topleft, .topcenter, .topright,
        .centerleft, .center, .centerright,
        .bottomleft, .bottomcenter, .bottomright]
}


public extension CGPoint {
    /// Returns size representation
    public var size: CGSize { return CGSize(width: x, height: y) }
    
    /// Returns negative extents
    public var negative: CGPoint { return CGPoint(x: -x, y: -y) }
    
    public init(_ x: CGFloat, _ y: CGFloat) { (self.x, self.y) = (x, y) }
}

public extension CGSize {
    /// Returns point representation
    public var point: CGPoint { return CGPoint(x: width, y: height) }
    
    /// Returns negative extents
    public var negative: CGSize { return CGSize(width: -width, height: -height) }
    
    public init(w: CGFloat, h: CGFloat) { (self.width, self.height) = (w, h) }
    public init(_ w: CGFloat, _ h: CGFloat) { (self.width, self.height) = (w, h) }
}

public extension CGRect {
    public init(width w: CGFloat, height h: CGFloat) { (self.origin, self.size) = (.zero, CGSize(w, h)) }
    public init(w: CGFloat, h: CGFloat) { (self.origin, self.size) = (.zero, CGSize(w, h)) }
    public init(_ w: CGFloat, _ h: CGFloat) { (self.origin, self.size) = (.zero, CGSize(w, h)) }
    
    public var x: CGFloat { return origin.x }
    public var y: CGFloat { return origin.x }
    public var width: CGFloat { return size.width }
    public var height: CGFloat { return size.height }
    
    /// Returns center
    public var center: CGPoint { return CGPoint(x: midX, y: midY) }
    
    /// Constructs a rectangle around a center with the given size
    public static func around(_ center: CGPoint, size: CGSize) -> CGRect {
        let origin = CGPoint(x: center.x - size.width / 2.0, y: center.y - size.height / 2.0)
        return CGRect(origin: origin, size: size)
    }
    
    /// Calculates the aspect scale between a source size
    /// and a destination rectangle
    public func aspectScale(of sourceSize: CGSize) -> CGFloat {
        let scaleW = width / sourceSize.width
        let scaleH = height / sourceSize.height
        return fmin(scaleW, scaleH)
    }
    
    /// Fitting into a destination rectangle
    public func fitting(to destination: CGRect) -> CGRect {
        let aspect = destination.aspectScale(of: size)
        let targetSize = CGSize(width: width * aspect, height: height * aspect)
        return CGRect.around(destination.center, size: targetSize)
    }
}

extension BezierPath {
    /// Returns as size not point because this is more often
    /// used for offsets than placement
    public subscript(anchor: Anchor) -> CGSize {
        let (x, y) = (bounds.origin.x, bounds.origin.y)
        let (w, h) = (bounds.size.width, bounds.size.height)
        let (halfw, halfh) = (w / 2.0, h / 2.0)

        switch anchor {
        case .topleft:      return CGSize(w: x ,         h: y )
        case .topcenter:    return CGSize(w: x + halfw,  h: y )
        case .topright:     return CGSize(w: x + w,      h: y )
            
        case .centerleft:   return CGSize(w: x ,         h: y + halfh)
        case .center:       return CGSize(w: x + halfw,  h: y + halfh)
        case .centerright:  return CGSize(w: x + w,      h: y + halfh)
            
        case .bottomleft:   return CGSize(w: x ,         h: y + h)
        case .bottomcenter: return CGSize(w: x + halfw,  h: y + h)
        case .bottomright:  return CGSize(w: x + w,      h: y + h)
        }
    }
}


extension BezierPath {
    /// Returns reference points for overlaying path
    public func referenceOverlay() -> BezierPath {
        let path = BezierPath(rect: bounds)
        var paths: [BezierPath] = []
        for p in Anchor.points {
            let x = BezierPath(ovalIn: 4, 4)
            x.translate(to: path[p].point, anchor: .center)
            paths.append(x)
        }
        paths.forEach { path.append($0) }
        return path
    }
}
