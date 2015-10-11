//
//  WWHomePageViewController.m
//  WWSampleProject
//
//  Created by ww on 15/9/9.
//  Copyright (c) 2015年 王维. All rights reserved.
//

#import "WWHomePageViewController.h"
#import "HomePageView.h"

/////////////////////
//navtionBar
#import "WWPublicNavtionBar.h"

//Mj
#import "MJRefresh.h"


@interface WWHomePageViewController ()

@end

@implementation WWHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WWPublicNavtionBar * navtionBar = [[WWPublicNavtionBar alloc]initHomePageNavtion];
    [self.view addSubview:navtionBar];
    

    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
