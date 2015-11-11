//
//  WWMyOrderViewController.m
//  WWSampleProject
//
//  Created by push on 15/11/4.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWMyOrderViewController.h"
#import "WWClothesInTheUseView.h"
#import "WWMyOrderDetailViewController.h"

@interface WWMyOrderViewController ()<UIAlertViewDelegate>{
    WWPublicNavtionBar *navtionBarView;
    WWClothesInTheUseView *useVC;
}

@end

@implementation WWMyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WW_BASE_COLOR;
    
    __weak __typeof(&*self)weakSelf = self;
    navtionBarView = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"我的订单" withRightBtn:NO withRightBtnPicName:nil withRightBtnSize:CGSizeZero];
    navtionBarView.TapLeftButton = ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    [self.view addSubview:navtionBarView];
    
    UILabel *navLine = [[UILabel alloc]initWithFrame:CGRectMake(0, navtionBarView.height-0.5f, MainView_Width, 0.5f)];
    navLine.backgroundColor = WW_BASE_COLOR;
    [navtionBarView addSubview:navLine];
    
#pragma mark ---- 使用中
    
    useVC = [[WWClothesInTheUseView alloc]initWithFrame:CGRectMake(0, IOS7_Y+44, MainView_Width, MainView_Height-IOS7_Y-44)];
    // 点击item
    
    useVC.clothesInTheUseDidSelectItemBlock = ^(NSString *clothesId){
        WWMyOrderDetailViewController *orderDetailVC = [[WWMyOrderDetailViewController alloc]init];
        orderDetailVC.orderId = clothesId;
        [weakSelf.navigationController pushViewController:orderDetailVC animated:YES];
    };
    
    useVC.myOrder = NO;
    [self.view addSubview:useVC];
}

- (void)viewWillAppear:(BOOL)animated{
    [useVC.clothesUseTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
