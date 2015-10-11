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




//home page banner action
@protocol mainViewBannerActionDelegate <NSObject>
@required
-(void)mainViewBannerSelectWithUrl:(NSString *)strUrl;

@end



@interface HomePageView : UIView<UIScrollViewDelegate>{


}

@property (nonatomic,assign) id<mainViewBannerActionDelegate>bannDelegate;


@property (strong) UIScrollView * homePageScrollView;
/**
 *  主页初始化
 *
 *  @return View对象
 */
-(id)initHomePageViewWithFrame:(CGRect)frame;

/**
 *  菜单按钮参数传入
 *
 *  @param array 菜单按钮参数
 */
-(void)setMenuData:(NSArray *)array;



//轮播图数据
@property(strong) NSMutableArray * arrBannerData;


/**
 *
 *  首页banner刷新
 *
 **/
-(void)reloadDataForBanner;


@end
