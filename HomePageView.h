//
//  HomePageView.h
//  handheldSupply
//
//  Created by wangwei on 15/2/1.
//  Copyright (c) 2015年 王维. All rights reserved.
//

#import <UIKit/UIKit.h>

//自动滑动视图创建
#import "CycleScrollView.h"


@protocol WWHomePageDelegte <NSObject>

@required
-(void)setProductType:(NSDictionary *)dict;
@end


@interface HomePageView : UIView<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate>{


}

@property (nonatomic,assign) id<WWHomePageDelegte>delegate;

@property (strong) UIScrollView * homePageScrollView;
@property (strong) UICollectionView * collectProduct;
/**
 *  主页初始化
 *
 *  @return View对象
 */
-(id)initHomePageViewWithFrame:(CGRect)frame;




//轮播图数据
@property(strong) NSMutableArray * arrBannerData;





//分类数据
@property(strong) NSMutableArray * arrProductType;

/**
 *
 *  分类列表展示
 *
 **/
-(void)showProductType;

/**
 *
 *  分类列表消失
 *
 **/
-(void)dismissProductType;


//商品数据
@property (strong) NSMutableArray * arrProductItem;


////////////商品点击
@property (nonatomic , copy) void (^TapCollectActionBlock)(NSString * strProductId);


//////////轮播点击
@property (nonatomic , copy) void (^TapBannerActionBlock)(NSDictionary * dicMsg);

@end
