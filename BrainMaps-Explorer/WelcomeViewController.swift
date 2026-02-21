//
//  WelcomeViewController.swift
//  BrainMaps_Explorer
//
//  Created by Fariha Kha on 11/09/25.
//

import UIKit

class WelcomeViewController: UIViewController {

    private var enterBrainButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        startIdleGlow()
    }

    // Setup

    private func setupButton() {
        guard let button = view.viewWithTag(100) as? UIButton else {
            fatalError("Enter Brain button not found (tag = 100)")
        }

        enterBrainButton = button

        // Rounded pill
        button.layer.cornerRadius = button.bounds.height / 2
        button.layer.masksToBounds = false

        // Base glow
        button.layer.shadowColor = UIColor.systemPurple.cgColor
        button.layer.shadowRadius = 12
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = .zero

        // Touch handlers
        button.addTarget(self, action: #selector(touchDown), for: .touchDown)
        button.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        button.addTarget(self, action: #selector(touchCancel), for: [.touchCancel, .touchUpOutside])
    }

    // Idle Glow

    private func startIdleGlow() {
        let glow = CABasicAnimation(keyPath: "shadowOpacity")
        glow.fromValue = 0.25
        glow.toValue = 0.6
        glow.duration = 1.4
        glow.autoreverses = true
        glow.repeatCount = .infinity
        glow.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        enterBrainButton.layer.add(glow, forKey: "idleGlow")
    }

    // Touch Feedback

    @objc private func touchDown() {
        // Stop idle glow
        enterBrainButton.layer.removeAnimation(forKey: "idleGlow")

        // Intensify glow immediately
        let intenseGlow = CABasicAnimation(keyPath: "shadowOpacity")
        intenseGlow.fromValue = enterBrainButton.layer.shadowOpacity
        intenseGlow.toValue = 0.9
        intenseGlow.duration = 0.15
        intenseGlow.fillMode = .forwards
        intenseGlow.isRemovedOnCompletion = false

        enterBrainButton.layer.add(intenseGlow, forKey: "intenseGlow")
    }

    @objc private func touchUpInside() {
        addRipple()
        performSegue(withIdentifier: "showSearch", sender: nil)
    }

    @objc private func touchCancel() {
        enterBrainButton.layer.removeAllAnimations()
        startIdleGlow()
    }

    // Ripple Effect

    private func addRipple() {
        let rippleLayer = CAShapeLayer()
        let radius = max(enterBrainButton.bounds.width, enterBrainButton.bounds.height)
        let center = CGPoint(x: enterBrainButton.bounds.midX,
                              y: enterBrainButton.bounds.midY)

        let startPath = UIBezierPath(ovalIn: CGRect(
            x: center.x - 1,
            y: center.y - 1,
            width: 2,
            height: 2
        ))

        let endPath = UIBezierPath(ovalIn: CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        ))

        rippleLayer.path = endPath.cgPath
        rippleLayer.fillColor = UIColor.systemPurple.withAlphaComponent(0.25).cgColor
        rippleLayer.opacity = 0

        enterBrainButton.layer.insertSublayer(rippleLayer, below: enterBrainButton.titleLabel?.layer)

        let pathAnim = CABasicAnimation(keyPath: "path")
        pathAnim.fromValue = startPath.cgPath
        pathAnim.toValue = endPath.cgPath

        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.fromValue = 0.6
        opacityAnim.toValue = 0.0

        let group = CAAnimationGroup()
        group.animations = [pathAnim, opacityAnim]
        group.duration = 0.45
        group.timingFunction = CAMediaTimingFunction(name: .easeOut)
        group.isRemovedOnCompletion = true

        rippleLayer.add(group, forKey: "ripple")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            rippleLayer.removeFromSuperlayer()
        }
    }
}

