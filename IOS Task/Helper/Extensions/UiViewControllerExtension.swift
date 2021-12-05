//
//  UiViewControllerExtension.swift
//  IOS Task
//
//  Created by fares on 05/12/2021.
//

import UIKit

extension UIViewController {
    func alertMessage(title: String, userMessage: String, complition: (() -> Void)? = nil) {
        let myAlert = UIAlertController(title: title, message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            complition?()
        })
        myAlert.addAction(okAction)
        present(myAlert, animated: true, completion: nil)
    }

    func alertController(withTitle title: String? = nil, message: String? = nil, alertStyle style: UIAlertController.Style = .alert, withCancelButton isCancelButton: Bool = false, cancelButtonTitle: String?, buttonsTitles: [String], completionActions completionBlock: ((_ buttonIndex: Int) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)

        // Buttons.
        for (index, buttonTitle) in buttonsTitles.enumerated() {
            let burronAction = UIAlertAction(title: buttonTitle, style: .default, handler: { _ in
                completionBlock?(index)
            })
            alert.addAction(burronAction)
        }

        if isCancelButton {
            let cancelButton = UIAlertAction(title: cancelButtonTitle, style: .cancel) { _ in
            }
            alert.addAction(cancelButton)
        }

        present(alert, animated: true, completion: nil)
    }
}

extension UIViewController {
    func showSpinner(onView: UIView, backColor: UIColor = UIColor.black.withAlphaComponent(0)) {
        let spinnerView = UIView(frame: onView.frame)
        spinnerView.tag = ViewTags.SpinnerTag.rawValue
        spinnerView.backgroundColor = backColor
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        if onView.subviews.contains(where: { $0.tag == ViewTags.SpinnerTag.rawValue }) {
            onView.subviews.filter({ $0.tag == ViewTags.SpinnerTag.rawValue }).forEach({ $0.removeFromSuperview() })
        }
        //
        var blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        if #available(iOS 12.0, *), traitCollection.userInterfaceStyle == .dark {
            blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
        }
        blurEffectView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        blurEffectView.cornerRadius = 10
        blurEffectView.clipsToBounds = true
        spinnerView.addSubview(blurEffectView)
        blurEffectView.center = spinnerView.center
        //
        var ai = UIActivityIndicatorView()
        if #available(iOS 13, *) {
            ai = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        } else {
            ai = UIActivityIndicatorView(style: .whiteLarge)
        }
        ai.color = .white
        ai.startAnimating()

        DispatchQueue.main.async { [weak self] in
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
            onView.bringSubviewToFront(spinnerView)
            spinnerView.fillSuperView()
            self?.view.layoutIfNeeded()
            blurEffectView.center = spinnerView.center
            ai.center = spinnerView.center
            onView.isUserInteractionEnabled = false
        }
    }

    func removeSpinner(fromView: UIView) {
        DispatchQueue.main.async {
            fromView.isUserInteractionEnabled = true
            fromView.subviews.forEach({ $0.viewWithTag(ViewTags.SpinnerTag.rawValue)?.removeFromSuperview() })
        }
    }
}
