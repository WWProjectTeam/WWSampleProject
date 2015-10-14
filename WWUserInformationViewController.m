//
//  WWUserInformationViewController.m
//  WWSampleProject
//
//  Created by push on 15/10/14.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWUserInformationViewController.h"

@interface WWUserInformationViewController (){
    WWPublicNavtionBar *viewNavBarView;
}

@property (nonatomic,strong)UIView              *headView;      // 头像背静view
@property (nonatomic,strong)UILabel             *headContent;
@property (nonatomic,strong)UIImageView         *headImage;
@property (nonatomic,strong)UIImageView         *headArrow;
@property (nonatomic,strong)UIView              *nameView;      // 名称
@property (nonatomic,strong)UILabel             *nameContent;
@property (nonatomic,strong)UILabel             *nameText;
@property (nonatomic,strong)UIImageView         *nameArrow;

@end

@implementation WWUserInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WW_BASE_COLOR;
    
    viewNavBarView = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"基本信息" withRightBtn:NO withRightBtnPicName:@"" withRightBtnSize:CGSizeZero];
    [self.view addSubview:viewNavBarView];
    
#pragma mark ---  用户头像
    self.headView = ({
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, IOS7_Y+49, MainView_Width, 60*kPercenX)];
        headView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:headView];
        headView;
    });
    // 上下线条
    UILabel *upLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.headView.width, 1)];
    upLine.backgroundColor = WWPageLineColor;
    [self.headView addSubview:upLine];
    UILabel *downLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.headView.height-1, self.headView.width, 1)];
    downLine.backgroundColor = WWPageLineColor;
    [self.headView addSubview:downLine];
    self.headContent = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, (self.headView.height-13*kPercenX)/2, 100, 13*kPercenX)];
        label.text = @"头像";
        label.textColor = WWContentTextColor;
        label.font = [UIFont systemFontOfSize:13.0f*kPercenX];
        [self.headView addSubview:label];
        label;
    });
    self.headArrow = ({
        // 方向箭头
        UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.headView.width-24*kPercenX, (self.headView.height-24*kPercenX)/2, 24*kPercenX, 24*kPercenX)];
        arrowImage.image = [UIImage imageNamed:@"check--details"];
        [self.headView addSubview:arrowImage];
        arrowImage;
    });
    // 头像
    self.headImage = ({
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(self.headArrow.left-45*kPercenX, (self.headView.height-45*kPercenX)/2, 45*kPercenX, 45*kPercenX)];
        image.image = [UIImage imageNamed:@"img_ftx"];
        [self.headView addSubview:image];
        image;
    });
    
#pragma mark ---  用户名称
    self.nameView = ({
        UIView *nameView = [[UIView alloc]initWithFrame:CGRectMake(0, self.headView.bottom+5, MainView_Width, 44*kPercenX)];
        nameView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:nameView];
        nameView;
    });
    // 上下线条
    UILabel *nameUpLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.nameView.width, 1)];
    nameUpLine.backgroundColor = WWPageLineColor;
    [self.nameView addSubview:nameUpLine];
    UILabel *nameDownLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.nameView.height-1, self.nameView.width, 1)];
    nameDownLine.backgroundColor = WWPageLineColor;
    [self.nameView addSubview:nameDownLine];
    self.nameContent = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, (self.nameView.height-13*kPercenX)/2, 100, 13*kPercenX)];
        label.text = @"昵称";
        label.textColor = WWContentTextColor;
        label.font = [UIFont systemFontOfSize:13.0f*kPercenX];
        [self.nameView addSubview:label];
        label;
    });
    self.nameArrow = ({
        // 方向箭头
        UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.nameView.width-24*kPercenX, (self.nameView.height-24*kPercenX)/2, 24*kPercenX, 24*kPercenX)];
        arrowImage.image = [UIImage imageNamed:@"check--details"];
        [self.nameView addSubview:arrowImage];
        arrowImage;
    });
    self.nameText = ({
        // 内容
        UILabel *subContentLab = [[UILabel alloc]initWithFrame:CGRectMake(self.nameArrow.left-100, (self.nameView.height-13*kPercenX)/2, 100, 13*kPercenX)];
        subContentLab.textAlignment = NSTextAlignmentRight;
        subContentLab.text = @"13269329498";
        subContentLab.textColor = WWSubTitleTextColor;
        subContentLab.font = [UIFont systemFontOfSize:13.0f*kPercenX];
        [self.nameView addSubview:subContentLab];
        subContentLab;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
