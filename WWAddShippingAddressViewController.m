//
//  WWAddShippingAddressViewController.m
//  WWSampleProject
//
//  Created by push on 15/10/21.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWAddShippingAddressViewController.h"
#import "HTTPClient+Other.h"

@interface WWAddShippingAddressViewController ()<UITextViewDelegate>{
    WWPublicNavtionBar  *navtionBarView;
}

@property (nonatomic,strong)UITextField *nameTextFiled;
@property (nonatomic,strong)UITextField *regionTextFiled;
@property (nonatomic,strong)UITextView  *detailAddressTextView;
@property (nonatomic,strong)UILabel     *placeholder;
@property (nonatomic,strong)UILabel     *phoneLab;

@end

@implementation WWAddShippingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WW_BASE_COLOR;
    
    navtionBarView = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"添加收货地址" withRightBtn:NO withRightBtnPicName:nil withRightBtnSize:CGSizeZero];
    [self.view addSubview:navtionBarView];
    
    // 收货人姓名
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, IOS7_Y+44, MainView_Width, 40*kPercenX)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    UILabel *upLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainView_Width, 0.5f)];
    upLine.backgroundColor = WWPageLineColor;
    [backView addSubview:upLine];
    self.nameTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, MainView_Width-20, 40*kPercenX)];
    self.nameTextFiled.placeholder = @"收货人姓名";
    self.nameTextFiled.font = font_size(14);
    self.nameTextFiled.textColor = WWSubTitleTextColor;
    [backView addSubview:self.nameTextFiled];
    
    // 收货人手机号
    UIView *regionView = [[UIView alloc]initWithFrame:CGRectMake(0, backView.bottom, MainView_Width, iphone_size_scale(40))];
    regionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:regionView];
    
    UILabel *regionLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainView_Width, 0.5f)];
    regionLine.backgroundColor = WWPageLineColor;
    [regionView addSubview:regionLine];
    
    self.regionTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, MainView_Width-20, 40*kPercenX)];
        self.regionTextFiled.placeholder = @"手机号码";
    self.regionTextFiled.text = [WWUtilityClass getNSUserDefaults:UserPhone];
    self.regionTextFiled.font = font_size(14);
    self.regionTextFiled.textColor = WWContentTextColor;
    [regionView addSubview:self.regionTextFiled];
    
    // 省、市、县
    UIView *phoneView = [[UIView alloc]initWithFrame:CGRectMake(0, regionView.bottom, MainView_Width, iphone_size_scale(40))];
    phoneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:phoneView];
    
    UILabel *phoneLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainView_Width, 0.5f)];
    phoneLine.backgroundColor = WWPageLineColor;
    [phoneView addSubview:phoneLine];
    self.phoneLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, MainView_Width-20, phoneView.height)];
    self.phoneLab.text = @"北京市 （目前只服务北京市区域）";
    self.phoneLab.font = font_size(14);
    self.phoneLab.textColor = RGBCOLOR(224, 162, 28);
    [phoneView addSubview:self.phoneLab];
    
    // 详情地址
    UIView *detailView = [[UIView alloc]initWithFrame:CGRectMake(0, phoneView.bottom, MainView_Width, iphone_size_scale(135))];
    detailView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:detailView];
    
    UILabel *detailLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainView_Width, 0.5f)];
    detailLine.backgroundColor = WWPageLineColor;
    [detailView addSubview:detailLine];
    
    self.detailAddressTextView = [[UITextView alloc]initWithFrame:CGRectMake(7, 10, MainView_Width-14, 125*kPercenX)];
    self.detailAddressTextView.font = font_size(14);
    self.detailAddressTextView.textColor = WWSubTitleTextColor;
    self.detailAddressTextView.delegate = self;
    self.detailAddressTextView.returnKeyType = UIReturnKeyDone;
    [detailView addSubview:self.detailAddressTextView];

    self.placeholder = [[UILabel alloc]initWithFrame:CGRectMake(4, 10, 100, 14*kPercenX)];
    self.placeholder.text = @"详细地址";
    self.placeholder.textColor = RGBCOLOR(196, 196, 196);
    self.placeholder.font = font_size(14);
    [self.detailAddressTextView addSubview:self.placeholder];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, detailView.bottom+20, MainView_Width, 44);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.backgroundColor = WWBtnYellowColor;
    [saveBtn setBackgroundImage:[WWUtilityClass imageWithColor:RGBCOLOR(211, 120, 23)] forState:UIControlStateHighlighted];
    [saveBtn addTarget:self action:@selector(saveBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    ////////手势
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
//    [self.detailAddressTextView addGestureRecognizer:tapGestureRecognizer];
    
}

- (void)saveBtnClickEvent:(UIButton *)sender{
    if ([self.nameTextFiled.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请输入收货人姓名"];
        return;
    }
    if ([self.regionTextFiled.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
        return;
    }
    if ([self.detailAddressTextView.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请输入详细地址"];
        return;
    }
    if (![WWUtilityClass validateMobile:self.regionTextFiled.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }
    [FMHTTPClient PostSaveUserAddressWithUserId:[WWUtilityClass getNSUserDefaults:UserID] WithName:self.nameTextFiled.text WithMobile:self.phoneLab.text WithCity:self.regionTextFiled.text WContent:self.detailAddressTextView.text WithCompletion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response.code == WebAPIResponseCodeSuccess) {
                [[NSNotificationCenter defaultCenter] postNotificationName:WWSaveUserAddress object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
        });
    }];
}

#pragma mark -- UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int number = (textView.text.length-range.length+text.length) > 0 ? (int)(textView.text.length-range.length+text.length):0;
    if ([text isEqualToString:@"\n"]) {
        if (number-1 > 0) {
            self.placeholder.hidden = YES;
        }else{
            self.placeholder.hidden = NO;
        }
        [textView resignFirstResponder];
        return NO;
    }
    if (number == 0) {
        self.placeholder.hidden = NO;
    }else{
        self.placeholder.hidden = YES;
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
