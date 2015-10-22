//
//  WWMessageDetialCellTableViewCell.h
//  WWSampleProject
//
//  Created by ww on 15/10/22.
//  Copyright © 2015年 王维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZLinkLabel.h"

@interface WWMessageDetialCellTableViewCell : UITableViewCell

@property (strong) UIImageView * imgUserPic;
@property (nonatomic,strong) KZLinkLabel * labelContent;
@property (strong) UILabel * labelTime;
@property (strong) UIImageView * backImg;
@end
