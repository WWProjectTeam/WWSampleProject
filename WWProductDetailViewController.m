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
#import "HTTPClient+Other.h"
@interface WWProductDetailViewController (){

    ProductDetialView * productView;
}

@end

@implementation WWProductDetailViewController
@synthesize strProductId = _strProductId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    productView = [[ProductDetialView alloc]initProductDetialView];
    [self.view addSubview:productView];

   
    
    
    WWPublicNavtionBar * navtionBar = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"详情" withRightBtn:NO withRightBtnPicName:nil withRightBtnSize:CGSizeZero];    
    [navtionBar setAlpha:0];
    
    [self.view addSubview:navtionBar];
    
    
    UIButton * btnBack = [[UIButton alloc]init];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"round-return"] forState:UIControlStateNormal];
    [btnBack setFrame:CGRectMake(10, IOS7_Y+5, 32, 32)];
    [btnBack addTarget:self action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    
    
    
    productView.ScrollViewDidScroll = ^(CGPoint point){
        [btnBack setAlpha:1-point.y/100];
        [navtionBar setAlpha:point.y/100];
    };
    
   
    
    
    [self productDetialUpdate];
    
}

-(void)productDetialUpdate{
    [SVProgressHUD show];
    [[HTTPClient sharedHTTPClient]ProductDetailPriductId:self.strProductId WithComletion:^(WebAPIResponse *operation) {
        NSDictionary * dict = operation.responseObject;
        
        if ([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:WWAppSuccessCode]) {
            [SVProgressHUD dismiss];
            
            NSDictionary * dicData = dict[@"result"];
            NSString * strImgUrl = dicData[@"imgurl"];
            
            NSArray *array = [strImgUrl componentsSeparatedByString:@","];
            
            /////////刷新图片
            [productView reloadProductImgBannerWithImgData:array];
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"出错,请稍后再试!"];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)btnBack{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
