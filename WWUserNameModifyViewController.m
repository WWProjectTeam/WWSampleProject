//
//  WWUserNameModifyViewController.m
//  WWSampleProject
//
//  Created by push on 15/10/15.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWUserNameModifyViewController.h"

@interface WWUserNameModifyViewController ()
{
    WWPublicNavtionBar *navtionBarView;
}

@property (nonatomic,strong) UITextField *nameTextField;

@end

@implementation WWUserNameModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WW_BASE_COLOR;
    
    navtionBarView = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"修改昵称" withRightBtn:NO withRightBtnPicName:nil withRightBtnSize:CGSizeZero];
    __weak __typeof(&*self)weakSelf = self;
    navtionBarView.TapLeftButton = ^{
        [weakSelf.delegate userNameModifyDelegate:weakSelf.nameTextField.text];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:navtionBarView];
    
    UIView *backName = [[UIView alloc]initWithFrame:CGRectMake(0, IOS7_Y+50, MainView_Width, 44*kPercenX)];
    backName.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backName];
    // 上下线条
    UILabel *nameUpLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, backName.width, 1)];
    nameUpLine.backgroundColor = WWPageLineColor;
    [backName addSubview:nameUpLine];
    UILabel *nameDownLine = [[UILabel alloc]initWithFrame:CGRectMake(0, backName.height-1, backName.width, 1)];
    nameDownLine.backgroundColor = WWPageLineColor;
    [backName addSubview:nameDownLine];
    
    self.nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, backName.width-15.0f, backName.height)];
    self.nameTextField.text = self.nameStr;
    self.nameTextField.textColor = WWContentTextColor;
    self.nameTextField.font = [UIFont systemFontOfSize:13.0f*kPercenX];
    self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.nameTextField becomeFirstResponder];
    [backName addSubview:self.nameTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
