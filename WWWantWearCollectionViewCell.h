//
//  WWWantWearCollectionViewCell.h
//  WWSampleProject
//
//  Created by push on 15/10/20.
//  Copyright © 2015年 王维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWWantWearCollectionViewCell : UICollectionViewCell

@property (nonatomic,copy) void (^clothesDelegateBlock)();

@property (nonatomic,strong)UIImageView     *clothesImage;
@property (nonatomic,strong)UILabel         *clothesNameLab;
@property (nonatomic,strong)UIButton        *clothesDelegateBtn;

@end
