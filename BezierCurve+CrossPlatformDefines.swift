/*
 
 Erica Sadun, http://ericasadun.com
 Cross Platform Defines
 
 Apple Platforms Only
 Will update to #if canImport() when available
 
 */

import Foundation

// Frameworks
#if os(OSX)
    import Cocoa
#else
    import UIKit
#endif

// UIKit/Cocoa Classes
#if os(OSX)
    public typealias Font = NSFont
    public typealias BezierPath = NSBezierPath
    public typealias Image = NSImage
    public typealias Color = NSColor
#else
//    public typealias View = UIView
    public typealias Font = UIFont
    public typealias BezierPath = UIBezierPath
    public typealias Image = UIImage
    public typealias Color = UIColor
#endif
