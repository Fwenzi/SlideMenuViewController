//
//  UIView+SnapshotView.m
//  CashLoan
//
//  Created by Fangjw on 17/11/13.
//  Copyright © 2017年 Fangjw. All rights reserved.
//

#import "UIView+SnapshotView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation UIView (SnapshotView)

+(UIView *)SnapshotView:(UIView *)shotView{
    UIView *snapshot=[[UIView alloc]init];
    
    snapshot.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    UIImage *image = [self imageFromView:shotView];

    UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
    [snapshot addSubview:imgView];
    return snapshot;
}

+ (UIImage *)imageFromView:(UIView *)snapView {
    
    UIGraphicsBeginImageContextWithOptions(snapView.frame.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [snapView.layer renderInContext:context];
    UIImage *targetImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return targetImage;
}


@end
