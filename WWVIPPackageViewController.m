//
//  WWVIPPackageViewController.m
//  WWSampleProject
//
//  Created by push on 15/10/14.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWVIPPackageViewController.h"

@interface WWVIPPackageViewController (){
    WWPublicNavtionBar *navTionBarView;
}

@end

@implementation WWVIPPackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    navTionBarView = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"购买VIP套餐" withRightBtn:NO withRightBtnPicName:@"" withRightBtnSize:CGSizeZero];
    [self.view addSubview:navTionBarView];
    
    
}

- (void)VIPPageLayout{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
