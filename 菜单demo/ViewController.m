//
//  ViewController.m
//  菜单demo
//
//  Created by 李东喜 on 15/12/16.
//  Copyright © 2015年 don. All rights reserved.
//

#import "ViewController.h"
#import "DXPresentationController.h"
@interface ViewController ()<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>

@property (nonatomic,assign) BOOL isPresent;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (IBAction)menueButtonClick {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DXPopover" bundle:nil];
    UIViewController *menueVC = [storyboard instantiateInitialViewController];

    // 自定义专场动画
    // 设置转场代理
    menueVC.transitioningDelegate = self;
    // 设置转场动画样式
    menueVC.modalPresentationStyle = UIModalPresentationCustom;
    
    // 2.2弹出菜单
    [self presentViewController:menueVC animated:YES completion:nil];
    
}

#pragma mark -------- UIViewControllerTransitioningDelegate---------
// 该方法用于返回一个负责转场动画的对象
// 可以在该对象中控制弹出视图的尺寸等
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    return [[DXPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

 // 该方法用于返回一个负责转场如何出现的对象
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.isPresent = YES;
    return self;
}

// 该方法用于返回一个负责转场如何消失的对象
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.isPresent = NO;
    return self;
}

#pragma mark -------- UIViewControllerAnimatedTransitioning---------
// 告诉系统展现和消失的动画时长
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}
// 专门用于管理modal如何展现和消失的, 无论是展现还是消失都会调用该方法
/*
 注意点: 只要我们实现了这个代理方法, 那么系统就不会再有默认的动画了
 也就是说默认的modal从下至上的移动系统不帮再帮我们添加了, 所有的动画操作都需要我们自己实现, 包括需要展现的视图也需要我们自己添加到容器视图上(containerView)
 */
// transitionContext: 所有动画需要的东西都保存在上下文中, 换而言之就是可以通过transitionContext获取到我们想要的东西

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.isPresent) { // // 展现
        // 通过ToViewKey取出的就是toVC对应的view
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        
        // 2.将需要弹出的视图添加到containerView上
        [[transitionContext containerView] addSubview:toView];
        
        // 3.执行动画
        toView.transform = CGAffineTransformMakeScale(1.0, 0);
        // 设置锚点
        toView.layer.anchorPoint = CGPointMake(0.5, 0.0);
        
        [UIView animateWithDuration:0.5 animations:^{
            toView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            // 注意: 自定转场动画, 在执行完动画之后一定要告诉系统动画执行完毕了
            [transitionContext completeTransition:YES];
        }];
        
    }else { // 消失
        // 1.拿到需要消失的视图
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        
        // 2.执行动画让视图消失
        [UIView animateWithDuration:0.4 animations:^{
            // 突然消失的原因: CGFloat不准确, 导致无法执行动画, 遇到这样的问题只需要将CGFloat的值设置为一个很小的值即可
            fromView.transform = CGAffineTransformMakeScale(1.0, 0.00001);
        } completion:^(BOOL finished) {
            // 注意: 自定转场动画, 在执行完动画之后一定要告诉系统动画执行完毕了
            [transitionContext completeTransition:YES];
        }];
        
    
    }

}



@end
