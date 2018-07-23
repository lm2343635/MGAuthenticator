//
//  MGPasscodeView.swift
//  MGAuthenticator
//
//  Created by Meng Li on 2018/07/20.
//  Copyright (c) 2018 fczm.pw. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import SnapKit
import AudioToolbox

public enum MGPasscodeViewControllerMode {
    case input((String) -> ())
    case authenticate
}

public class MGPasscodeViewController: UIViewController {
    
    private struct Const {
        struct point {
            static let horizontalMargin: CGFloat = 10
            static let bottomMargin: CGFloat = 40
            static let size: CGFloat = 16
        }
        
        struct button {
            static let margin: CGFloat = 15
        }
        
        struct title {
            static let bottomMargin: CGFloat = 20
            static let height: CGFloat = 30
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter passcode"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = highlightColor
        label.textAlignment = .center
        return label
    }()
    
    private lazy var pointsView = UIView()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(deletePasscode(sender:)), for: .touchUpInside)
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(highlightColor, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.setBackgroundImage(buttonNormalBackground, for: .normal)
        button.setBackgroundImage(buttonHighlightBackgroud, for: .highlighted)

        button.layer.cornerRadius = buttonWidth / 2
        button.layer.borderWidth = 1
        button.layer.borderColor = highlightColor.cgColor
        return button
    }()
    
    private lazy var points: [UIImageView] = []
    private lazy var buttons: [UIButton] = []

    private var passcodes: [Int] = []
    private var firstPasscode: String? = nil
    
    private let buttonWidth: CGFloat = {
        var width = UIScreen.main.bounds.size.width * 0.8
        if width < 300 {
            width = 300
        } else if width > 500 {
            width = 500
        }
        return width / 3 - 2 * Const.button.margin
    }()
    
    private var buttonNormalBackground = UIImage()
    private var buttonHighlightBackgroud = UIImage()
    private var pointNormalBackground = UIImage()
    private var pointHighlightBackgroud = UIImage()
    
    private var highlightColor = UIColor.blue {
        didSet {
            buttonHighlightBackgroud = circleImage(diameter: buttonWidth / 2, color: highlightColor)
            pointHighlightBackgroud = circleImage(diameter: Const.point.size / 2, color: highlightColor)
            
            titleLabel.textColor = highlightColor
            for point in points {
                point.layer.borderColor = highlightColor.cgColor
            }
            for button in buttons {
                button.layer.borderColor = highlightColor.cgColor
                button.setTitleColor(highlightColor, for: .normal)
                button.setBackgroundImage(buttonHighlightBackgroud, for: .highlighted)
            }
            deleteButton.layer.borderColor = highlightColor.cgColor
            deleteButton.setTitleColor(highlightColor, for: .normal)
        }
    }
    
    private var mode = MGPasscodeViewControllerMode.authenticate
    
