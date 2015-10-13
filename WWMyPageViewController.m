//
//  WWMyPageViewController.m
//  WWSampleProject
//
//  Created by push on 15/10/13.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWMyPageViewController.h"
#import "HTTPClient+Other.h"
/////////////////////
//navtionBar
#import "WWPublicNavtionBar.h"

@interface WWMyPageViewController ()
{
    WWPublicNavtionBar * viewNavtionBar;
}

@end

@implementation WWMyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 导航
    viewNavtionBar = [[WWPublicNavtionBar alloc]initWithLeftBtn:NO withTitle:@"我的" withRightBtn:NO withRightBtnPicName:nil withRightBtnSize:CGSizeZero];
    [self.view addSubview:viewNavtionBar];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
