//
//  ViewController.m
//  KIGuideMaskView
//
//  Created by xinyu on 2017/11/21.
//  Copyright © 2017年 xinyu. All rights reserved.
//

#import "ViewController.h"
#import "KIGuideMaskView.h"

@interface ViewController ()
@property (nonatomic, strong) KIGuideMaskView *maskView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showMaskView];
}

- (void)showMaskView {
    KIGuideMaskView *maskView = [[KIGuideMaskView alloc] init];
    maskView.dismissWhenTouchMaskView = YES;
    [maskView addTransparentRect:CGRectMake(self.view.bounds.size.width-60,self.view.bounds.size.height-40,60, 40) withRadius:0];
    [maskView addImage:[UIImage imageNamed:@"icon_guide_arrow"] withFrame:CGRectMake(self.view.bounds.size.width-80, self.view.bounds.size.height-150, 60, 100)];
    [maskView addTransparentOvalRect:CGRectMake(100, 100, 60, 60)];
    [maskView addTransparentRect:CGRectMake(30, 200, 200, 60) withRadius:10];
    
    self.maskView = maskView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [maskView showMaskViewInView:self.view];
    });
}

- (IBAction)touchAction:(id)sender {
    NSLog(@"test");
}

- (void)test {
    [self.maskView dismissMaskView];
    [self touchAction:nil];
}
@end
