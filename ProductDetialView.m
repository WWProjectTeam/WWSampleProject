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
@synthesize imagePhoto = _imagePhoto;
-(id)initProductDetialView{
    self = [super initWithFrame:CGRectMake(0,0,MainView_Width,MainView_Height)];
    
    if (self)
    {
        self.scrollViewBackground = [[UIScrollView alloc]init];
        [self.scrollViewBackground setFrame:CGRectMake(0, -20, self.frame.size.width,self.frame.size.height-49)];
        [self.scrollViewBackground setShowsHorizontalScrollIndicator:NO];
        [self.scrollViewBackground setShowsVerticalScrollIndicator:NO];
        [self.scrollViewBackground setDelegate:self];
        self.scrollViewBackground.backgroundColor = [UIColor redColor];
        [self.scrollViewBackground setUserInteractionEnabled:YES];
        [self addSubview:self.scrollViewBackground];
        
        
        [self.scrollViewBackground setContentSize:CGSizeMake(MainView_Width, 1000)];

        
        //详情图
        self.labelTitle  = [[UILabel alloc]init];
        [self.labelTitle setFrame:CGRectMake(0, iphone_size_scale(310), MainView_Width, 30)];
        [self.labelTitle setFont:[UIFont fontWithName:@"Heiti SC Medium" size:15]];
        [self.labelTitle setNumberOfLines:0];
        [self.labelTitle setTextAlignment:NSTextAlignmentLeft];
        
        //判断内容长度是否大于Label内容宽度，如果不大于，则设置内容宽度为行宽（内容如果小于行宽，Label长度太短，如果Label有背景颜色，将影响布局效果）

        [self.scrollViewBackground addSubview:self.labelTitle];
        
       
        
        

    }
    return self;
}


-(void)reloadProductImgBannerWithImgData:(NSArray *)array{
    
    if (array.count==1) {
        NSString * strImageUrl = array[0];
        self.imagePhoto = [[UIImageView alloc]init];
        
        [self.imagePhoto sd_setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"bg_yfxq"]];
        [self.imagePhoto setFrame:CGRectMake(0,0, iphone_size_scale(320), iphone_size_scale(300))];
        UITapGestureRecognizer * tapImg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapImg)];
        [self.imagePhoto addGestureRecognizer:tapImg];
        [self.imagePhoto setUserInteractionEnabled:YES];
        [self.imagePhoto setContentMode:UIViewContentModeScaleAspectFill];
        self.imagePhoto.clipsToBounds = YES;
        [self.scrollViewBackground addSubview:self.imagePhoto];

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
            if (self.TapPhotoAction) {
                self.TapPhotoAction(pageIndex);
            }
            
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


-(void)TapImg{
    
    if (self.TapPhotoAction) {
        self.TapPhotoAction(0);
    }
}


@end
