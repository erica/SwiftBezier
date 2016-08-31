/*
 
 Erica Sadun, http://ericasadun.com
 Shape initializers
 
 */

#if os(OSX)
    import Cocoa
#else
    import UIKit
#endif

/// Handy initializers
extension BezierPath {
    /// Creates and returns a circle of a given radius around the origin
    public convenience init(radius: CGFloat) {
        self.init(ovalIn: CGRect(x: -radius, y: -radius, width: radius * 2, height: radius * 2))
    }
    
    /// Creates and returns an oval of the given width and height around the origin
    public convenience init(ovalIn width: CGFloat, _ height: CGFloat) {
        self.init(ovalIn: CGRect(x: -width / 2.0, y: -height / 2.0, width: width, height: height))
    }
    
    /// Creates and returns an rectangle of the given width and height around the origin
    public convenience init(rect width: CGFloat, _ height: CGFloat) {
        self.init(rect: CGRect(x: -width / 2.0, y: -height / 2.0, width: width, height: height))
    }
    
    /// Creates and returns a rounded rectangle of the given width and height around the origin, using the supplied corner radius
    public convenience init(roundedRect width: CGFloat, _ height: CGFloat, cornerRadius radius: CGFloat) {
        self.init(roundedRect: CGRect(x: -width / 2.0, y: -height / 2.0, width: width, height: height), cornerRadius: radius)
    }
    
    /// Returns an arc, swinging from 0 degrees ccw
    public convenience init(wedge angle: CGFloat, radius: CGFloat = 100.0) {
        self.init()
        move(to: .zero)
        addLine(to: CGPoint(x: radius, y: 0.0))
        addArc(withCenter: .zero, radius: radius, startAngle: 0.0, endAngle: angle, clockwise: true)
        addLine(to: .zero)
    }
}

/// Character and String initialization
extension BezierPath {
    /// Returns a path created from the character and the optional font
    public convenience init? (
        character: Character,
        font: Font = Font.boldSystemFont(ofSize: 32.0)) {
        self.init()
        var glyph = CGGlyph()
        guard let unichar = String(character).utf16.first else { return nil }
        var chars = [unichar]
        if CTFontGetGlyphsForCharacters(font, &chars, &glyph, 1) {
            guard let ctLetterPath = CTFontCreatePathForGlyph(font, glyph, nil) else { return nil }
            self.append(BezierPath(cgPath: ctLetterPath))
        } else { return nil }
    }
    
    /// Returns a path created from the character and the font name and size
    public convenience init? (
        character: Character,
        face: String = Font.boldSystemFont(ofSize: 32.0).fontName,
        size: CGFloat) {
        guard let font = Font(name: face, size: size) else { return nil }
        self.init(character: character, font: font)
    }
    
    /// Returns a path created from the supplied string and the optional font
    public convenience init? (string: String, font: Font = Font.boldSystemFont(ofSize: 32.0)) {
        self.init()
        for character in string.characters {
            let size = NSString(string: String(character))._size(attributes: [NSFontAttributeName:font])
            if let charPath = BezierPath(character: character, font: font) {
                append(charPath) }
            apply(CGAffineTransform(translationX: -size.width, y: 0))
        }
        zero()
    }
    
    /// Returns a path created from the supplied string and the font name and size
    public convenience init? (
        string: String,
        face: String = Font.boldSystemFont(ofSize: 32.0).fontName,
        size: CGFloat) {
        guard let font = Font(name: face, size: size) else { return nil }
        self.init(string: string, font: font)
    }
}

/// N-sided Polygon variations
extension BezierPath {
    
    /// Symmetric n-sided polygon styles
    public enum PolygonStyle {
        case flatsingle, flatdouble, curvesingle, curvedouble, flattruple, curvetruple
    }
    
    /// Establish a symmetric n-sided polygon
    public convenience init?(
        sides sideCount: Int,
        radius: CGFloat,
        style: PolygonStyle = .curvesingle,
        percentInflection: CGFloat = 0.0,
        startAngle offset: CGFloat =  0.0)
    {
        guard sideCount >= 3 else {
            print("Bezier polygon construction requires 3+ sides")
            return nil
        }
        
        func pointAt(_ theta: CGFloat, inflected: Bool = false, centered: Bool = false) -> CGPoint {
            let inflection = inflected ? percentInflection : 0.0
            let r = centered ? 0.0 : radius * (1.0 + inflection)
            return CGPoint(
                x: r * CGFloat(cos(theta)),
                y: r * CGFloat(sin(theta)))
        }
        
        let π = CGFloat(Double.pi); let 𝜏 = 2.0 * π
        let dθ = 𝜏 / CGFloat(sideCount)
        
        self.init()
        move(to: pointAt(0.0 + offset))
        
        switch (percentInflection == 0.0, style) {
        case (true, _):
            for θ in stride(from: 0.0, through: 𝜏, by: dθ) {
                addLine(to: pointAt(θ + offset))
            }
        case (false, .curvesingle):
            let cpθ = dθ / 2.0
            for θ in stride(from: 0.0, to: 𝜏, by: dθ) {
                addQuadCurve(
                    to: pointAt(θ + dθ + offset),
                    controlPoint: pointAt(θ + cpθ + offset, inflected: true))
            }
        case (false, .flatsingle):
            let cpθ = dθ / 2.0
            for θ in stride(from: 0.0, to: 𝜏, by: dθ) {
                addLine(to: pointAt(θ + cpθ + offset, inflected: true))
                addLine(to: pointAt(θ + dθ + offset))
            }
        case (false, .curvedouble):
            let (cp1θ, cp2θ) = (dθ / 3.0, 2.0 * dθ / 3.0)
            for θ in stride(from: 0.0, to: 𝜏, by: dθ) {
                addCurve(
                    to: pointAt(θ + dθ + offset),
                    controlPoint1: pointAt(θ + cp1θ + offset, inflected: true),
                    controlPoint2: pointAt(θ + cp2θ + offset, inflected: true)
                )
            }
        case (false, .flatdouble):
            let (cp1θ, cp2θ) = (dθ / 3.0, 2.0 * dθ / 3.0)
            for θ in stride(from: 0.0, to: 𝜏, by: dθ) {
                addLine(to: pointAt(θ + cp1θ + offset, inflected: true))
                addLine(to: pointAt(θ + cp2θ + offset, inflected: true))
                addLine(to: pointAt(θ + dθ + offset))
            }
            
        case (false, .flattruple):
            let (cp1θ, cp2θ) = (dθ / 3.0, 2.0 * dθ / 3.0)
            for θ in stride(from: 0.0, to: 𝜏, by: dθ) {
                addLine(to: pointAt(θ + cp1θ + offset, inflected: true))
                addLine(to: pointAt(θ + dθ / 2.0 + offset, centered: true))
                addLine(to: pointAt(θ + cp2θ + offset, inflected: true))
                addLine(to: pointAt(θ + dθ + offset))
            }
        case (false, .curvetruple):
            let (cp1θ, cp2θ) = (dθ / 3.0, 2.0 * dθ / 3.0)
            for θ in stride(from: 0.0, to: 𝜏, by: dθ) {
                addQuadCurve(
                    to: pointAt(θ + dθ / 2.0 + offset, centered:true),
                    controlPoint: pointAt(θ + cp1θ + offset, inflected: true))
                addQuadCurve(
                    to: pointAt(θ + dθ + offset),
                    controlPoint: pointAt(θ + cp2θ + offset, inflected: true))
            }
        }
        
        close()
    }
}
