//
//  ProductDetialView.m
//  WWSampleProject
//
//  Created by ww on 15/10/14.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "ProductDetialView.h"
#import "WWPageControl.h"
@implementation ProductDetialView
@synthesize scrollViewBackground = _scrollViewBackground;
@synthesize scrollBanner = _scrollBanner;
@synthesize pageControl = _pageControl;

-(id)initProductDetialView{
    self = [super initWithFrame:CGRectMake(0,0,MainView_Width,MainView_Height)];
    
    if (self)
    {
        self.scrollViewBackground = [[UIScrollView alloc]init];
        [self.scrollViewBackground setFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height-49)];
        [self.scrollViewBackground setShowsHorizontalScrollIndicator:NO];
        [self.scrollViewBackground setShowsVerticalScrollIndicator:NO];
        [self.scrollViewBackground setDelegate:self];
        [self addSubview:self.scrollViewBackground];
        
        
        [self.scrollViewBackground setContentSize:CGSizeMake(MainView_Width, 1000)];

        
        //详情图
        
       
        
        

    }
    return self;
}


-(void)reloadProductImgBannerWithImgData:(NSArray *)array{
    
    if (array.count==1) {
        NSString * strImageUrl = array[0];
        UIImageView * imageTemp = [[UIImageView alloc]init];
        
        [imageTemp setContentMode:UIViewContentModeScaleAspectFill];
        [imageTemp sd_setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"bg_yfxq"]];
        [imageTemp setFrame:CGRectMake(0,0, iphone_size_scale(320), iphone_size_scale(300))];
        [self.scrollViewBackground addSubview:imageTemp];

    }
    else
    {
        //轮播图创建
        self.scrollBanner = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, iphone_size_scale(320), iphone_size_scale(300)) animationDuration:4];
        self.scrollBanner.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.1];
        [self.scrollViewBackground addSubview:self.scrollBanner];
        
        //定义pageControl
        self.pageControl = [[WWPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollBanner.frame)-14, 320, 6)];
        
        [self.pageControl setBackgroundColor:[UIColor clearColor]];
        [self.pageControl setImagePageStateHighlighted:[UIImage imageNamed:@"click-on--point"]];
        [self.pageControl setImagePageStateNormal:[UIImage imageNamed:@"-default-point"]];
        [self.pageControl setHidesForSinglePage:YES];
        [self.scrollBanner addSubview:self.pageControl];
        //轮播图数据源准备
        NSMutableArray *viewsArray = [@[] mutableCopy];
        
        for (int i = 0; i<array.count; i++) {
            NSString * strImageUrl = array[i];
            UIImageView * imageTemp = [[UIImageView alloc]init];
            
            [imageTemp sd_setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"bg_yfxq"]];
            [imageTemp setFrame:CGRectMake(0,0, iphone_size_scale(320), iphone_size_scale(300))];
            [imageTemp setContentMode:UIViewContentModeScaleAspectFill];
            [viewsArray addObject:imageTemp];
        }
        
        
        
        _pageControl.numberOfPages = array.count;
        __weak CycleScrollView * scroll = self.scrollBanner;
        
        if (array.count==1) {
            scroll.totalPagesCount = ^NSInteger(void){
                return  1;
            };
            
            scroll.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
                return viewsArray[0];
            };
        }
        else
        {
            scroll.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
                return viewsArray[pageIndex];
            };
            scroll.totalPagesCount = ^NSInteger(void){
                return  array.count;
            };
            
        }
        
        
        
        
#pragma mark - banner点击事件
        
        scroll.TapActionBlock = ^(NSInteger pageIndex){
            
        };
        scroll.ScrollActionBlock = ^(NSInteger pageIndex){
            _pageControl.currentPage = pageIndex;
        };
        

    }
    
   
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint pointTemp =scrollView.contentOffset;
    
    if (self.ScrollViewDidScroll) {
        self.ScrollViewDidScroll(pointTemp);
    }
    
    
}



@end
