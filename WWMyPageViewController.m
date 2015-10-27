//
//  WWMyPageViewController.m
//  WWSampleProject
//
//  Created by push on 15/10/13.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWMyPageViewController.h"
#import "HTTPClient+Other.h"
#import "WWSettingViewController.h"
#import "WWUserInformationViewController.h"
#import "WWFeedbackViewController.h"
#import "WWMyCollectionViewController.h"
#import "WWVIPPackageViewController.h"

@interface WWMyPageViewController ()<UIAlertViewDelegate>
{
    WWPublicNavtionBar * viewNavtionBar;
}

@property (nonatomic,strong)UIView                  *headBackView;
@property (nonatomic,strong)UIImageView             *headImage;
@property (nonatomic,strong)UIButton                *headImageBtn;
@property (nonatomic,strong)UIButton                *setButton;
@property (nonatomic,strong)UILabel                 *numberLabel;

@end

@implementation WWMyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WW_BASE_COLOR;
    
    // 导航
    viewNavtionBar = [[WWPublicNavtionBar alloc]initWithLeftBtn:NO withTitle:@"我的" withRightBtn:NO withRightBtnPicName:nil withRightBtnSize:CGSizeZero];
    [self.view addSubview:viewNavtionBar];
    
    [self layoutMyPageView];
    [self getUserInformationWebRequest];
    
    // 消息通知刷新个人信息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NotificationRefreshUserInformation:)
                                                 name:WWRefreshUserInformation
                                               object:nil];
}

// 获取网络信息
- (void)getUserInformationWebRequest{
    
    [FMHTTPClient GetUserInformationUserId:[WWUtilityClass getNSUserDefaults:UserID] WithCompletion:^(WebAPIResponse *response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (response.code == WebAPIResponseCodeSuccess) {
                    
                    NSDictionary *resultDic = [response.responseObject objectForKey:@"result"];
                    // 保存用户信息
                    g_UserId = StringForKeyInUnserializedJSONDic(resultDic, @"id");
                    [WWUtilityClass saveNSUserDefaults:UserID value:StringForKeyInUnserializedJSONDic(resultDic, @"id")];
                    [WWUtilityClass saveNSUserDefaults:UserImageURL value:StringForKeyInUnserializedJSONDic(resultDic, @"faceUrl")];
                    [WWUtilityClass saveNSUserDefaults:UserName value:StringForKeyInUnserializedJSONDic(resultDic, @"userName")];
                    [WWUtilityClass saveNSUserDefaults:UserPhone value:StringForKeyInUnserializedJSONDic(resultDic, @"mobile")];
                    NSDictionary *vipDic = [resultDic objectForKey:@"vip"];
                    [WWUtilityClass saveNSUserDefaults:UserVipID value:[vipDic objectForKey:@"state"]];
                    if ([[vipDic objectForKey:@"state"] intValue] == 1) {
                        [WWUtilityClass saveNSUserDefaults:UserVipEndTime value:[vipDic objectForKey:@"endTime"]];
                    }
                    if ([[WWUtilityClass getNSUserDefaults:UserImageURL] isEqualToString:@""]) {
                        self.headImage.image = [UIImage imageNamed:@"img_tx"];
                    }else{
                        [self.headImage sd_setImageWithURL:[NSURL URLWithString:StringForKeyInUnserializedJSONDic(resultDic, @"faceUrl")] placeholderImage:[UIImage imageNamed:@"img_tx"]];
                    }
                    self.numberLabel.text = StringForKeyInUnserializedJSONDic(resultDic, @"userName");
                }
            });
    }];
}

// 登录更新信息
- (void)NotificationRefreshUserInformation:(NSNotification *)notification{
    [self getUserInformationWebRequest];
}

