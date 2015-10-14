//
//  WWSettingViewController.m
//  WWSampleProject
//
//  Created by push on 15/10/13.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWSettingViewController.h"
#import "WWAboutUsPageViewController.h"

@interface WWSettingViewController (){
    WWPublicNavtionBar * viewNavtionBar;
}

@end

@implementation WWSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    self.view.backgroundColor = WW_BASE_COLOR;
    
    viewNavtionBar = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"设置" withRightBtn:NO withRightBtnPicName:@"" withRightBtnSize:CGSizeZero];
    [self.view addSubview:viewNavtionBar];
    
    [self setVCPageLayout];
}

- (void)setVCPageLayout{
    NSInteger maxWidth = IOS7_Y+44;
    // 内容
    NSArray *contentArr = @[@"关于我们",@"给个好评鼓励下"];
    for (int i = 0; i < 2; i++) {
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
        
        // 内容
        UILabel *contentLab = [[UILabel alloc]initWithFrame:CGRectMake(15*kPercenX, (listView.height-13*kPercenX)/2, 100, 13*kPercenX)];
        contentLab.text = contentArr[i];
        contentLab.textColor = WWContentTextColor;
        contentLab.font = [UIFont systemFontOfSize:13.0f*kPercenX];
        [listView addSubview:contentLab];
        
        // 方向箭头
        UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(listView.width-24*kPercenX, (listView.height-24*kPercenX)/2, 24*kPercenX, 24*kPercenX)];
        arrowImage.image = [UIImage imageNamed:@"check--details"];
        [listView addSubview:arrowImage];
        
        // 按钮
        UIButton *listBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        listBtn.frame = CGRectMake(0, 0, listView.width, listView.height);
        [listBtn setBackgroundImage:[WWUtilityClass imageWithColor:WWBtnStateHighlightedColor] forState:UIControlStateHighlighted];
        listBtn.tag = i;
        [listBtn addTarget:self action:@selector(listBtnSelectClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [listView addSubview:listBtn];
    }
    // 退出登录
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    exitBtn.backgroundColor = RGBCOLOR(283, 77, 77);
    exitBtn.frame = CGRectMake(0, 88*kPercenX+74+IOS7_Y, MainView_Width, 44*kPercenX);
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    exitBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f*kPercenX];
    [exitBtn setTintColor:[UIColor whiteColor]];
    [exitBtn addTarget:self action:@selector(exitBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitBtn];
}

- (void)listBtnSelectClickEvent:(UIButton *)sender{
    if (sender.tag == 0) {
        WWAboutUsPageViewController *aboutUs = [[WWAboutUsPageViewController alloc]init];
        [self.navigationController pushViewController:aboutUs animated:YES];
    }else{
        NSString *url = [NSString stringWithFormat:kAppStoreURLTemplate, kAppid];
        [self.navigationController.navigationBar setHidden:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

// 退出登录
- (void)exitBtnClickEvent:(UIButton *)sender{
    
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
