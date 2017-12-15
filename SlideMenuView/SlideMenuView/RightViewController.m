//
//  RightViewController.m
//  SlideMenuView
//
//  Created by Fangjw on 2017/12/15.
//  Copyright © 2017年 Fangjw. All rights reserved.
//

#import "RightViewController.h"
#import "SlideMenuManger.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blueColor];
    
    //左
    UIButton *headerButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 50, 50)];
    headerButton.layer.cornerRadius = headerButton.bounds.size.width/2.0f;
    headerButton.layer.masksToBounds = true;
    [headerButton setImage:[UIImage imageNamed:@"emoji-1"] forState:UIControlStateNormal];
    [headerButton addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headerButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showLeft{
    [[SlideMenuManger sharedInstance]showLeftViewControllerAnimated:YES];
}

@end
