//
//  WWClothesInTheUseView.h
//  WWSampleProject
//
//  Created by push on 15/10/20.
//  Copyright © 2015年 王维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWClothesInTheUseView : UIView

@property (nonatomic,copy)void (^clothesInTheUseDidSelectItemBlock)(NSString *);
@property (nonatomic,copy)void (^clothesSelectPayBlock)(NSString *);

@property (nonatomic,strong)UITableView         *clothesUseTableView;
@property (nonatomic,assign)BOOL                myOrder;

@end
