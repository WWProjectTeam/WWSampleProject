//
//  ProductDetialView.h
//  WWSampleProject
//
//  Created by ww on 15/10/14.
//  Copyright © 2015年 王维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetialView : UIView<UIScrollViewDelegate>


@property (strong) UIScrollView * scrollViewBackground;



-(id)initProductDetialView;


//scrollView滑动方法
@property (nonatomic , copy) void (^ScrollViewDidScroll)(CGPoint point);

@end
