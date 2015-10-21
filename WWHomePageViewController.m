//
//  WWHomePageViewController.m
//  WWSampleProject
//
//  Created by ww on 15/9/9.
//  Copyright (c) 2015年 王维. All rights reserved.
//

#import "WWHomePageViewController.h"
#import "HomePageView.h"
#import "HTTPClient+Other.h"
/////////////////////
//navtionBar
#import "WWPublicNavtionBar.h"

//Mj
#import "MJRefresh.h"

///////productDetial
#import "WWProductDetailViewController.h"
@interface WWHomePageViewController()<HomePageNavtionDelegate,WWHomePageDelegte>{
    HomePageView * viewHomePage;
    WWPublicNavtionBar * viewNavtionBar;
    int  pageIndex;
    NSString * strProductId;
}

@end

@implementation WWHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始id=0
    strProductId = @"0";
    
    
    viewNavtionBar = [[WWPublicNavtionBar alloc]initHomePageNavtion];
    [viewNavtionBar setHomePageNavtionDelegate:self];
    if (self.IsClothesSpressPush == YES) {
        viewNavtionBar = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"首页" withRightBtn:NO withRightBtnPicName:nil withRightBtnSize:CGSizeZero];
    }
    
    [self.view addSubview:viewNavtionBar];
    
    
    
    if (self.IsClothesSpressPush == YES) {
        viewHomePage = [[HomePageView alloc]initHomePageViewWithFrame:CGRectMake(0, IOS7_Y+44, MainView_Width, MainView_Height-IOS7_Y-44)];
    }else{
        viewHomePage = [[HomePageView alloc]initHomePageViewWithFrame:CGRectMake(0, IOS7_Y+44, MainView_Width, MainView_Height-IOS7_Y-44-49)];
    }
    [viewHomePage setDelegate:self];
    [self.view addSubview:viewHomePage];
    
    [[HTTPClient sharedHTTPClient]ProductTypeWithCompletion:^(WebAPIResponse *operation) {
        viewHomePage.arrProductType = [NSMutableArray arrayWithArray:operation.responseObject[@"result"]];
    }];
    
    
    ////////////////
    //MJ
    
    __weak UICollectionView *collectViewT = viewHomePage.collectProduct;
    
    // 添加下拉刷新控件
    
    collectViewT.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageIndex = 0;
    [[HTTPClient sharedHTTPClient]postClothesListType:[strProductId intValue] index:0 WithCompletion:^(WebAPIResponse *operation) {
        
        
        NSDictionary * dict = operation.responseObject[@"result"];
        
        viewHomePage.arrBannerData = dict[@"focus"];
        viewHomePage.arrProductItem = dict[@"list"];
        
        NSString * strIndex = [NSString stringWithFormat:@"%@",dict[@"next"]];
        if ([strIndex isEqualToString:@"0"]) {
            [collectViewT.footer noticeNoMoreData];
            [collectViewT.footer setHidden:YES];
        }
        else
        {
            [collectViewT.footer setHidden:NO];
        }
        
        [collectViewT reloadData];
        [collectViewT.header endRefreshing];

        }];
    
    }];
    
    collectViewT.footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        pageIndex++;
        [[HTTPClient sharedHTTPClient]postClothesListType:[strProductId intValue] index:pageIndex WithCompletion:^(WebAPIResponse *operation) {
            
            NSDictionary * dict = operation.responseObject[@"result"];
            
            viewHomePage.arrBannerData = dict[@"focus"];
            [viewHomePage.arrProductItem addObjectsFromArray:dict[@"list"]];
            
            NSString * strIndex = [NSString stringWithFormat:@"%@",dict[@"next"]];
            if ([strIndex isEqualToString:@"0"]) {
                [collectViewT.footer noticeNoMoreData];
                [collectViewT.footer setHidden:YES];
            }
            else
            {
                [collectViewT.footer setHidden:NO];
            }
            
            [collectViewT reloadData];
            [collectViewT.header endRefreshing];
            
        }];

    }];
    

    [collectViewT.header beginRefreshing];
    
    
    //商品点击事件
    
    __weak HomePageView * homePageTemp = viewHomePage;
    
    homePageTemp.TapCollectActionBlock = ^(NSString * ProductId){
        WWProductDetailViewController * productVC = [[WWProductDetailViewController alloc]init];
        productVC.strProductId = ProductId;
        [self.navigationController pushViewController:productVC animated:YES];
    };


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - HomePageNavtionDelegate

///打开分类选择
-(void)openProductType{
    if (viewHomePage.arrProductType.count==0) {
        [[HTTPClient sharedHTTPClient]ProductTypeWithCompletion:^(WebAPIResponse *operation) {
            viewHomePage.arrProductType = [NSMutableArray arrayWithArray:operation.responseObject[@"result"]];
            [viewHomePage showProductType];
        }];
    }
    else
    {
        [viewHomePage showProductType];
    }
    
    [self.tabBarController.tabBar setHidden:YES];
}

///关闭分类选择
-(void)closeProductType{
    [viewHomePage dismissProductType];
    
    [self.tabBarController.tabBar setHidden:NO];

}


#pragma mark - WWHomePageDelegte
///分类选择完毕---获得选择数据
-(void)setProductType:(NSDictionary *)dict{
    [self closeProductType];
    [viewNavtionBar HomePageSetTitle:dict[@"name"]];
    
    strProductId = dict[@"id"];
    

    [viewHomePage.collectProduct.header beginRefreshing];

}
@end
