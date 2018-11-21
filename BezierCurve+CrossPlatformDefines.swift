/*
 
 Erica Sadun, http://ericasadun.com
 Cross Platform Defines
 
 Apple Platforms Only
 
 */

import Foundation

// Frameworks. This offers `@_exported`. Avoid for
// strict installs that frown on its use.
#if canImport(UIKit)
// @_exported import UIKit
import UIKit
#else
// @_exported import Cocoa
import Cocoa
#endif

// UIKit/Cocoa Classes
#if canImport(UIKit)
//    public typealias View = UIView
public typealias Font = UIFont
public typealias BezierPath = UIBezierPath
public typealias Image = UIImage
public typealias Color = UIColor
#else
public typealias Font = NSFont
public typealias BezierPath = NSBezierPath
public typealias Image = NSImage
public typealias Color = NSColor
#endif
