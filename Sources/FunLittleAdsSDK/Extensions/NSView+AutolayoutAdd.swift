//
//  NSView+AutolayoutAdd.swift
//  Brooklyn
//
//  Created by Max Goedjen on 11/13/15.
//  Copyright © 2015 Disney. All rights reserved.
//
#if !os(iOS)
import Cocoa

@objc extension NSView {
    public func addSubview(_ view: NSView, autolayout: Bool) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = !autolayout
    }
}

// ¯\_(ツ)_/¯
// I wanted to have some helpers for this kind of thing
// looked at a bunch of third party libs that do similar things (and a lot more)
// but didn't like many and I didn't really want to add a dependency
extension NSView {
    public enum LayoutMode {
        case fill
        case fillX
        case fillY
        case center
        case centerX
        case centerY
        case centerXOffset(CGFloat)
        case centerYOffset(CGFloat)
        case width(CGFloat)
        case height(CGFloat)
        case insetAll(CGFloat)
        case inset(top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat)
        case pinX(leading: CGFloat, trailing: CGFloat)
        case pinY(top: CGFloat, bottom: CGFloat)
        case pinTop(CGFloat)
        case pinBottom(CGFloat)
        case pinLeading(CGFloat)
        case pinTrailing(CGFloat)

        public func apply(to view: NSView, superview: NSView) {
            constraints(for: view, superview: superview).activate()
        }

        public func constraints(for view: NSView, superview: NSView) -> [NSLayoutConstraint] {
            switch self {
            case .fill:
                return LayoutMode.insetAll(0).constraints(for: view, superview: superview)
            case .fillX:
                return LayoutMode.pinX(leading: 0, trailing: 0).constraints(for: view, superview: superview)
            case .fillY:
                return LayoutMode.pinY(top: 0, bottom: 0).constraints(for: view, superview: superview)
            case .center:
                return LayoutMode.centerX.constraints(for: view, superview: superview) +
                    LayoutMode.centerY.constraints(for: view, superview: superview)
            case .centerX:
                return [view.centerXAnchor.constraint(equalTo: superview.centerXAnchor)]
            case .centerY:
                return [view.centerYAnchor.constraint(equalTo: superview.centerYAnchor)]
            case .centerXOffset(let offset):
                return [view.centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: offset)]
            case .centerYOffset(let offset):
                return [view.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: offset)]
            case .width(let width):
                return [view.widthAnchor.constraint(equalToConstant: width)]
            case .height(let height):
                return [view.heightAnchor.constraint(equalToConstant: height)]
            case .insetAll(let inset):
                return LayoutMode.inset(top: inset, bottom: inset, leading: inset, trailing: inset).constraints(for: view, superview: superview)
            case .inset(let top, let bottom, let leading, let trailing):
                return LayoutMode.pinY(top: top, bottom: bottom).constraints(for: view, superview: superview) +
                    LayoutMode.pinX(leading: leading, trailing: trailing).constraints(for: view, superview: superview)
            case .pinX(let leading, let trailing):
                return [
                    view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading),
                    view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -trailing)
                ]
            case .pinY(let top, let bottom):
                return [
                    view.topAnchor.constraint(equalTo: superview.topAnchor, constant: top),
                    view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottom)
                ]
            case .pinTop(let constant):
                return [view.topAnchor.constraint(equalTo: superview.topAnchor, constant: constant)]
            case .pinBottom(let constant):
                return [view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: constant)]
            case .pinLeading(let constant):
                return [view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant)]
            case .pinTrailing(let constant):
                return [view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: constant)]
            }
        }
    }

    public func addSubview(_ view: NSView, layoutMode modes: LayoutMode...) {
        addSubview(view, autolayout: true)
        for mode in modes {
            mode.apply(to: view, superview: self)
        }
    }
}

#endif
