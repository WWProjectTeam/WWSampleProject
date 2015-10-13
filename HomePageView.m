//
//  HomePageView.m
//  handheldSupply
//
//  Created by wangwei on 15/2/1.
//  Copyright (c) 2015年 王维. All rights reserved.
//

#import "HomePageView.h"

@implementation HomePageView{
    UITableView * tableProductType;
}

@synthesize bannDelegate = _bannDelegate;
@synthesize arrBannerData = _arrBannerData;
@synthesize homePageScrollView = _homePageScrollView;
@synthesize arrProductType = _arrProductType;
@synthesize delegate = _delegate;
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
        
        self.homePageScrollView = [[UIScrollView alloc]init];
        [self.homePageScrollView setFrame:CGRectMake(0, 0, MainView_Width, CGRectGetHeight(self.frame))];
        [self.homePageScrollView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.homePageScrollView];
        
        [self.homePageScrollView setShowsHorizontalScrollIndicator:NO];
        [self.homePageScrollView setShowsVerticalScrollIndicator:NO];
              
        
        //背景滑动视图范围创建--后续需要修改为活动布局
        [self.homePageScrollView setContentSize:CGSizeMake(MainView_Width, MainView_Height-IOS7_Y-92)];
        
        
        tableProductType = [[UITableView alloc]init];
        [tableProductType setFrame:CGRectMake(0,0, MainView_Width, MainView_Height-IOS7_Y-44)];
        [tableProductType setBackgroundColor:RGBCOLOR(235, 235, 235)];
        [tableProductType setDelegate:self];
        [tableProductType setDataSource:self];
        [self addSubview:tableProductType];
        
        [tableProductType setHidden:YES];
        
        
    }
    return self;
}



//scrollView滚动时委托方法
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    UIPageControl * pageControl = (UIPageControl *)[self viewWithTag:200001];
    CGFloat pageWidth = pageControl.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}


#pragma mark - view刷新
/**
 *
 *  首页banner刷新
 *
 **/
-(void)reloadDataForBanner{
    //轮播图创建
    
    //轮播图数据源准备
    NSMutableArray *viewsArray = [@[] mutableCopy];
    
    for (int i = 0; i<self.arrBannerData.count; i++) {
        
        NSDictionary * dicTemp = self.arrBannerData[i];
        
        NSDictionary * dicImageTemp = dicTemp[@"img"];
        
        NSString * strImageUrl = [NSString stringWithFormat:@"%@%@%@",dicImageTemp[@"domain"],dicImageTemp[@"path"],dicImageTemp[@"fileName"]];
        
        UIImageView * imageTemp = [[UIImageView alloc]init];
        
        
        [imageTemp sd_setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"bg_grzx@3x"]];
        
        [imageTemp setFrame:CGRectMake(0,0, 320, 115)];
        
        [viewsArray addObject:imageTemp];
    }
    
    //轮播图创建
    CycleScrollView * scroll = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, iphone_size_scale(320), iphone_size_scale(130)) animationDuration:4];
    scroll.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
    
    scroll.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    scroll.totalPagesCount = ^NSInteger(void){
        return self.arrBannerData.count;
    };
    scroll.TapActionBlock = ^(NSInteger pageIndex){
        NSDictionary * dicTemp = self.arrBannerData[pageIndex];
        [self.bannDelegate mainViewBannerSelectWithUrl:dicTemp[@"url"]];
    };
    [self.homePageScrollView addSubview:scroll];
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
@end