// 实例化界面
- (void)layoutMyPageView{
    // 背景
    self.headBackView = ({
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(0, IOS7_Y+44, MainView_Width, 130*kPercenX);
        [self.view addSubview:view];
        view;
    });
    // 背景图片
    UIImageView *headerBackImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.headBackView.width, self.headBackView.height)];
    headerBackImage.image = [UIImage imageNamed:@"bg_grzx"];
    [self.headBackView addSubview:headerBackImage];
    // 头像
    self.headImage = ({
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.headBackView.width-61*kPercenX)/2, 20, 61*kPercenX, 61*kPercenX)];
        imageView.layer.cornerRadius = (61*kPercenX)/2;
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        imageView.layer.borderWidth = 2.0f;
        [self.headBackView addSubview:imageView];
        imageView;
    });
    self.headImageBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = self.headImage.frame;
        button.layer.cornerRadius = (61*kPercenX)/2;
        button.layer.masksToBounds = YES;
        [button setBackgroundImage:[WWUtilityClass imageWithColor:WWBtnStateHighlightedColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(userInformationClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.headBackView addSubview:button];
        button;
    });
    // 手机号码
    self.numberLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((self.headBackView.width-154)/2, self.headImage.bottom+15, 154, 15)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        [self.headBackView addSubview:label];
        label;
    });
    // 右上角设置
    self.setButton = ({
        UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        setBtn.frame = CGRectMake(self.headBackView.width-44, 10, 29*kPercenX, 29*kPercenX);
        [setBtn setBackgroundImage:[UIImage imageNamed:@"btn_sz_n"] forState:UIControlStateNormal];
        [setBtn addTarget:self action:@selector(setBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.headBackView addSubview:setBtn];
        setBtn;
    });
    
    NSInteger maxWidth = self.headBackView.bottom;
    // 图标数组
    NSArray *iconArr = @[@"icon_dd",@"icon_sc",@"icon_yjfk",@"icon_dh"];
    // 内容
    NSArray *contentArr = @[@"VIP套餐",@"我的收藏",@"意见反馈",@"客服电话"];
    NSString *VipTime;
    if ([[WWUtilityClass getNSUserDefaults:UserVipID] intValue] == 1) {
        VipTime = [WWUtilityClass getNSUserDefaults:UserVipEndTime];
    }else {
        VipTime = @"立即购买";
    }
    // 附表题内容
    NSArray *subContentArr = @[VipTime,@"",@"",WWSupportTel];
    for (int i = 0; i <= 3; i++) {
        UIView *listView = [[UIView alloc]initWithFrame:CGRectMake(0, maxWidth+5, MainView_Width, 44*kPercenX)];
        listView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:listView];
        maxWidth = CGRectGetMaxY(listView.frame);
        // 上下线条
        UILabel *upLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, listView.width, 1)];
        upLine.backgroundColor = WWPageLineColor;
        [listView addSubview:upLine];
        UILabel *downLine = [[UILabel alloc]initWithFrame:CGRectMake(0, listView.height-1, listView.width, 1)];
        downLine.backgroundColor = WWPageLineColor;
        [listView addSubview:downLine];
        // 图标
        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(12*kPercenX, (listView.height-21*kPercenX)/2, 21*kPercenX, 21*kPercenX)];
        iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",iconArr[i]]];
        [listView addSubview:iconImage];
        // 方向箭头
        UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(listView.width-24*kPercenX, (listView.height-24*kPercenX)/2, 24*kPercenX, 24*kPercenX)];
        arrowImage.image = [UIImage imageNamed:@"check--details"];
        [listView addSubview:arrowImage];
        // 内容
        UILabel *contentLab = [[UILabel alloc]initWithFrame:CGRectMake(iconImage.right+10, (listView.height-13*kPercenX)/2, 100, 13*kPercenX)];
        contentLab.text = contentArr[i];
        contentLab.textColor = WWContentTextColor;
        contentLab.font = [UIFont systemFontOfSize:13.0f*kPercenX];
        [listView addSubview:contentLab];
        // 内容
        UILabel *subContentLab = [[UILabel alloc]initWithFrame:CGRectMake(arrowImage.left-155, (listView.height-13*kPercenX)/2, 150, 13*kPercenX)];
        subContentLab.textAlignment = NSTextAlignmentRight;
        subContentLab.text = subContentArr[i];
        subContentLab.textColor = WWSubTitleTextColor;
        subContentLab.font = [UIFont systemFontOfSize:13.0f*kPercenX];
        [listView addSubview:subContentLab];
        
        // 按钮
        UIButton *listBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        listBtn.frame = CGRectMake(0, 0, listView.width, listView.height);
        [listBtn setBackgroundImage:[WWUtilityClass imageWithColor:WWBtnStateHighlightedColor] forState:UIControlStateHighlighted];
        listBtn.tag = i;
        [listBtn addTarget:self action:@selector(listBtnSelectClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [listView addSubview:listBtn];
    }
    
}

- (void)listBtnSelectClickEvent:(UIButton *)sender{
    if (sender.tag == 0) {
        WWVIPPackageViewController *vipVC = [[WWVIPPackageViewController alloc] init];
        [self.navigationController pushViewController:vipVC animated:YES];
    }else if (sender.tag == 1){
        WWMyCollectionViewController *collectionVC = [[WWMyCollectionViewController alloc]init];
        [self.navigationController pushViewController:collectionVC animated:YES];
    }else if (sender.tag == 2){
        WWFeedbackViewController *feedVC = [[WWFeedbackViewController alloc]init];
        [self.navigationController pushViewController:feedVC animated:YES];
    }else if (sender.tag == 3){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"电话咨询" message:@"400-585-5896" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
        alert.delegate = self;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // 打开tel：开头的URL代表拨打电话，使用tel：或tel：//前缀都行
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",WWSupportTel]]];
    }
}

- (void)setBtnClickEvent:(UIButton *)sender{
    WWSettingViewController *setVC = [[WWSettingViewController alloc]init];
    [self.navigationController pushViewController:setVC animated:YES];
}

- (void)userInformationClickEvent:(UIButton *)sender{
    WWUserInformationViewController *userVC = [[WWUserInformationViewController alloc]init];
    userVC.userFaceUrl = [WWUtilityClass getNSUserDefaults:UserImageURL];
    userVC.userName = [WWUtilityClass getNSUserDefaults:UserName];
    [self.navigationController pushViewController:userVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
