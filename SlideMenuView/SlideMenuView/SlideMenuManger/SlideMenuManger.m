//
//  SlideMenuManger.m
//  SlideMenuView
//
//  Created by Fangjw on 2017/12/15.
//  Copyright © 2017年 Fangjw. All rights reserved.
//

#import "SlideMenuManger.h"

#define AppDelegate [[UIApplication sharedApplication] delegate]
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface SlideMenuManger(){
     CGPoint _originalPoint;
}

@property (nonatomic, strong) UINavigationController *home;

@property (nonatomic, strong) UIViewController *baseViewController;

@property (nonatomic, strong) UIViewController *centerViewController;

@property (nonatomic, strong) UIViewController *leftViewController;

@property (nonatomic, strong) UIViewController *rightViewController;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, strong) UIView *blackView;
//滑动动画
@property (nonatomic ,assign) SlideMenuMangerType animationType;
//侧滑宽度
@property (nonatomic ,assign) CGFloat slideDis;

@end

@implementation SlideMenuManger
static  SlideMenuManger *sharedInstance = nil;

/*
 获取全局的单例
 */
+ (instancetype) sharedInstance
{
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[SlideMenuManger alloc] init];
    });
    return sharedInstance;
}

-(void)addRootView:(UIViewController *)centerViewController leftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController
               slideDis:(CGFloat)slideDis
     animationType:(SlideMenuMangerType)animationType{
    
    self.animationType=animationType;
    self.slideDis=slideDis;
    self.centerViewController=centerViewController;
    self.leftViewController=leftViewController;
    self.rightViewController=rightViewController;
    
    self.baseViewController=[[UIViewController alloc]init];
    
    [self.baseViewController addChildViewController:self.centerViewController];
    [self.baseViewController.view addSubview:self.centerViewController.view];
    [self.centerViewController didMoveToParentViewController:self.baseViewController];
  
    [self createLeftVC];
    [self createRightVC];
    
    _home=[[UINavigationController alloc]initWithRootViewController:self.baseViewController];
    
    [AppDelegate window].rootViewController=_home;
    
    if (!_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanAction:)];
    }
    [self.baseViewController.view addGestureRecognizer:self.panGestureRecognizer];
    
    [self addBlackView];
}

-(void)createLeftVC{
    if (_leftViewController) {
        _leftViewController.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _slideDis*ScreenWidth, ScreenHeight)];
        
        [_leftViewController viewDidLoad];
        [self.baseViewController addChildViewController:_leftViewController];
        [self.baseViewController.view insertSubview:_leftViewController.view atIndex:0];
        [_leftViewController didMoveToParentViewController:self.baseViewController];
    }
}

-(void)createRightVC{
    if (_rightViewController) {
        _rightViewController.view = [[UIView alloc] initWithFrame:CGRectMake((1-_slideDis)*ScreenWidth, 0, _slideDis*ScreenWidth, ScreenHeight)];
        
        [_rightViewController viewDidLoad];
        [self.baseViewController addChildViewController:_rightViewController];
        [self.baseViewController.view insertSubview:_rightViewController.view atIndex:0];
        [_rightViewController didMoveToParentViewController:self.baseViewController];
    }
}

-(void)addBlackView{
    
    self.blackView=[[UIView alloc]init];
    self.blackView.frame=self.centerViewController.view.frame;
    self.blackView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    if (!_tapGestureRecognizer) {
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToBack:)];
        self.tapGestureRecognizer.numberOfTapsRequired=1;
    }
    [self.blackView addGestureRecognizer:self.tapGestureRecognizer];
    [self.centerViewController.view addSubview:self.blackView];
    self.blackView.alpha=0.0;
    _blackView.hidden = true;
}

-(void)tapToBack:(UITapGestureRecognizer *)tap{
    [self showRootViewControllerAnimated:YES];
}

-(void)showLeftView{
    [self showLeftViewControllerAnimated:YES];
}

-(void)showRightView{
    [self showRightViewControllerAnimated:YES];
}

//显示主视图
-(void)showRootViewControllerAnimated:(BOOL)animated{
    
    [UIView animateWithDuration:[self animationDuration:animated] animations:^{
        CGRect frame = _centerViewController.view.frame;
        frame.origin.x = 0;
        _centerViewController.view.frame = frame;
        [self updateLeftMenuFrame];
        [self updateRightMenuFrame];
        _blackView.alpha = 0;
    }completion:^(BOOL finished) {
        _blackView.hidden = true;
    }];
}

//显示左侧菜单
- (void)showLeftViewControllerAnimated:(BOOL)animated {
    if (!_leftViewController) {return;}
    _blackView.hidden = false;
    [_centerViewController.view bringSubviewToFront:_blackView];
    [self.baseViewController.view sendSubviewToBack:_rightViewController.view];
    [UIView animateWithDuration:[self animationDuration:animated] animations:^{
        _centerViewController.view.center = CGPointMake(_centerViewController.view.bounds.size.width/2 + _slideDis*ScreenWidth, _centerViewController.view.center.y);
        _leftViewController.view.frame = CGRectMake(0, 0,_slideDis*ScreenWidth , ScreenHeight);
        _blackView.alpha = 1;
    }];
}

