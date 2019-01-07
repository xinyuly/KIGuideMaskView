//
//  KIGuideMaskView.m
//  KIGuideMaskView
//
//  Created by xinyu on 2017/11/21.
//  Copyright © 2017年 xinyu. All rights reserved.
//

#import "KIGuideMaskView.h"

@interface KIGuideMaskView ()
@property (nonatomic, weak)   CAShapeLayer   *fillLayer;
@property (nonatomic, strong) UIBezierPath   *overlayPath;
@property (nonatomic, strong) NSMutableArray *transparentPaths;
@end

@implementation KIGuideMaskView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: [UIScreen mainScreen].bounds];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.backgroundColor = [UIColor clearColor];
    self.maskColor       = [UIColor colorWithWhite:0 alpha:0.5];
    self.fillLayer.path      = self.overlayPath.CGPath;
    self.fillLayer.fillRule  = kCAFillRuleEvenOdd;
    self.fillLayer.fillColor = self.maskColor.CGColor;
    self.dismissWhenTouchMaskView = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDismissMaskView)];
    [self addGestureRecognizer:tapGesture];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self refreshMask];
}

- (void)refreshMask {
    UIBezierPath *overlayPath = [self generateOverlayPath];
    for (UIBezierPath *transparentPath in self.transparentPaths) {
        [overlayPath appendPath:transparentPath];
    }
    
    self.overlayPath = overlayPath;
    self.fillLayer.frame     = self.bounds;
    self.fillLayer.path      = self.overlayPath.CGPath;
    self.fillLayer.fillColor = self.maskColor.CGColor;
}

- (UIBezierPath *)generateOverlayPath {
    UIBezierPath *overlayPath = [UIBezierPath bezierPathWithRect:self.bounds];
    [overlayPath setUsesEvenOddFillRule:YES];
    return overlayPath;
}

- (void)addTransparentPath:(UIBezierPath *)transparentPath {
    [self.overlayPath appendPath:transparentPath];
    [self.transparentPaths addObject:transparentPath];
    self.fillLayer.path = self.overlayPath.CGPath;
}

#pragma mark - Methods
- (void)addTransparentRect:(CGRect)rect withRadius:(CGFloat)radius{
    UIBezierPath *transparentPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    [self addTransparentPath:transparentPath];
    
}

- (void)addTransparentOvalRect:(CGRect)rect {
    UIBezierPath *transparentPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    [self addTransparentPath:transparentPath];
}

- (void)addImage:(UIImage*)image withFrame:(CGRect)frame{
    UIImageView * imageView   = [[UIImageView alloc]initWithFrame:frame];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image           = image;
    [self addSubview:imageView];
}

- (void)showMaskViewInView:(UIView *)view{
    self.alpha = 0;
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)tapDismissMaskView {
    if (!self.dismissWhenTouchMaskView) {
        return;
    }
    [self dismissMaskView];
}

- (void)dismissMaskView{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }]; 
}

#pragma mark - Getter Methods
- (UIBezierPath *)overlayPath {
    if (!_overlayPath) {
        _overlayPath = [self generateOverlayPath];
    }
    return _overlayPath;
}

- (CAShapeLayer *)fillLayer {
    if (!_fillLayer) {
        CAShapeLayer *fillLayer = [CAShapeLayer layer];
        fillLayer.frame = self.bounds;
        [self.layer addSublayer:fillLayer];
        _fillLayer = fillLayer;
    }
    return _fillLayer;
}

- (NSMutableArray *)transparentPaths {
    if (!_transparentPaths) {
        _transparentPaths = [NSMutableArray array];
    }
    return _transparentPaths;
}


- (void)setMaskColor:(UIColor *)maskColor {
    _maskColor = maskColor;
    
    [self refreshMask];
}

@end
