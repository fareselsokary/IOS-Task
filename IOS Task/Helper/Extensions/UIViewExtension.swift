//
//  UIViewExtension.swift
//  IOS Task
//
//  Created by fares on 04/12/2021.
//

import UIKit

@IBDesignable
extension UIView {
    @IBInspectable var isHalfRounded: Bool {
        get {
            return layer.cornerRadius == layer.bounds.size.height / 2
        } set {
            clipsToBounds = true
            layer.cornerRadius = layer.bounds.size.height / 2
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        } set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        } set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        } set {
            layer.borderColor = newValue.cgColor
        }
    }

    @IBInspectable internal var shadow_Color: UIColor {
        get {
            return UIColor(cgColor: layer.shadowColor ?? UIColor.clear.cgColor)
        } set {
            layer.shadowColor = newValue.cgColor
        }
    }

    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        } set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        } set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable var shadowOffsetX: CGFloat {
        get {
            return layer.shadowOffset.width
        } set {
            layer.shadowOffset = CGSize(width: newValue, height: layer.shadowOffset.height)
        }
    }

    @IBInspectable var shadowOffsetY: CGFloat {
        get {
            return layer.shadowOffset.height
        } set {
            layer.shadowOffset = CGSize(width: layer.shadowOffset.width, height: newValue)
        }
    }
}

extension UIView {
    var viewController: UIViewController? {
        let next = self.next
        if next is UIViewController {
            return next as? UIViewController
        } else if next is UIView {
            return (next as? UIView)?.viewController
        } else {
            return nil
        }
    }
}

extension UIView {
    func fillSuperView(shouldUseSafeArea: Bool = true, padding: UIEdgeInsets = UIEdgeInsets.zero) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: shouldUseSafeArea ?
                superview.safeAreaLayoutGuide.leadingAnchor :
                superview.leadingAnchor, constant: padding.left),
            trailingAnchor.constraint(equalTo: shouldUseSafeArea ?
                superview.safeAreaLayoutGuide.trailingAnchor :
                superview.trailingAnchor, constant: -padding.right),

            topAnchor.constraint(equalTo: shouldUseSafeArea ?
                superview.safeAreaLayoutGuide.topAnchor :
                superview.topAnchor, constant: padding.top),
            bottomAnchor.constraint(equalTo: shouldUseSafeArea ?
                superview.safeAreaLayoutGuide.bottomAnchor :
                superview.bottomAnchor, constant: -padding.bottom),
        ])
    }
}