//显示右侧菜单
- (void)showRightViewControllerAnimated:(BOOL)animated {
    if (!_rightViewController) {return;}
    _blackView.hidden = false;
    [_centerViewController.view bringSubviewToFront:_blackView];
    [self.baseViewController.view sendSubviewToBack:_leftViewController.view];
    [UIView animateWithDuration:[self animationDuration:animated] animations:^{
        _centerViewController.view.center = CGPointMake(_centerViewController.view.bounds.size.width/2 - _slideDis*ScreenWidth, _centerViewController.view.center.y);
        _rightViewController.view.frame = CGRectMake((1-_slideDis)*ScreenWidth, 0, _slideDis*ScreenWidth, ScreenHeight);
        _blackView.alpha = 1;
    }];
}

-(void)handlePanAction:(UIPanGestureRecognizer *)sender{
    CGPoint translation = [sender translationInView:self.centerViewController.view];
    
    if (sender.state==UIGestureRecognizerStateBegan) {
        _originalPoint = _centerViewController.view.center;
    }
    _centerViewController.view.center = CGPointMake(_originalPoint.x + translation.x, _originalPoint.y);
    
    //判断是否设置了左右菜单
    if (!_rightViewController && CGRectGetMinX(_centerViewController.view.frame) <= 0 ) {
        _centerViewController.view.frame = self.baseViewController.view.bounds;
    }
    if (!_leftViewController && CGRectGetMinX(_centerViewController.view.frame) >= 0) {
        _centerViewController.view.frame = self.baseViewController.view.bounds;
    }
    //滑动到边缘位置后不可以继续滑动
    if (CGRectGetMinX(_centerViewController.view.frame) > _slideDis*ScreenWidth) {
        _centerViewController.view.center = CGPointMake(_centerViewController.view.bounds.size.width/2 + _slideDis*ScreenWidth, _centerViewController.view.center.y);
    }
    if (CGRectGetMaxX(_centerViewController.view.frame) < (1-_slideDis)*ScreenWidth) {
        _centerViewController.view.center = CGPointMake(_centerViewController.view.bounds.size.width/2 - _slideDis*ScreenWidth, _centerViewController.view.center.y);
    }
    //判断显示左菜单还是右菜单
    if (CGRectGetMinX(_centerViewController.view.frame) > 0) {
        //显示左菜单
        [self.baseViewController.view sendSubviewToBack:_rightViewController.view];
        //更新左菜单位置
        [self updateLeftMenuFrame];
        //更新遮罩层的透明度
        _blackView.hidden = false;
        [_centerViewController.view bringSubviewToFront:_blackView];
        _blackView.alpha = CGRectGetMinX(_centerViewController.view.frame)/(_slideDis*ScreenWidth);
    }else if (CGRectGetMinX(_centerViewController.view.frame) < 0){
        //显示右菜单
        [self.baseViewController.view sendSubviewToBack:_leftViewController.view];
        //更新右侧菜单的位置
        [self updateRightMenuFrame];
        //更新遮罩层的透明度
        _blackView.hidden = false;
        [_centerViewController.view bringSubviewToFront:_blackView];
        _blackView.alpha = (CGRectGetMaxX(self.baseViewController.view.frame) - CGRectGetMaxX(_centerViewController.view.frame))/(_slideDis*ScreenWidth);
    }
   
    // 拖拽结束时
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (CGRectGetMinX(_centerViewController.view.frame) > _slideDis*ScreenWidth/2) {
            [self showLeftViewControllerAnimated:true];
        }else if (CGRectGetMaxX(_centerViewController.view.frame) < _slideDis*ScreenWidth/2 + (1-_slideDis)*ScreenWidth){
            [self showRightViewControllerAnimated:true];
        }else{
            [self showRootViewControllerAnimated:true];
        }
    }
}

#pragma mark --- 更新菜单位置
//更新左侧菜单位置
- (void)updateLeftMenuFrame {
    if (!self.animationType) {
        _leftViewController.view.center = CGPointMake(CGRectGetMinX(_centerViewController.view.frame)-CGRectGetWidth(_centerViewController.view.frame)/2+ScreenWidth*(1-_slideDis)/2, _leftViewController.view.center.y);
    }else{
        _leftViewController.view.center = CGPointMake(CGRectGetMinX(_centerViewController.view.frame)/2, _leftViewController.view.center.y);
    }
}

//更新右侧菜单位置
- (void)updateRightMenuFrame {
    if (!self.animationType) {
        _rightViewController.view.center = CGPointMake(ScreenWidth + CGRectGetMaxX(_centerViewController.view.frame)-CGRectGetWidth(_centerViewController.view.frame)/2-ScreenWidth*(1-_slideDis)/2, _rightViewController.view.center.y);
    }else{
        _rightViewController.view.center = CGPointMake((ScreenWidth + CGRectGetMaxX(_centerViewController.view.frame))/2, _rightViewController.view.center.y);
    }
}

- (CGFloat)animationDuration:(BOOL)animated {
    return animated ? 0.2 : 0;
}

@end
