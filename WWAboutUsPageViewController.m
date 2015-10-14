//
//  WWAboutUsPageViewController.m
//  WWSampleProject
//
//  Created by push on 15/10/13.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWAboutUsPageViewController.h"

@interface WWAboutUsPageViewController (){
    WWPublicNavtionBar * viewNavtionBar;
}

@property (nonatomic,strong)UIImageView         *logoImageView;
@property (nonatomic,strong)UILabel             *versionLab;

@end

@implementation WWAboutUsPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    self.view.backgroundColor = WW_BASE_COLOR;

    viewNavtionBar = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"设置" withRightBtn:NO withRightBtnPicName:@"" withRightBtnSize:CGSizeZero];
    [self.view addSubview:viewNavtionBar];
    
    // logo
    self.logoImageView = ({
        UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake((MainView_Width-100*kPercenX)/2, 120*kPercenX, 100*kPercenX, 100*kPercenX)];
        logoImage.layer.cornerRadius = 3.0f;
        logoImage.layer.masksToBounds = YES;
        logoImage.image = [UIImage imageNamed:@"icon_logo"];
        [self.view addSubview:logoImage];
        logoImage;
    });
    // 版本
    self.versionLab = ({
        UILabel *version = [[UILabel alloc]init];
        version.text = [NSString stringWithFormat:@"版本号：V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        version.textColor = WWContentTextColor;
        version.font = [UIFont systemFontOfSize:13.0f*kPercenX];
        CGSize size = [version.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:version.font,NSFontAttributeName, nil]];
        version.frame = CGRectMake((MainView_Width-size.width)/2, self.logoImageView.bottom+11, size.width, size.height);
        [self.view addSubview:version];
        version;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