    public init(with mode: MGPasscodeViewControllerMode, highlightColor: UIColor = .blue) {
        super.init(nibName: nil, bundle: nil)
        self.mode = mode
        self.highlightColor = highlightColor
        
        buttonNormalBackground = circleImage(diameter: buttonWidth / 2, color: .white)
        buttonHighlightBackgroud = circleImage(diameter: buttonWidth / 2, color: highlightColor)
        pointNormalBackground = circleImage(diameter: Const.point.size / 2, color: .white)
        pointHighlightBackgroud = circleImage(diameter: Const.point.size / 2, color: highlightColor)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white// UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.7)
        
        view.addSubview(titleLabel)
        view.addSubview(deleteButton)
        
        for _ in 0...3 {
            let point = UIImageView(image: circleImage(diameter: Const.point.size, color: .white))
            point.layer.cornerRadius = Const.point.size / 2
            point.layer.borderWidth = 1
            point.layer.borderColor = highlightColor.cgColor
            
            pointsView.addSubview(point)
            points.append(point)
        }
        view.addSubview(pointsView)
        
        for number in 0...9 {
            let button = UIButton(type: .custom)
            button.tag = number
            button.addTarget(self, action: #selector(enterPasscode(sender:)), for: .touchUpInside)
            
            button.setTitle("\(number)", for: .normal)
            button.setTitleColor(highlightColor, for: .normal)
            button.setTitleColor(.white, for: .highlighted)
            button.setBackgroundImage(buttonNormalBackground, for: .normal)
            button.setBackgroundImage(buttonHighlightBackgroud, for: .highlighted)

            button.layer.cornerRadius = buttonWidth / 2
            button.layer.borderWidth = 1
            button.layer.borderColor = highlightColor.cgColor

            view.addSubview(button)
            buttons.append(button)
        }
        
        createConstraints()
    }
    
    private func createConstraints() {
        
        for number in [5, 2, 4, 6, 8, 1, 3, 7, 9, 0] {
            buttons[number].snp.makeConstraints {
                $0.width.equalTo(buttonWidth)
                $0.height.equalTo(buttonWidth)
                switch number {
                case 0:
                    $0.top.equalTo(buttons[8].snp.bottom).offset(Const.button.margin)
                    $0.centerX.equalTo(buttons[5].snp.centerX)
                case 1:
                    $0.bottom.equalTo(buttons[5].snp.top).offset(-Const.button.margin)
                    $0.right.equalTo(buttons[5].snp.left).offset(-Const.button.margin)
                case 2:
                    $0.bottom.equalTo(buttons[5].snp.top).offset(-Const.button.margin)
                    $0.centerX.equalTo(buttons[5].snp.centerX)
                case 3:
                    $0.bottom.equalTo(buttons[5].snp.top).offset(-Const.button.margin)
                    $0.left.equalTo(buttons[5].snp.right).offset(Const.button.margin)
                case 4:
                    $0.right.equalTo(buttons[5].snp.left).offset(-Const.button.margin)
                    $0.centerY.equalTo(buttons[5].snp.centerY)
                case 5:
                    $0.center.equalToSuperview()
                case 6:
                    $0.centerY.equalTo(buttons[5].snp.centerY)
                    $0.left.equalTo(buttons[5].snp.right).offset(Const.button.margin)
                case 7:
                    $0.right.equalTo(buttons[5].snp.left).offset(-Const.button.margin)
                    $0.top.equalTo(buttons[5].snp.bottom).offset(Const.button.margin)
                case 8:
                    $0.top.equalTo(buttons[5].snp.bottom).offset(Const.button.margin)
                    $0.centerX.equalTo(buttons[5].snp.centerX)
                case 9:
                    $0.top.equalTo(buttons[5].snp.bottom).offset(Const.button.margin)
                    $0.left.equalTo(buttons[5].snp.right).offset(Const.button.margin)
                default:
                    break
                }
            }
        }
        
        pointsView.snp.makeConstraints {
            $0.width.equalTo(Const.point.size * CGFloat(points.count) + Const.point.horizontalMargin * CGFloat(points.count - 1))
            $0.height.equalTo(Const.point.size)
            $0.bottom.equalTo(buttons[2].snp.top).offset(-Const.point.bottomMargin)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        for (index, point) in points.enumerated() {
            point.snp.makeConstraints {
                $0.width.equalTo(Const.point.size)
                $0.height.equalTo(Const.point.size)
                $0.top.equalToSuperview()
                if index == 0 {
                    $0.left.equalToSuperview()
                } else {
                    $0.left.equalTo(points[index - 1].snp.right).offset(Const.point.horizontalMargin)
                }
            }
        }
        
        titleLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.equalTo(Const.title.height)
            $0.bottom.equalTo(points[1].snp.top).offset(-Const.title.bottomMargin)
        }
        
        deleteButton.snp.makeConstraints {
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(buttonWidth)
            $0.centerX.equalTo(buttons[9].snp.centerX)
            $0.centerY.equalTo(buttons[0].snp.centerY)
        }
    }

    private func circleImage(diameter: CGFloat, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: rect)
        
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
    
    @objc private func enterPasscode(sender: UIButton) {
        if passcodes.count == 4 {
            return
        }
        
        points[passcodes.endIndex].image = pointHighlightBackgroud
        passcodes.append(sender.tag)
        
        if passcodes.count == 4 {
            switch mode {
            case .input:
                var newPasscode = ""
                for code in passcodes {
                    newPasscode.append(String(code))
                }
                if let passcode = firstPasscode {
                    if passcode == newPasscode {
                        if case let .input(completion) = mode {
                            completion(passcode)
                        }
                        dismiss(animated: true)
                    } else {
                        alert()
                        titleLabel.text = "Not matched, enter passcode."
                        passcodes.removeAll()
                        for point in points {
                            point.image = pointNormalBackground
                        }
                        firstPasscode = nil
                    }
                } else {
                    firstPasscode = newPasscode
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.passcodes.removeAll()
                        for point in self.points {
                            point.image = self.pointNormalBackground
                        }
                        self.titleLabel.text = "Enter passcode again"
                    }
                }
            case .authenticate:
                break
            }
        }
    }
    
    @objc private func deletePasscode(sender: UIButton) {
        if passcodes.count == 0 {
            return
        }
        let index = passcodes.count - 1
        points[index].image = pointNormalBackground
        passcodes.remove(at: index)
    }
    
    private func alert() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        let tmpColor = highlightColor
        highlightColor = .red
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.highlightColor = tmpColor
        }
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        pointsView.layer.add(animation, forKey: "shake")
    }
    
}

