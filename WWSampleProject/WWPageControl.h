//
//  WWPageControl.h
//  WWSampleProject
//
//  Created by ww on 15/10/13.
//  Copyright © 2015年 王维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWPageControl : UIPageControl
{
    UIImage *imagePageStateNormal;
    UIImage *imagePageStateHighlighted;
}
- (id)initWithFrame:(CGRect)frame;
@property (nonatomic, retain) UIImage *imagePageStateNormal;
@property (nonatomic, retain) UIImage *imagePageStateHighlighted;
@end
