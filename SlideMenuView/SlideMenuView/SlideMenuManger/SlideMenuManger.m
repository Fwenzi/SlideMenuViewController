//
//  SlideMenuManger.m
//  SlideMenuView
//
//  Created by Fangjw on 2017/12/15.
//  Copyright © 2017年 Fangjw. All rights reserved.
//

#import "SlideMenuManger.h"
#import "UIView+SnapshotView.h"

#define AppDelegate [[UIApplication sharedApplication] delegate]
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define pathDis 0.8

@interface SlideMenuManger()

@property (nonatomic, strong) UINavigationController *home;

@property (nonatomic, strong) UIViewController *centerViewController;

@property (nonatomic, strong) UIViewController *leftViewController;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizerBack;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, strong) UIView *blackView;

@property (nonatomic, strong) UIView *snapshot;
//侧滑页是否显示 默认yes
@property (nonatomic)BOOL ifShowLeft;
//从哪push的
@property (nonatomic)BOOL ifHomePush;
//侧滑页进入返回首页 默认no
@property (nonatomic)BOOL ifComplete;

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

-(void)addRootView:(UIViewController *)centerViewController leftViewController:(UIViewController *)leftViewController{
    self.centerViewController=centerViewController;
    self.leftViewController=leftViewController;
    
    _home=[[UINavigationController alloc]initWithRootViewController:self.centerViewController];
    
    [AppDelegate window].rootViewController=_home;
    
    self.leftViewController.view.frame=CGRectMake(-ScreenWidth, 0, ScreenWidth, ScreenHeight);
    
    [[AppDelegate window] addSubview:self.leftViewController.view];
    
    self.ifShowLeft=NO;
    self.ifHomePush=YES;
    self.ifComplete=NO;
    
    if (!_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanAction:)];
    }
    
    [self.centerViewController.view addGestureRecognizer:self.panGestureRecognizer];
}

-(void)addBlackView{
    if (!self.centerViewController.view) { return; }
    self.blackView=[[UIView alloc]init];
    self.blackView.frame=self.centerViewController.view.frame;
    self.blackView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.snapshot addSubview:self.blackView];
    
    if (!_panGestureRecognizerBack) {
        _panGestureRecognizerBack = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanAction:)];
    }
    
    [self.blackView addGestureRecognizer:self.panGestureRecognizerBack];
    
    if (!_tapGestureRecognizer) {
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToBack:)];
        self.tapGestureRecognizer.numberOfTapsRequired=1;
    }
    [self.blackView addGestureRecognizer:self.tapGestureRecognizer];
    
    self.blackView.alpha=0.0;
}

-(void)tapToBack:(UITapGestureRecognizer *)tap{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.leftViewController.view.frame=CGRectMake(-ScreenWidth, 0, ScreenWidth, ScreenHeight);
        self.snapshot.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.blackView.alpha=0.0;
    }completion:^(BOOL finished) {
        [self.snapshot removeFromSuperview];
        self.ifShowLeft=NO;
    }];
}

-(void)slideView{
    self.snapshot=[UIView SnapshotView:self.centerViewController.view];
    [[AppDelegate window] addSubview:self.snapshot];
    [self addBlackView];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.leftViewController.view.frame=CGRectMake(ScreenWidth*(pathDis-1), 0, ScreenWidth, ScreenHeight);
        self.snapshot.frame=CGRectMake(ScreenWidth*pathDis, 0, ScreenWidth, ScreenHeight);
        self.blackView.alpha=1.0;
    }completion:^(BOOL finished) {
        self.ifShowLeft=YES;
    }];
}

-(void)pushToOtherView{
    [UIView animateWithDuration:0.3 animations:^{
        self.snapshot.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.leftViewController.view.frame=CGRectMake(-ScreenWidth, 0, ScreenWidth, ScreenHeight);
    }completion:^(BOOL finished) {
        self.snapshot.alpha=0.0;
    }];
}

// 返回侧滑页面
-(void)pushBackView{
    if(!self.ifComplete){
        
        if(!self.ifHomePush){
            [UIView animateWithDuration:0.2 animations:^{
                self.snapshot.frame=CGRectMake(ScreenWidth*pathDis, 0, ScreenWidth, ScreenHeight);
                self.leftViewController.view.frame=CGRectMake(ScreenWidth*(pathDis-1), 0, ScreenWidth, ScreenHeight);
                self.snapshot.alpha=1.0;
            }];
        }
    }else{
        self.ifComplete=NO;
    }
}

-(void)homePush{
    self.ifHomePush=YES;
}

