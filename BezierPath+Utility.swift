/*
 
 Erica Sadun, http://ericasadun.com
 Utility
 
 Samples: http://imgur.com/a/li3tf
 
 */

#if canImport(UIKit)
import UIKit
#else
import Cocoa
#endif

// Included to avoid additional dependencies on a geometry library
// but kept private to the file
fileprivate extension CGSize {   
    /// Returns point representation
    fileprivate var _point: CGPoint { return CGPoint(x: width, y: height) }
}

extension BezierPath {
    /// Returns reference points for overlaying path
    public func referenceOverlay() -> BezierPath {
        let path = BezierPath(rect: bounds)
        var paths: [BezierPath] = []
        for p in Anchor.points {
            let x = BezierPath(ovalIn: 4, 4)
            x.translate(to: path[p]._point, anchor: .center)
            paths.append(x)
        }
        paths.forEach { path.append($0) }
        return path
    }
}
