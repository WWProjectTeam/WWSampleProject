//
//  WWClothesInTheUseView.m
//  WWSampleProject
//
//  Created by push on 15/10/20.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWClothesInTheUseView.h"

@interface WWClothesInTheUseView ()

@property (nonatomic,strong)UITableView         *clothesUseTableView;

@property (nonatomic,strong)NSMutableArray      *clothesUseArray;

@end

@implementation WWClothesInTheUseView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
     //   self.clothesUseTableView = [UITableView alloc]initWithFrame:CGRectMake(0, 0, <#CGFloat width#>, <#CGFloat height#>) style:<#(UITableViewStyle)#>
    }
    return self;
}

@end
