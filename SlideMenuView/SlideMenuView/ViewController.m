//
//  ViewController.m
//  SlideMenuView
//
//  Created by Fangjw on 2017/12/15.
//  Copyright © 2017年 Fangjw. All rights reserved.
//

#import "ViewController.h"
#import "SlideMenuViewController.h"
#import "SlideMenuManger.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    self.title = @"消息";
    
    //左
    UIButton *headerButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 50, 50)];
    headerButton.layer.cornerRadius = headerButton.bounds.size.width/2.0f;
    headerButton.layer.masksToBounds = true;
    [headerButton setImage:[UIImage imageNamed:@"emoji-1"] forState:UIControlStateNormal];
    [headerButton addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headerButton];
    
    //右
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 100, 50, 50)];
    [moreButton setImage:[UIImage imageNamed:@"emoji-2"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(showRight) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    [self.view addSubview:moreButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)showLeft{
    [[SlideMenuManger sharedInstance]showLeftView];
//    SlideMenuViewController *vc = (SlideMenuViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    [vc showLeftViewControllerAnimated:YES];
}

-(void)showRight{
     [[SlideMenuManger sharedInstance]showRightView];
//    SlideMenuViewController *vc = (SlideMenuViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    [vc showRightViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
