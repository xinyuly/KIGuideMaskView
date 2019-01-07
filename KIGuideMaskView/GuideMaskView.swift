//
//  GuideMaskView.swift
//  TestImageLoad
//
//  Created by lixinyu on 2019/1/7.
//  Copyright © 2019 lixinyu. All rights reserved.
//

import UIKit

class GuideMaskView: UIView {
    
    var maskColor: UIColor = UIColor(white: 0, alpha: 0.5) 
    var dismissWhenTouchView: Bool = true
    private var fillLayer: CAShapeLayer = CAShapeLayer()
    private var overlayPath:UIBezierPath = UIBezierPath()
    private var transparentPaths = [UIBezierPath]()
    
    deinit {
        print("\(self.classForCoder)-deinit")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        refreshmask()
    }
    
    private func layout() {
        backgroundColor = UIColor.clear
        overlayPath = UIBezierPath(rect: self.bounds)
        overlayPath.usesEvenOddFillRule = true
        fillLayer.frame = self.bounds
        layer.addSublayer(fillLayer)
        fillLayer.path = overlayPath.cgPath
        fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
        fillLayer.fillColor = maskColor.cgColor
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapDismiss))
        addGestureRecognizer(tapGesture)
    }
    
    private func refreshmask() {
        let overlayPath = UIBezierPath(rect: bounds)
        overlayPath.usesEvenOddFillRule = true
        for path in transparentPaths {
            overlayPath.append(path)
        }
        self.overlayPath = overlayPath
        self.fillLayer.frame = bounds
        self.fillLayer.path = overlayPath.cgPath
        self.fillLayer.fillColor = maskColor.cgColor
    }
    
    private func addTransparentPath(transparentPath: UIBezierPath) {
        self.overlayPath.append(transparentPath)
        self.transparentPaths.append(transparentPath)
        self.fillLayer.path = self.overlayPath.cgPath
    }
    
    @objc private func tapDismiss() {
        if !self.dismissWhenTouchView {
            return
        }
        dismiss()
    }
    
    /// 添加矩形
    func addTransparent(rect: CGRect, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        addTransparentPath(transparentPath: path)
    }
    
    /// 添加椭圆形
    func addTransparenttOvalIn(rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        addTransparentPath(transparentPath: path)
    }
    
    ///添加图片
    func addImage(image: UIImage, frame: CGRect) {
        let imageView = UIImageView(frame: frame)
        imageView.backgroundColor = UIColor.clear
        imageView.image = image
        addSubview(imageView)
    }
    
    func showMaskView(view: UIView) {
        alpha = 0
        view.addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
}
