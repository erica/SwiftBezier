/*
 
 Erica Sadun, http://ericasadun.com
 Anchors
 
 */

#if os(OSX)
    import Cocoa
#else
    import UIKit
#endif

// Included to avoid additional dependencies on a geometry library
// but kept private to the file
fileprivate extension CGSize {
    /// Shorthand initialization
    fileprivate init(w: CGFloat, h: CGFloat) { (self.width, self.height) = (w, h) }
}

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
