//
//  SlideMenuManger.h
//  SlideMenuView
//
//  Created by Fangjw on 2017/12/15.
//  Copyright © 2017年 Fangjw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SlideMenuMangerType) {
    SlideMenuMangerSideType = 0 ,//边缘
    SlideMenuMangerCenterType  = 1,//中心
};

@interface SlideMenuManger : NSObject
/**
 *  单例
 *  @return 对象
 */
+ (instancetype) sharedInstance;

-(void)addRootView:(UIViewController *)centerViewController   leftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController
               slideDis:(CGFloat)slideDis
         animationType:(SlideMenuMangerType)animationType;

//点击侧滑
-(void)showLeftView;

-(void)showRightView;
//显示主视图
-(void)showRootViewControllerAnimated:(BOOL)animated;
//显示左侧菜单
-(void)showLeftViewControllerAnimated:(BOOL)animated;
//显示右侧菜单
-(void)showRightViewControllerAnimated:(BOOL)animated;

@end
