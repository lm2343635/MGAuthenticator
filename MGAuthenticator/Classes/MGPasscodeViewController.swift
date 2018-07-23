//
//  MGPasscodeView.swift
//  MGAuthenticator
//
//  Created by Meng Li on 2018/07/20.
//

import UIKit
import SnapKit

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
        label.textColor = .blue
        label.textAlignment = .center
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "passcode_delete"), for: .normal)

        button.layer.cornerRadius = buttonWidth / 2
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        return button
    }()
    
    private lazy var points: [UIImageView] = []
    private lazy var buttons: [UIButton] = []
    
    let buttonWidth = UIScreen.main.bounds.size.width * 0.8 / 3 - 2 * Const.button.margin

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white// UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.7)
        
        view.addSubview(titleLabel)
        view.addSubview(deleteButton)
        
        for _ in 0...3 {
            let point = UIImageView(image: circleImage(diameter: Const.point.size, color: .white))
            point.layer.cornerRadius = Const.point.size / 2
            point.layer.borderWidth = 1
            point.layer.borderColor = UIColor.blue.cgColor
            
            view.addSubview(point)
            points.append(point)
        }
        
        for number in 0...9 {
            let button = UIButton(type: .custom)
            button.setTitle("\(number)", for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.setTitleColor(.white, for: .highlighted)
            button.setBackgroundImage(circleImage(diameter: buttonWidth / 2, color: .white), for: .normal)
            button.setBackgroundImage(circleImage(diameter: buttonWidth / 2, color: .blue), for: .highlighted)

            button.layer.cornerRadius = buttonWidth / 2
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.blue.cgColor

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
        
        for index in [1, 2, 0, 3] {
            points[index].snp.makeConstraints {
                $0.width.equalTo(Const.point.size)
                $0.height.equalTo(Const.point.size)
                $0.bottom.equalTo(buttons[2].snp.top).offset(-Const.point.bottomMargin)
                switch index {
                case 0:
                    $0.right.equalTo(points[1].snp.left).offset(-Const.point.horizontalMargin)
                case 1:
                    $0.right.equalTo(buttons[2].snp.centerX).offset(-Const.point.horizontalMargin / 2)
                case 2:
                    $0.left.equalTo(buttons[2].snp.centerX).offset(Const.point.horizontalMargin / 2)
                case 3:
                    $0.left.equalTo(points[2].snp.right).offset(Const.point.horizontalMargin)
                default:
                    break
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
    
}

