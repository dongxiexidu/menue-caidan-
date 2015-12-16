//
//  DXPresentationController.m
//  菜单demo
//
//  Created by 李东喜 on 15/12/16.
//  Copyright © 2015年 don. All rights reserved.
//

#import "DXPresentationController.h"

@interface DXPresentationController ()

@property (nonatomic,strong) UIButton *button;
@end

@implementation DXPresentationController
/*
 1.如果不自定义转场modal出来的控制器会移除原有的控制器
 2.如果自定义转场modal出来的控制器不会移除原有的控制器
 3.如果不自定义转场modal出来的控制器的尺寸和屏幕一样
 4.如果自定义转场modal出来的控制器的尺寸我们可以自己在containerViewWillLayoutSubviews方法中控制
 5.containerView 非常重要, 容器视图, 所有modal出来的视图都是添加到containerView上的
 6.presentedView() 非常重要, 通过该方法能够拿到弹出的视图
 */

- (UIButton *)button
{
    if (_button == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = [UIScreen mainScreen].bounds;
        btn.backgroundColor = [UIColor clearColor];
        
        [btn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
       
        
        _button = btn;
    }
    return _button;
}

- (void)buttonClick
{
    UIViewController *Vc = [self presentedViewController];
    [Vc dismissViewControllerAnimated:YES completion:nil];
}


- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    if (self == [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController]) {
        

    };

    return self;
}

// 用于布局转场动画弹出的控件
- (void)containerViewWillLayoutSubviews
{

    UIView *presentedView = [self presentedView];
    // 设置弹出视图的尺寸
    presentedView.frame = CGRectMake(100, 145, 200, 200);
    
    // 添加蒙版
    [self.containerView insertSubview:self.button atIndex:0];
   
    
}




@end
