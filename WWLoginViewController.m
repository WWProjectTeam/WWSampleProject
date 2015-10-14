//
//  WWLoginViewController.m
//  WWSampleProject
//
//  Created by push on 15/10/14.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWLoginViewController.h"

@interface WWLoginViewController (){
    WWPublicNavtionBar *navtionBarView;
}

@property (nonatomic,strong)UIView          *phoneBackView;         // 手机号
@property (nonatomic,strong)UITextField     *phoneTextField;

@property (nonatomic,strong)UIView          *passwordBackView;      // 动态密码
@property (nonatomic,strong)UITextField     *passwordTextField;

@property (nonatomic,strong)UIButton        *getPasswordBtn;        // 按钮
@property (nonatomic,strong)UIButton        *loginBtn;              // 登陆

@end

@implementation WWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WW_BASE_COLOR;
    
    navtionBarView = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"" withRightBtn:NO withRightBtnPicName:@"" withRightBtnSize:CGSizeZero];
    [self.view addSubview:navtionBarView];
 
    [self loginPageLayout];
}

- (void)loginPageLayout{
    self.phoneBackView = ({
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, IOS7_Y+59, MainView_Width, 40*kPercenX)];
        backView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:backView];
        backView;
    });
    // 上下线条
    UILabel *upLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.phoneBackView.width, 1)];
    upLine.backgroundColor = WWPageLineColor;
    [self.phoneBackView addSubview:upLine];
    UILabel *downLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.phoneBackView.height-1, self.phoneBackView.width, 1)];
    downLine.backgroundColor = WWPageLineColor;
    [self.phoneBackView addSubview:downLine];
    
    //icon
    UIImageView *phoneImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, (self.phoneBackView.height-20*kPercenX)/2, 20*kPercenX, 20*kPercenX)];
    phoneImage.image = [UIImage imageNamed:@"mobile-telephone"];
    [self.phoneBackView addSubview:phoneImage];
    self.phoneTextField = ({
        UITextField *phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(phoneImage.right, 0, self.phoneBackView.width-25*kPercenX, self.phoneBackView.height)];
        phoneTextField.placeholder = @"手机号码";
        phoneTextField.keyboardType = UIKeyboardTypePhonePad;
        phoneTextField.font = [UIFont systemFontOfSize:14.0f*kPercenX];
        phoneTextField.textColor = RGBCOLOR(128, 128, 128);
        [self.phoneBackView addSubview:phoneTextField];
        phoneTextField;
    });
    
    // 动态密码
    self.passwordBackView = ({
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, self.phoneBackView.bottom+15, MainView_Width-130.0f, 40*kPercenX)];
        backView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:backView];
        backView;
    });
    // 上下线条
    UILabel *passwordUpLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.passwordBackView.width, 1)];
    passwordUpLine.backgroundColor = WWPageLineColor;
    [self.passwordBackView addSubview:passwordUpLine];
    UILabel *passwordDownLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.passwordBackView.height-1, self.passwordBackView.width, 1)];
    passwordDownLine.backgroundColor = WWPageLineColor;
    [self.passwordBackView addSubview:passwordDownLine];
    //icon
    UIImageView *passwordImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, (self.passwordBackView.height-20*kPercenX)/2, 20*kPercenX, 20*kPercenX)];
    passwordImage.image = [UIImage imageNamed:@"key-tool"];
    [self.passwordBackView addSubview:passwordImage];
    // 密码
    self.passwordTextField = ({
        UITextField *phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(passwordImage.right, 0, self.passwordBackView.width-25*kPercenX, self.passwordBackView.height)];
        phoneTextField.placeholder = @"动态密码";
        phoneTextField.keyboardType = UIKeyboardTypePhonePad;
        phoneTextField.font = [UIFont systemFontOfSize:14.0f*kPercenX];
        phoneTextField.textColor = [UIColor blackColor];
        [self.passwordBackView addSubview:phoneTextField];
        phoneTextField;
    });
    
    // 按钮
    self.getPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getPasswordBtn.frame = CGRectMake(self.passwordBackView.right, self.passwordBackView.top, 130.0f, self.passwordBackView.height);
    [self.getPasswordBtn setTitle:@"获取动态密码" forState:UIControlStateNormal];
    self.getPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.getPasswordBtn setBackgroundColor:RGBCOLOR(48, 160, 201)];
    [self.getPasswordBtn setBackgroundImage:[WWUtilityClass imageWithColor:RGBCOLOR(38, 139, 176)] forState:UIControlStateHighlighted];
    [self.view addSubview:self.getPasswordBtn];
    
    // 登陆即代表同意
    UILabel *agreeLab = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, self.passwordBackView.bottom+15.0f, 84, 12)];
    agreeLab.textColor = RGBCOLOR(128, 128, 128);
    agreeLab.text = @"登陆即代表同意";
    agreeLab.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:agreeLab];
    
    //《衣优V租衣协议》
    UIButton *protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    protocolBtn.frame = CGRectMake(agreeLab.right, agreeLab.top, 108.0f, 12.0f);
    [protocolBtn setTitle:@"《衣优V租衣协议》" forState:UIControlStateNormal];
    [protocolBtn setTitleColor:RGBCOLOR(55, 94, 208) forState:UIControlStateNormal];
    protocolBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:protocolBtn];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.frame = CGRectMake(0, protocolBtn.bottom+30, MainView_Width, 44);
    [self.loginBtn setTitle:@"发送" forState:UIControlStateNormal];
    self.loginBtn.backgroundColor = WWBtnYellowColor;
    [self.loginBtn setBackgroundImage:[WWUtilityClass imageWithColor:RGBCOLOR(211, 120, 23)] forState:UIControlStateHighlighted];
//    [self.loginBtn addTarget:self action:@selector(submitFeedBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
