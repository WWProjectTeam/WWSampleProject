//
//  WWProductDetailViewController.h
//  WWSampleProject
//
//  Created by ww on 15/10/14.
//  Copyright © 2015年 王维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WWAddToCartPopView.h"
@interface WWProductDetailViewController : UIViewController<UIWebViewDelegate>
@property (strong) NSString * strProductId;
@property (strong) NSMutableArray * arrayImgs;
@property (strong) UIButton * btnAddReply;
@property (strong) UITextField * tfReply;
@property (strong) UIView * viewAddReply;
@property (strong) WWAddToCartPopView * addCartPopView;
@property (strong) NSDictionary * dicProductMsg;
@end
