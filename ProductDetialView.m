//
//  ProductDetialView.m
//  WWSampleProject
//
//  Created by ww on 15/10/14.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "ProductDetialView.h"

@implementation ProductDetialView
@synthesize scrollViewBackground = _scrollViewBackground;


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
        
        
        [self.scrollViewBackground setContentSize:CGSizeMake(MainView_Height, 1000)];

    }
    return self;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint pointTemp =scrollView.contentOffset;
    
    if (self.ScrollViewDidScroll) {
        self.ScrollViewDidScroll(pointTemp);
    }
    
    
}



@end
