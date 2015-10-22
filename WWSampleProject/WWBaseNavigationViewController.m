//
//  WWBaseNavigationViewController.m
//  WWSampleProject
//
//  Created by ww on 15/9/9.
//  Copyright (c) 2015年 王维. All rights reserved.
//

#import "WWBaseNavigationViewController.h"
#import "WWBaseViewController.h"
#import "UINavigationBar+Awesome.h"
@interface WWBaseNavigationViewController ()

@end

@implementation WWBaseNavigationViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //设置导航栏颜色
        [[UINavigationBar appearance] setBarTintColor:WW_BASE_COLOR];
        
        //设置内容颜色
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        
        //设置字体属性
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
                                                               NSForegroundColorAttributeName: [UIColor whiteColor]}];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar lt_setBackgroundColor:WW_BASE_COLOR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
