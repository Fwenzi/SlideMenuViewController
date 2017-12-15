//
//  ViewController+SlideMenuViewController.m
//  SlideMenuView
//
//  Created by Fangjw on 2017/12/15.
//  Copyright © 2017年 Fangjw. All rights reserved.
//

#import "ViewController+SlideMenuViewController.h"
#import "SlideMenuViewController.h"

@implementation UIViewController(SlideMenuViewController)

- (SlideMenuViewController *)slideMenuVC {
    UIViewController *slideMenu = self.parentViewController;
    while (slideMenu) {
        if ([slideMenu isKindOfClass:[SlideMenuViewController class]]) {
            return (SlideMenuViewController *)slideMenu;
        } else if (slideMenu.parentViewController && slideMenu.parentViewController != slideMenu) {
            slideMenu = slideMenu.parentViewController;
        } else {
            slideMenu = nil;
        }
    }
    return nil;
}

@end
