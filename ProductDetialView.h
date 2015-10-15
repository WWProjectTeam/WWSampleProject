//
//  ProductDetialView.h
//  WWSampleProject
//
//  Created by ww on 15/10/14.
//  Copyright © 2015年 王维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CycleScrollView.h"
#import "WWPageControl.h"
@interface ProductDetialView : UIView<UIScrollViewDelegate>


@property (strong) UIScrollView * scrollViewBackground;



-(id)initProductDetialView;


//scrollView滑动方法
@property (nonatomic , copy) void (^ScrollViewDidScroll)(CGPoint point);

@property (strong) CycleScrollView * scrollBanner;
@property (strong) WWPageControl * pageControl;
@property (strong) UIImageView * imagePhoto;
@property (strong) UILabel * labelTitle;
@property (strong) UILabel * labelDesc;

-(void)reloadProductImgBannerWithImgData:(NSArray *)array;


@property (nonatomic ,copy) void (^TapPhotoAction)(NSInteger index);

@end
