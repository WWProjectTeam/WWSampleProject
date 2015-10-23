//
//  WWLoginViewController.m
//  WWSampleProject
//
//  Created by push on 15/10/14.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWLoginViewController.h"
#import "HTTPClient+Other.h"

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
    
    navtionBarView = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"登陆" withRightBtn:NO withRightBtnPicName:@"" withRightBtnSize:CGSizeZero];
    __weak __typeof(&*self)weakSelf = self;
    navtionBarView.TapLeftButton = ^{
        AppDelegate * appdelegate = (AppDelegate * )[UIApplication sharedApplication].delegate;
        [appdelegate.tabBarController setSelectedIndex:0];
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            if (weakSelf.UserLoginStatu) {
                weakSelf.UserLoginStatu(NO);
            }
            
        }];
    };
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
    [self.getPasswordBtn addTarget:self action:@selector(getDynamicPasswordRequest) forControlEvents:UIControlEventTouchUpInside];
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
    [self.loginBtn addTarget:self action:@selector(sendLoginRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
    
}

// 请求动态密码
- (void)getDynamicPasswordRequest{
    [self.passwordTextField becomeFirstResponder];
    if ([self.phoneTextField.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
        return;
    }else{
        if (![WWUtilityClass validateMobile:self.phoneTextField.text]) {
            [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
            return;
        }
    }
    
    [FMHTTPClient GetDynamicPasswordAndPhone:self.phoneTextField.text WithCompletion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response.code == WebAPIResponseCodeSuccess) {
                [SVProgressHUD showSuccessWithStatus:@"动态密码已发送，请注意查收"];
            }
        });
    }];
}

- (void)sendLoginRequest{
    if ([self.phoneTextField.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
        return;
    }
    if ([self.passwordTextField.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请输入密码"];
        return;
    }
    [SVProgressHUD show];
    [FMHTTPClient PostRequsetLoginNeedPhone:self.phoneTextField.text AndPassword:self.passwordTextField.text WithCompletion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response.code == WebAPIResponseCodeSuccess) {
                [SVProgressHUD dismiss];
                NSDictionary *result = [response.responseObject objectForKey:@"result"];
                //保存用户信息--id、名称、头像
                g_UserId = StringForKeyInUnserializedJSONDic(result, @"id");
                g_UserHeadImage = StringForKeyInUnserializedJSONDic(result, @"faceUrl");
                g_UserName = StringForKeyInUnserializedJSONDic(result, @"userName");
                // 将用户信息保存本地
                [WWUtilityClass saveNSUserDefaults:UserID value:StringForKeyInUnserializedJSONDic(result, @"id")];
                [WWUtilityClass saveNSUserDefaults:UserImageURL value:StringForKeyInUnserializedJSONDic(result, @"faceUrl")];
                [WWUtilityClass saveNSUserDefaults:UserName value:StringForKeyInUnserializedJSONDic(result, @"userName")];
                [WWUtilityClass saveNSUserDefaults:UserPhone value:StringForKeyInUnserializedJSONDic(result, @"mobile")];
                NSDictionary *vipDic = [result objectForKey:@"vip"];
                [WWUtilityClass saveNSUserDefaults:UserVipID value:[vipDic objectForKey:@"state"]];
                if ([[vipDic objectForKey:@"state"] intValue] == 1) {
                    [WWUtilityClass saveNSUserDefaults:UserVipEndTime value:[vipDic objectForKey:@"endTime"]];
                }
                [SVProgressHUD showErrorWithStatus:@"登陆成功"];
                // 通知--刷新个人信息
                [[NSNotificationCenter defaultCenter] postNotificationName:WWRefreshUserInformation object:nil];
                // 返回上级
                [self dismissViewControllerAnimated:YES completion:^{
                    if (self.UserLoginStatu) {
                        self.UserLoginStatu(YES);
                    }
                }];
            }else{
                sleep(60);
                [SVProgressHUD showErrorWithStatus:@"登陆失败"];
                [SVProgressHUD dismiss];
            }
        });
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
