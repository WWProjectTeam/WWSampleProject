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
#import "DZNSegmentedControl.h"

@interface ProductDetialView : UIView<UIScrollViewDelegate,UIAlertViewDelegate,DZNSegmentedControlDelegate>{
    UIButton * btnFav;
    UIButton * btnClo;
    
    
    UIImageView * ClotheSpressNum;
    UILabel * labelSpressNum;
    
    
    
    UIWebView * webSection1;
}


@property (strong) UIScrollView * scrollViewBackground;



-(id)initProductDetialView;


//scrollView滑动方法
@property (nonatomic , copy) void (^ScrollViewDidScroll)(CGPoint point);

@property (strong) CycleScrollView * scrollBanner;
@property (strong) WWPageControl * pageControl;
@property (strong) UIImageView * imagePhoto;
@property (strong) UILabel * labelTitle;
@property (strong) UILabel * labelDesc;
@property (strong) UIImageView * imgGrey;


-(void)reloadProductImgBannerWithImgData:(NSArray *)array;


@property (nonatomic ,copy) void (^TapPhotoAction)(NSInteger index);

///////////////////footer
@property (nonatomic ,copy) void (^AddToCollection)();
@property (nonatomic ,copy) void (^TapClotheSpress)();
@property (nonatomic ,copy) void (^AddToCart)();



/////////////////setAction
-(void)setCollectionStatu:(BOOL)statu;

-(void)setClotheSpressNum:(NSInteger)num;



//////////////////DZN
@property (nonatomic, strong) DZNSegmentedControl *control;
@property (nonatomic, strong) NSArray *menuItems;


@end
