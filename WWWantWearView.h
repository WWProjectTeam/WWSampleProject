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
@property (nonatomic,strong)UIView                      *clothesBackView;

@property (nonatomic,strong)UILabel                     *otherContentLab;
@property (nonatomic,strong)UILabel                     *rantMoneyLab;
@property (nonatomic,strong)UIButton                    *settlementBtn;

@property (nonatomic,strong)void (^wantWearOrderBtnClickBlock)(NSDictionary *dic,int days);
@property (nonatomic,strong)void (^chooseClothesBtnBlock)();
@property (nonatomic,strong)void (^wantRantTableCellSelectBlock)(NSString *);

- (id)initWithFrame:(CGRect)frame;

- (void)refreshView;

@end
