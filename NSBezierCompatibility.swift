/*
 
 Erica Sadun, http://ericasadun.com
 UIKit Compatibility for NSBezierPath
 
 */

#if canImport(UIKit)
import UIKit
#else
import Cocoa
#endif

#if canImport(Cocoa)
extension NSBezierPath {
    /// Appends a straight line to the receiver’s path.
    open func addLine(to point: CGPoint) {
        self.line(to: point)
    }
    
    /// Adds a Bezier cubic curve to the receiver’s path.
    open func addCurve(to point: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint) {
        self.curve(to: point, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    }
    
    /// Appends a quadratic Bézier curve to the receiver’s path.
    open func addQuadCurve(to point: CGPoint, controlPoint: CGPoint) {
        let (d1x, d1y) = (controlPoint.x - currentPoint.x, controlPoint.y - currentPoint.y)
        let (d2x, d2y) = (point.x - controlPoint.x, point.y - controlPoint.y)
        let cp1 = CGPoint(x: controlPoint.x - d1x / 3.0, y: controlPoint.y - d1y / 3.0)
        let cp2 = CGPoint(x: controlPoint.x + d2x / 3.0, y: controlPoint.y + d2y / 3.0)
        self.curve(to: point, controlPoint1: cp1, controlPoint2: cp2)
    }
    
    /// Appends an arc to the receiver’s path.
    open func addArc(withCenter center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) {
        let _startAngle = startAngle * 180.0 / CGFloat.pi
        let _endAngle = endAngle * 180.0 / CGFloat.pi
        appendArc(withCenter: .zero, radius: radius, startAngle: _startAngle, endAngle: _endAngle, clockwise: !clockwise)
    }
    
    /// Creates and returns a new BezierPath object initialized with a rounded rectangular path.
    public convenience init(roundedRect: CGRect, cornerRadius: CGFloat) {
        self.init(roundedRect: roundedRect, xRadius: cornerRadius, yRadius: cornerRadius)
    }
    
    /// Transforms all points in the path using the specified affine transform matrix.
    open func apply(_ theTransform: CGAffineTransform) {
        let t = AffineTransform(m11: theTransform.a, m12: theTransform.b, m21: theTransform.c, m22: theTransform.d, tX: theTransform.tx, tY: theTransform.ty)
        transform(using: t)
    }
}

extension BezierPath {
    /// Creates and returns a new CGPath object initialized with the contents of the Bezier Path
    /// - Note: Implemented to match the UIKit version
    public var cgPath: CGPath {
        
        // Create a new cgPath to work with
        let path = CGMutablePath()
        
        // Build an adaptable set of control points for any element type
        var points: [CGPoint] = Array<CGPoint>(repeating: .zero, count: 3)
        
        // Iterate through the path elements and extend the cgPath
        for idx in 0 ..< self.elementCount {
            let type = self.element(at: idx, associatedPoints: &points)
            switch type {
            case .moveTo:
                path.move(to: points[0])
            case .lineTo:
                path.addLine(to: points[0])
            case .curveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath:
                path.closeSubpath()
            }
        }
        
        return path
    }
    
    /// Creates and returns a new UIBezierPath object initialized with the contents of a Core Graphics path.
    /// - Warning: To match UIKit, this cannot be a failable initializer
    public convenience init(cgPath: CGPath) {
        
        // Establish self and fetch reference
        self.init(); var selfref = self
        
        // Apply elements from cgPath argument
        cgPath.apply(info: &selfref, function: {
            (selfPtr, elementPtr: UnsafePointer<CGPathElement>) in
            
            // Unwrap pointer
            guard let selfPtr = selfPtr else {
                fatalError("init(cgPath: CGPath): Unable to unwrap pointer to self")
            }
            
            // Bind and fetch path and element
            let pathPtr = selfPtr.bindMemory(to: BezierPath.self, capacity: 1)
            let path = pathPtr.pointee
            let element = elementPtr.pointee
            
            // Update path with element
            switch element.type {
            case .moveToPoint:
                path.move(to: element.points[0])
            case .addLineToPoint:
                path.addLine(to: element.points[0])
            case .addQuadCurveToPoint:
                path.addQuadCurve(to: element.points[1], controlPoint: element.points[0])
            case .addCurveToPoint:
                path.addCurve(to: element.points[2], controlPoint1: element.points[0], controlPoint2: element.points[1])
            case .closeSubpath:
                path.close()
            }
        })
    }
}
#endif
