//
//  WWUserNameModifyViewController.h
//  WWSampleProject
//
//  Created by push on 15/10/15.
//  Copyright © 2015年 王维. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WWUserNameModifyViewController : UIViewController

@property (nonatomic,copy)void(^userNameStr)(NSString *name);

@end
