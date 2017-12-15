//
//  SlideMenuManger.h
//  SlideMenuView
//
//  Created by Fangjw on 2017/12/15.
//  Copyright © 2017年 Fangjw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SlideMenuManger : NSObject

/**
 *  单例
 *
 *  @return 对象
 */
+ (instancetype) sharedInstance;

-(void)addRootView:(UIViewController *)centerViewController leftViewController:(UIViewController *)leftViewController;

-(void)pushToOtherView;

-(void)pushBackView;
//从首页跳页
-(void)homePush;
//从侧滑页跳页
-(void)otherPush;
//侧滑页是否显示
-(void)showLeft;
//点击侧滑
-(void)slideView;
//侧滑页进入返回首页
-(void)complete;


@end
