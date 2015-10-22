//
//  HomePageView.m
//  handheldSupply
//
//  Created by wangwei on 15/2/1.
//  Copyright (c) 2015年 王维. All rights reserved.
//

#import "HomePageView.h"
#import "WWPageControl.h"
#import "HomePageProductCollectionViewCell.h"
#import "WWHeaderCollectionReusableView.h"

@implementation HomePageView{
    UITableView * tableProductType;
    CycleScrollView * scrollBanner;
    WWPageControl * pageControl;
    
    
}

@synthesize arrBannerData = _arrBannerData;
@synthesize homePageScrollView = _homePageScrollView;
@synthesize arrProductType = _arrProductType;
@synthesize delegate = _delegate;
@synthesize collectProduct = _collectProduct;
/**
 *  主页初始化
 *
 *
 *  @return View对象
 */
-(id)initHomePageViewWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(frame.origin.x,frame.origin.y,frame.size.width, frame.size.height)];
    
    if (self)
    {
        
        //轮播图创建
        scrollBanner = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, iphone_size_scale(320), iphone_size_scale(200)) animationDuration:4];
        scrollBanner.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
       // [self.homePageScrollView addSubview:scrollBanner];
        
        //定义pageControl
        pageControl = [[WWPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scrollBanner.frame)-14, 320, 6)];
        [pageControl setBackgroundColor:[UIColor clearColor]];
        [pageControl setImagePageStateHighlighted:[UIImage imageNamed:@"click-on--point"]];
        [pageControl setImagePageStateNormal:[UIImage imageNamed:@"-default-point"]];
        [pageControl setHidesForSinglePage:YES];
        [scrollBanner addSubview:pageControl];


        //collectView
        UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
        self.collectProduct  =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, MainView_Width, frame.size.height) collectionViewLayout:flowLayout];
        [self.collectProduct setBackgroundColor:[UIColor whiteColor]];
        [self.collectProduct setDataSource:self];
        [self.collectProduct setDelegate:self];
        [self.collectProduct registerClass:[HomePageProductCollectionViewCell class] forCellWithReuseIdentifier:@"GradientCell"];
        [self.collectProduct setBackgroundColor:RGBCOLOR(240, 240, 240)];
        [self.collectProduct registerClass:[WWHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];
        [self.collectProduct setShowsHorizontalScrollIndicator:NO];
        [self.collectProduct setShowsVerticalScrollIndicator:NO];
        
        
        [self addSubview:self.collectProduct];

        
        tableProductType = [[UITableView alloc]init];
        [tableProductType setFrame:CGRectMake(0,0, MainView_Width, MainView_Height-IOS7_Y-44)];
        [tableProductType setBackgroundColor:RGBCOLOR(235, 235, 235)];
        [tableProductType setDelegate:self];
        [tableProductType setDataSource:self];
        [self addSubview:tableProductType];
        
        [tableProductType setHidden:YES];
        
        
        
        //轮播图创建
        scrollBanner = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, iphone_size_scale(320), iphone_size_scale(200)) animationDuration:4];
        scrollBanner.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
        // [self.homePageScrollView addSubview:scrollBanner];
        
        //定义pageControl
        pageControl = [[WWPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scrollBanner.frame)-14, 320, 6)];
        [pageControl setBackgroundColor:[UIColor clearColor]];
        [pageControl setImagePageStateHighlighted:[UIImage imageNamed:@"click-on--point"]];
        [pageControl setImagePageStateNormal:[UIImage imageNamed:@"-default-point"]];
        [pageControl setHidesForSinglePage:YES];
        [scrollBanner addSubview:pageControl];

    }
    return self;
}

#pragma mark - tableView Delegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrProductType.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    [cell setBackgroundColor:RGBCOLOR(235, 235, 235)];
    NSDictionary * dict = self.arrProductType[indexPath.row];
    cell.textLabel.text = dict[@"name"];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = self.arrProductType[indexPath.row];
    [self.delegate setProductType:dict];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return iphone_size_scale(50);
}

-(void)showProductType{
    [tableProductType reloadData];
    [tableProductType setHidden:NO];
    
}

-(void)dismissProductType{
    [tableProductType setHidden:YES];
}


#pragma mark -- UICollectionViewDataSource
-(void)reloadDataForProductItem{
    [self.collectProduct reloadData];
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrProductItem.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(MainView_Width/2, iphone_size_scale(280));
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dicTemp = self.arrProductItem[indexPath.row];
    
    if (self.TapCollectActionBlock) {
        self.TapCollectActionBlock(dicTemp[@"id"]);
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"GradientCell";
    
    NSDictionary * dicTemp = self.arrProductItem[indexPath.row];
   
    
    HomePageProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell.imgProduct sd_setImageWithURL:[NSURL URLWithString:dicTemp[@"imgurl"]] placeholderImage:[UIImage imageNamed:@"默认衣服图片"]];
    
    [cell.labelProductName setText:dicTemp[@"title"]];
    [cell.labelProductAssist setText:[NSString stringWithFormat:@"%@",dicTemp[@"favoriterCount"]]];
   // [cell.labelProductPrice setText:dicTemp[@"leaseCost"]];
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = {MainView_Width,iphone_size_scale(200)};
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    
    UICollectionReusableView *reusableview = nil;
    
    
    WWHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView" forIndexPath:indexPath];
        
    [headerView addSubview:scrollBanner];


    //轮播图数据源准备
    NSMutableArray *viewsArray = [@[] mutableCopy];
    
    for (int i = 0; i<self.arrBannerData.count; i++) {
        
        NSDictionary * dicTemp = self.arrBannerData[i];
        
        NSString * strImageUrl = dicTemp[@"img"];
        UIImageView * imageTemp = [[UIImageView alloc]init];
        
        
        [imageTemp sd_setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"bg_grzx@3x"]];
        
        [imageTemp setFrame:CGRectMake(0,0, iphone_size_scale(320), iphone_size_scale(200))];
        
        [viewsArray addObject:imageTemp];
    }
    
    pageControl.numberOfPages = self.arrBannerData.count;
    
    __weak CycleScrollView * scroll = scrollBanner;
    
    scroll.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    scroll.totalPagesCount = ^NSInteger(void){
        return  self.arrBannerData.count;
    };
    
#pragma mark - banner点击事件

    scroll.TapActionBlock = ^(NSInteger pageIndex){
        NSDictionary * dicTemp = self.arrBannerData[pageIndex];
        
        if (self.TapBannerActionBlock) {
            self.TapBannerActionBlock(dicTemp);
        }
        
    };
    scroll.ScrollActionBlock = ^(NSInteger pageIndex){
        pageControl.currentPage = pageIndex;
        
    };
    

    
    
    reusableview = headerView;

    return reusableview;
}

@end
