//
//  WWGuidePageViewController.m
//  WWSampleProject
//
//  Created by ww on 15/10/22.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWGuidePageViewController.h"

@interface WWGuidePageViewController ()

@end

@implementation WWGuidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WWPublicNavtionBar * public = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"引导" withRightBtn:NO withRightBtnPicName:nil withRightBtnSize:CGSizeZero];
    [self.view addSubview:public];
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
