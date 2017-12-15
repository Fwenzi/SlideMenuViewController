//
//  LeftViewController.m
//  SlideMenuView
//
//  Created by Fangjw on 2017/12/15.
//  Copyright © 2017年 Fangjw. All rights reserved.
//

#import "LeftViewController.h"
#import "SlideMenuManger.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor orangeColor];
    
    //右
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    [moreButton setImage:[UIImage imageNamed:@"emoji-2"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(showRight) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    [self.view addSubview:moreButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showRight{
    [[SlideMenuManger sharedInstance] showRightViewControllerAnimated:YES];
}


@end
