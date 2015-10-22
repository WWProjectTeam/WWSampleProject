//
//  WWPublicWebLoadViewController.m
//  WWSampleProject
//
//  Created by ww on 15/10/22.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWPublicWebLoadViewController.h"

@interface WWPublicWebLoadViewController ()

@end

@implementation WWPublicWebLoadViewController
@synthesize strUrl = _strUrl;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    WWPublicNavtionBar * public = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"详情" withRightBtn:NO withRightBtnPicName:nil withRightBtnSize:CGSizeZero];
    [self.view addSubview:public];
    
    
    //web初始化
    UIWebView * publicWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, IOS7_Y+44, MainView_Width, MainView_Height-IOS7_Y-44)];
    
    if ([self.strUrl hasPrefix:@"w"]) {
        self.strUrl = [NSString stringWithFormat:@"http://%@",self.strUrl];
    }
    
    NSURL *url = [NSURL URLWithString:self.strUrl];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];

    
    [publicWebView setSuppressesIncrementalRendering:YES];
    [publicWebView loadRequest:request];
    
    [self.view addSubview:publicWebView];


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
