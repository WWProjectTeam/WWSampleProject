//
//  WWUserNameModifyViewController.h
//  WWSampleProject
//
//  Created by push on 15/10/15.
//  Copyright © 2015年 王维. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModifyUserNameDelegate <NSObject>

- (void)userNameModifyDelegate:(NSString *)userName;

@end

@interface WWUserNameModifyViewController : UIViewController

@property (nonatomic,strong)id<ModifyUserNameDelegate>delegate;

@property (nonatomic,strong)NSString *nameStr;

@end
