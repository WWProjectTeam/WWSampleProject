//
//  WWAddRessTableViewCell.h
//  WWSampleProject
//
//  Created by push on 15/10/21.
//  Copyright © 2015年 王维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WWAddRessModel.h"


@interface WWAddRessTableViewCell : UITableViewCell

@property (nonatomic,strong)UIView          *backView;

- (void)initRequestAddRessData:(WWAddRessModel *)dicInfor;

@end
