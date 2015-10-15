//
//  WWProductDetailViewController.m
//  WWSampleProject
//
//  Created by ww on 15/10/14.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWProductDetailViewController.h"
#import "WWPublicNavtionBar.h"
#import "ProductDetialView.h"
@interface WWProductDetailViewController ()

@end

@implementation WWProductDetailViewController
@synthesize strProductId = _strProductId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    WWPublicNavtionBar * navtionBar = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"详情" withRightBtn:NO withRightBtnPicName:nil withRightBtnSize:CGSizeZero];    
    [navtionBar setAlpha:0];
    
    [self.view addSubview:navtionBar];
    
    
    UIButton * btnBack = [[UIButton alloc]init];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"round-return"] forState:UIControlStateNormal];
    [btnBack setFrame:CGRectMake(10, IOS7_Y+5, 32, 32)];
    [self.view addSubview:btnBack];
    
    
    ProductDetialView * productView = [[ProductDetialView alloc]initProductDetialView];
    

    [self.view addSubview:productView];
    
    productView.ScrollViewDidScroll = ^(CGPoint point){
        [btnBack setAlpha:1-point.y/100];
        [navtionBar setAlpha:point.y/100];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
