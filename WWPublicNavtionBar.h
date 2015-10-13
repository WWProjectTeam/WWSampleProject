//
//  WWPublicNavtionBar.h
//  WWExtension
//
//  Created by ww on 15/8/20.
//  Copyright (c) 2015年 王维. All rights reserved.
//
//
//  本类主要用于项目公共V层，通过API形式初始化，配合委托协议进行事件响应
//
#import <UIKit/UIKit.h>

#pragma mark - 通用导航条
@protocol publicNavtionDelegate <NSObject>//协议声明
//必选方法
@required
-(void)rightBtnSelect;

@optional
-(void)leftBtnSelect;


@end

#pragma mark - 首页特殊导航条
@protocol HomePageNavtionDelegate <NSObject>//协议声明
//必选方法
@required
-(void)rightBtnSelect;
-(void)openProductType;
-(void)closeProductType;
@end


@interface WWPublicNavtionBar : UIView

@property (nonatomic,assign) id<publicNavtionDelegate>navtionBarDelegate;
@property (nonatomic,assign) id<HomePageNavtionDelegate>HomePageNavtionDelegate;

#pragma mark - 通用导航条创建
//通用初始化方法
-(id)initWithLeftBtn:(BOOL)leftBtnControl
           withTitle:(NSString *)strTitle
        withRightBtn:(BOOL)rightBtnControl
 withRightBtnPicName:(NSString *)picName
    withRightBtnSize:(CGSize)picSize;

#pragma mark - 首页特殊导航条创建
-(id)initHomePageNavtion;

//首页设置小红点数
-(void)HomePageSetMsgNum:(NSInteger)Num;

//首页设置标题
-(void)HomePageSetTitle:(NSString *)strTitle;


@end
