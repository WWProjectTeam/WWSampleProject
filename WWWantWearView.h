//
//  WWWantWearView.h
//  WWSampleProject
//
//  Created by push on 15/10/20.
//  Copyright © 2015年 王维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWWantWearView : UIView

@property (nonatomic,strong)NSDictionary                *clothesDic;
@property (nonatomic,strong)UITableView                 *clothesTabelView;
@property (nonatomic,strong)NSMutableArray              *clothesArray;


- (id)initWithFrame:(CGRect)frame;

@end
