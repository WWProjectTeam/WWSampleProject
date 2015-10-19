//
//  WWMyCollectionViewController.m
//  WWSampleProject
//
//  Created by push on 15/10/16.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWMyCollectionViewController.h"
#import "MyCollectionCollectionViewCell.h"
#import "HTTPClient+Other.h"
// 商品详情
#import "WWProductDetailViewController.h"

@interface WWMyCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    WWPublicNavtionBar *navtionBarView;
    int  pageIndex;
}
@property (nonatomic,strong) UICollectionView * collectProduct;
@property (nonatomic,strong) NSMutableArray * arrProduct;

@end

@implementation WWMyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrProduct = [NSMutableArray new];
    self.view.backgroundColor = WW_BASE_COLOR;
    navtionBarView = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"我的收藏" withRightBtn:NO withRightBtnPicName:nil withRightBtnSize:CGSizeZero];
    [self.view addSubview:navtionBarView];
    
    //collectView
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    self.collectProduct  =[[UICollectionView alloc]initWithFrame:CGRectMake(0, IOS7_Y+44, MainView_Width, MainView_Height-IOS7_Y-44) collectionViewLayout:flowLayout];
    [self.collectProduct setBackgroundColor:[UIColor whiteColor]];
    [self.collectProduct setDataSource:self];
    [self.collectProduct setDelegate:self];
    [self.collectProduct registerClass:[MyCollectionCollectionViewCell class] forCellWithReuseIdentifier:@"GradientCell"];
    [self.collectProduct setBackgroundColor:RGBCOLOR(240, 240, 240)];
    [self.collectProduct setShowsHorizontalScrollIndicator:NO];
    [self.collectProduct setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:self.collectProduct];
    
    [self requestCollectionCellData];
    
    [self.collectProduct.header beginRefreshing];
}

// 请求网络数据
- (void)requestCollectionCellData{
    // 添加下拉刷新控件
    
    self.collectProduct.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageIndex = 0;
        __weak __typeof(&*self)weakSelf = self;
        [FMHTTPClient GetUserCollectionIndex:pageIndex userId:[WWUtilityClass getNSUserDefaults:UserID] WithCompletion:^(WebAPIResponse *response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (response.code == WebAPIResponseCodeSuccess) {
                    NSDictionary *resultDic = [response.responseObject objectForKey:@"result"];
                    self.arrProduct = [resultDic objectForKey:@"list"];
                    
                    NSString * strIndex = [NSString stringWithFormat:@"%@",resultDic[@"next"]];
                    if ([strIndex isEqualToString:@"0"]) {
                        [self.collectProduct.footer noticeNoMoreData];
                        [self.collectProduct.footer setHidden:YES];
                    }
                    else
                    {
                        [self.collectProduct.footer setHidden:NO];
                    }

                    [weakSelf.collectProduct reloadData];
                    [self.collectProduct.header endRefreshing];
                }
            });
        }];
    }];
    // 添加上拉加载
    self.collectProduct.footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        pageIndex ++;
        __weak __typeof(&*self)weakSelf = self;
        [FMHTTPClient GetUserCollectionIndex:pageIndex userId:[WWUtilityClass getNSUserDefaults:UserID] WithCompletion:^(WebAPIResponse *response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (response.code == WebAPIResponseCodeSuccess) {
                    NSDictionary *resultDic = [response.responseObject objectForKey:@"result"];
                    [self.arrProduct addObjectsFromArray: [resultDic objectForKey:@"list"]];
                    
                    NSString * strIndex = [NSString stringWithFormat:@"%@",resultDic[@"next"]];
                    if ([strIndex isEqualToString:@"0"]) {
                        [self.collectProduct.footer noticeNoMoreData];
                        [self.collectProduct.footer setHidden:YES];
                    }
                    else
                    {
                        [self.collectProduct.footer setHidden:NO];
                    }
                    
                    [weakSelf.collectProduct reloadData];
                    [self.collectProduct.header endRefreshing];
                }
            });
        }];
    }];
}

#pragma mark -- UICollectionViewDataSource
-(void)reloadDataForProductItem{
    [self.collectProduct reloadData];
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrProduct.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(MainView_Width/2, iphone_size_scale(250));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.arrProduct.count < indexPath.row) {
        return;
    }
    NSDictionary * dicTemp = self.arrProduct[indexPath.row];
    WWProductDetailViewController * productVC = [[WWProductDetailViewController alloc]init];
    productVC.strProductId = dicTemp[@"id"];
    [self.navigationController pushViewController:productVC animated:YES];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"GradientCell";
    
    NSDictionary * dicTemp = self.arrProduct[indexPath.row];
    
    
    MyCollectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell.imgProduct sd_setImageWithURL:[NSURL URLWithString:dicTemp[@"imgurl"]] placeholderImage:[UIImage imageNamed:@"默认衣服图片"]];
    [cell.labelProductName setText:dicTemp[@"title"]];

    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