-(void)otherPush{
    self.ifHomePush=NO;
}

-(void)showLeft{
    self.ifShowLeft=NO;
}

-(void)complete{
    self.ifComplete=YES;
}

-(void)handlePanAction:(UIPanGestureRecognizer *)sender{
    CGPoint translation = [sender translationInView:sender.view];
    
    if (sender.state==UIGestureRecognizerStateBegan) {
        self.leftViewController.view.userInteractionEnabled=NO;
    }
    // 创建snapshot
    if (sender.state==UIGestureRecognizerStateBegan&&!self.ifShowLeft) {
        self.snapshot=[UIView SnapshotView:self.centerViewController.view];
        
        [[AppDelegate window] addSubview:self.snapshot];
        [self addBlackView];
    }
    
    if (self.snapshot.frame.origin.x<0) {
        self.snapshot=[UIView SnapshotView:self.centerViewController.view];
        
        [[AppDelegate window] addSubview:self.snapshot];
        [self addBlackView];
    }
    
    //右滑时
    if (!self.ifShowLeft) {
        
        self.snapshot.frame=CGRectMake(translation.x, 0, ScreenWidth, ScreenHeight);
        
        self.leftViewController.view.frame=CGRectMake(-ScreenWidth+translation.x, 0, ScreenWidth, ScreenHeight);
        self.blackView.alpha=translation.x/ScreenWidth*pathDis;
        
    }else{//左滑时
        self.snapshot.frame=CGRectMake(ScreenWidth*pathDis+translation.x, 0, ScreenWidth, ScreenHeight);
        
        self.leftViewController.view.frame=CGRectMake(ScreenWidth*pathDis-ScreenWidth+translation.x, 0, ScreenWidth, ScreenHeight);
        
        self.blackView.alpha=(ScreenWidth*pathDis+translation.x)/ScreenWidth*pathDis;
    }
    
    //右滑时
    if (translation.x > ScreenWidth*pathDis&&!self.ifShowLeft) {
        // 限制最右边的范围
        self.leftViewController.view.frame=CGRectMake(ScreenWidth*(pathDis-1), 0, ScreenWidth, ScreenHeight);
        self.snapshot.frame=CGRectMake(ScreenWidth*pathDis, 0, ScreenWidth, ScreenHeight);
        
        
    } else if (translation.x < 0.0&&!self.ifShowLeft) {
        // 限制最左边的范围
        self.leftViewController.view.frame=CGRectMake(-ScreenWidth, 0, ScreenWidth, ScreenHeight);
        [self.snapshot removeFromSuperview];
    }
    
    //左滑时
    if (-translation.x > ScreenWidth*pathDis&&self.ifShowLeft) {
        // 限制最右边的范围
        self.leftViewController.view.frame=CGRectMake(-ScreenWidth, 0, ScreenWidth, ScreenHeight);
        self.snapshot.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        
    } else if (translation.x > 0.0&&self.ifShowLeft) {
        // 限制最左边的范围
        self.leftViewController.view.frame=CGRectMake(ScreenWidth*(pathDis-1), 0, ScreenWidth, ScreenHeight);
        self.snapshot.frame=CGRectMake(ScreenWidth*pathDis, 0, ScreenWidth, ScreenHeight);
    }
    
    // 拖拽结束时
    if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 animations:^{
            if ((translation.x > ScreenWidth * 0.4&&!self.ifShowLeft)||(-translation.x <= ScreenWidth * 0.2&&self.ifShowLeft)) {
                sender.view.transform = CGAffineTransformIdentity;
                self.leftViewController.view.frame=CGRectMake(ScreenWidth*(pathDis-1), 0, ScreenWidth, ScreenHeight);
                self.snapshot.frame=CGRectMake(ScreenWidth*pathDis, 0, ScreenWidth, ScreenHeight);
                self.blackView.alpha=1.0;
            }
            else {
                sender.view.transform = CGAffineTransformIdentity;
                self.leftViewController.view.frame=CGRectMake(-ScreenWidth, 0, ScreenWidth, ScreenHeight);
                self.snapshot.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
                self.blackView.alpha=0.0;
            }
        }completion:^(BOOL finished) {
            if ((translation.x <= ScreenWidth * 0.4&&!self.ifShowLeft)||(-translation.x > ScreenWidth * 0.2&&self.ifShowLeft)){
                [self.snapshot removeFromSuperview];
                self.ifShowLeft=NO;
            }else{
                self.ifShowLeft=YES;
                self.leftViewController.view.userInteractionEnabled=YES;
            }
        }];
    }
}

@end
