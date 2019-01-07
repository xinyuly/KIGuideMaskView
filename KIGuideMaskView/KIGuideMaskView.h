//
//  KIGuideMaskView.h
//  KIGuideMaskView
//
//  Created by xinyu on 2017/11/21.
//  Copyright © 2017年 xinyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KIGuideMaskView : UIView

//Shadow color，default  blackColor  alpha 0.5
@property (nonatomic, strong) UIColor *maskColor;

//Whether dismiss When touch MaskView, default Yes
@property (nonatomic, assign) BOOL dismissWhenTouchMaskView;

//Add a rect transparent area
- (void)addTransparentRect:(CGRect)rect withRadius:(CGFloat)radius;

//Add a circular transparent area
- (void)addTransparentOvalRect:(CGRect)rect;

//Add image
- (void)addImage:(UIImage*)image withFrame:(CGRect)frame;

//add maskView
- (void)showMaskViewInView:(UIView *)view;

- (void)dismissMaskView;

@end
