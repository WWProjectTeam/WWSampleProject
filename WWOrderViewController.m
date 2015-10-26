//
//  WWOrderViewController.m
//  WWSampleProject
//
//  Created by push on 15/10/21.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWOrderViewController.h"
#import "WWClothesUseTableViewCell.h"
#import "WWClothesUseModel.h"
#import "WWOrderAddressViewController.h"
#import "WWProductDetailViewController.h"
#import "WWAddRessModel.h"

@interface WWOrderViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    WWPublicNavtionBar *navTionBarView;
}

@property (nonatomic,strong)UIScrollView    *orderBackScrollView;

@property (nonatomic,strong)UITableView     *orderClothesTableView;

@property (nonatomic,strong)UIView          *orderAddressView;  // 收货地址背景

@property (nonatomic,strong)NSMutableArray  *orderClothesArray;

@property (nonatomic,strong)UILabel         *orderOtherContentLab;
@property (nonatomic,strong)UIButton        *orderSettlementBtn;

@property (nonatomic,strong)UIImageView *payArrowImage;
@property (nonatomic,strong)UIView      *payBackView;
@property (nonatomic,strong)UIView      *payDetailView;
@property (nonatomic,strong)UILabel     *paySubLab;        // 详情
@property (nonatomic,strong)UIButton    *weChatBtn;
@property (nonatomic,strong)UIButton    *allPayBtn;

// 用户地址
@property (nonatomic,strong)UIView          *backView;
@property (nonatomic,strong)UILabel         *userName;
@property (nonatomic,strong)UILabel         *userPhone;
@property (nonatomic,strong)UILabel         *userAddRess;

@end

@implementation WWOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WW_BASE_COLOR;
    self.orderClothesArray = [NSMutableArray new];
    
    navTionBarView = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"确认订单" withRightBtn:NO withRightBtnPicName:nil withRightBtnSize:CGSizeZero];
    [self.view addSubview:navTionBarView];
    
    //背景view
    self.orderBackScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, IOS7_Y+44, MainView_Width, MainView_Height-IOS7_Y-44)];
//    self.orderBackScrollView.bounces = NO;
    self.orderBackScrollView.delegate = self;
    self.orderBackScrollView.showsHorizontalScrollIndicator = NO;
    self.orderBackScrollView.showsVerticalScrollIndicator = NO;
    self.orderBackScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.orderBackScrollView];
    
    
    // 收获地址
    self.orderAddressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainView_Width, 76*kPercenX)];
    self.orderAddressView.backgroundColor = [UIColor whiteColor];
    [self.orderBackScrollView addSubview:self.orderAddressView];
    // 线条
    UILabel *upLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.orderAddressView.width, 0.5f)];
    upLine.backgroundColor = WWPageLineColor;
    [self.orderAddressView addSubview:upLine];
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, (self.orderAddressView.height-19*kPercenX)/2, iphone_size_scale(15), iphone_size_scale(19))];
    iconImage.image = [UIImage imageNamed:@"map-pointer"];
    [self.orderAddressView addSubview:iconImage];
    UILabel *promptLab = [[UILabel alloc]initWithFrame:CGRectMake(iconImage.right+10, (self.orderAddressView.height-14*kPercenX)/2, 100, iphone_size_scale(14))];
    promptLab.text = @"添加收货地址";
    promptLab.textColor = RGBCOLOR(20, 20, 20);
    promptLab.font = font_size(14);
    [self.orderAddressView addSubview:promptLab];
    // 方向箭头
    UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.orderAddressView.width-24*kPercenX, (self.orderAddressView.height-24*kPercenX)/2, 24*kPercenX, 24*kPercenX)];
    arrowImage.image = [UIImage imageNamed:@"check--details"];
    [self.orderAddressView addSubview:arrowImage];
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(iconImage.right+10, 1, self.orderAddressView.width-iconImage.width-25-arrowImage.width, self.orderAddressView.height-1)];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.orderAddressView addSubview:self.backView];
    
    // 用户名称
    self.userName = [[UILabel alloc]init];
    self.userName.textColor = RGBCOLOR(20, 20, 20);
    self.userName.font = font_size(14);
    [self.backView addSubview:self.userName];
    
    // 用户手机
    self.userPhone = [[UILabel alloc]init];
    self.userPhone.font = font_size(13);
    self.userPhone.textColor = [UIColor blackColor];
    [self.backView addSubview:self.userPhone];
    
    // 用户收货地址
    self.userAddRess = [[UILabel alloc]init];
    self.userAddRess.font = font_size(12);
    self.userAddRess.textColor = WWContentTextColor;
    self.userAddRess.numberOfLines = 2;
    [self.backView addSubview:self.userAddRess];
    
    self.backView.hidden = YES;
    
    UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    orderBtn.frame = CGRectMake(0, 0, self.orderAddressView.width, self.orderAddressView.height);
    [orderBtn addTarget:self action:@selector(orderClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.orderAddressView addSubview:orderBtn];
    
    /**
     *  提示View
     */
    UIView *promptView = [[UIView alloc]initWithFrame:CGRectMake(0, self.orderAddressView.bottom+5, MainView_Width, 76*kPercenX)];
    promptView.backgroundColor = [UIColor whiteColor];
    [self.orderBackScrollView addSubview:promptView];
    // content
    UILabel *promptViewContent = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, promptView.width-20, promptView.height-20)];
    promptViewContent.font = font_size(12);
    promptViewContent.textColor = RGBCOLOR(128, 128, 128);
    promptViewContent.numberOfLines = 3;
    NSString *textStr =@"提示\n借穿衣服的相关规定，比如租凭时时长、还衣地点注意事\n项等等...";
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:textStr];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:7];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [textStr length])];
    [promptViewContent setAttributedText:attributedString1];
    [promptViewContent sizeToFit];
    [promptView addSubview:promptViewContent];
    
    // 加载数据
    for (NSDictionary *dic  in [self.orderDataDic objectForKey:@"clientWardrobes"]) {
        WWClothesUseModel *model = [WWClothesUseModel initWithClothesModel:dic];
        [self.orderClothesArray addObject:model];
    }
    
    self.orderClothesTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, promptView.bottom, MainView_Width, 75*kPercenX*self.orderClothesArray.count) style:UITableViewStylePlain];
    self.orderClothesTableView.delegate = self;
    self.orderClothesTableView.dataSource = self;
    self.orderClothesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.orderClothesTableView.backgroundColor = [UIColor clearColor];
    self.orderClothesTableView.showsVerticalScrollIndicator = NO;
    self.orderClothesTableView.scrollEnabled = NO;
    [self.orderBackScrollView addSubview:self.orderClothesTableView];
    [self.orderClothesTableView reloadData];
    
    // 底部view
    UIView *bottonView = [[UIView alloc]initWithFrame:CGRectMake(0, MainView_Height-44*kPercenX, MainView_Width, iphone_size_scale(44))];
    bottonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottonView];
    UILabel *bottonUpLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MainView_Width, 0.5f)];
    bottonUpLine.backgroundColor = WWPageLineColor;
    [bottonView addSubview:bottonUpLine];
    // 运费+次数
    self.orderOtherContentLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, bottonView.width-125*kPercenX-10, bottonView.height)];
    self.orderOtherContentLab.font = font_size(12);
    self.orderOtherContentLab.textColor = RGBCOLOR(224, 162, 28);
    [bottonView addSubview:self.orderOtherContentLab];
    // 立即拥有
    self.orderSettlementBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    self.orderSettlementBtn.frame = CGRectMake(bottonView.width-125*kPercenX, 0, iphone_size_scale(125), bottonView.height);
    [self.orderSettlementBtn setTitle:@"立即拥有" forState:UIControlStateNormal];
    [self.orderSettlementBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.orderSettlementBtn.titleLabel.font = font_size(14);
    self.orderSettlementBtn.backgroundColor = WWBtnYellowColor;
    [self.orderSettlementBtn setBackgroundImage:[WWUtilityClass imageWithColor:RGBCOLOR(211, 120, 23)] forState:UIControlStateHighlighted];
//    [self.settlementBtn addTarget:self action:@selector(settlementClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [bottonView addSubview:self.orderSettlementBtn];
    
    // 免费次数
    NSString *expressCount = [self.orderDataDic objectForKey:@"expressCount"];
    // 运费
    NSString *freight = [self.orderDataDic objectForKey:@"freight"];
    if ([expressCount intValue] == 0) {
        self.orderOtherContentLab.text = [NSString stringWithFormat:@"运费：￥%@",freight];
        [self payMentView];
        self.orderBackScrollView.contentSize = CGSizeMake(MainView_Width, self.orderAddressView.height+promptView.height+self.orderClothesTableView.height+180);
    }else{
        self.orderOtherContentLab.text = [NSString stringWithFormat:@"您还可免费更换%@次",expressCount];
        self.orderBackScrollView.contentSize = CGSizeMake(MainView_Width, self.orderAddressView.height+promptView.height+self.orderClothesTableView.height+10);
    }
}

- (void)userOrderAddRessView{
    
}

- (void)payMentView{
    /**
     *  支付
     */
    self.payBackView = [[UIView alloc]initWithFrame:CGRectMake(0, self.orderClothesTableView.bottom+5, MainView_Width, 44*kPercenX)];
    self.payBackView.backgroundColor = [UIColor whiteColor];
    [self.orderBackScrollView addSubview:self.payBackView];
    // 方向箭头
    self.payArrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.payBackView.width-24*kPercenX, (self.payBackView.height-24*kPercenX)/2, 24*kPercenX, 24*kPercenX)];
    self.payArrowImage.image = [UIImage imageNamed:@"check--details1"];
    [self.payBackView addSubview:self.payArrowImage];
    // 上下线条
    UILabel *payUpLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.payBackView.width, 1)];
    payUpLine.backgroundColor = WWPageLineColor;
    [self.payBackView addSubview:payUpLine];
    UILabel *payDownLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.payBackView.height-1, self.payBackView.width, 1)];
    payDownLine.backgroundColor = WWPageLineColor;
    [self.payBackView addSubview:payDownLine];
    //payLabel
    UILabel *payLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, (self.payBackView.height-14*kPercenX)/2, 100, 14*kPercenX)];
    payLabel.text = @"支付方式";
    payLabel.textColor = RGBCOLOR(20, 20, 20);
    payLabel.font = font_size(14);
    [self.payBackView addSubview:payLabel];
    //paySubLabel;
    self.paySubLab = [[UILabel alloc]initWithFrame:CGRectMake(self.payArrowImage.left-100, (self.payBackView.height-14*kPercenX)/2, 100, 14*kPercenX)];
    self.paySubLab.textAlignment = NSTextAlignmentRight;
    self.paySubLab.text = @"支付宝";
    self.paySubLab.textColor = RGBCOLOR(128, 128, 128);
    self.paySubLab.font = font_size(14);
    [self.payBackView addSubview:self.paySubLab];
    // 点击事件
    UIButton *payClickBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    payClickBtn.frame = CGRectMake(0, 0, self.payBackView.width, self.payBackView.height);
    [payClickBtn setBackgroundImage:[WWUtilityClass imageWithColor:WWBtnStateHighlightedColor] forState:UIControlStateHighlighted];
    [payClickBtn addTarget:self action:@selector(payClickEvnet:) forControlEvents:UIControlEventTouchUpInside];
    [self.payBackView addSubview:payClickBtn];
    
#pragma mark --- 支付选择
    self.payDetailView = [[UIView alloc]initWithFrame:CGRectMake(0, self.payBackView.bottom, MainView_Width, 80*kPercenX)];
    self.payDetailView.backgroundColor = [UIColor whiteColor];
    [self.orderBackScrollView addSubview:self.payDetailView];
    // 微信
    UIView *weChatView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainView_Width, self.payDetailView.height/2)];
    weChatView.backgroundColor = [UIColor whiteColor];
    [self.payDetailView addSubview:weChatView];
    // 图标
    UIImageView *weChaticonImage = [[UIImageView alloc]initWithFrame:CGRectMake(10*kPercenX, (weChatView.height-27*kPercenX)/2, 27*kPercenX, 27*kPercenX)];
    weChaticonImage.image = [UIImage imageNamed:@"微信"];
    [weChatView addSubview:weChaticonImage];
    // 文字
    UILabel *weChatLab = [[UILabel alloc]initWithFrame:CGRectMake(weChaticonImage.right+5, (weChatView.height-13*kPercenX)/2, 50, iphone_size_scale(13))];
    weChatLab.text = @"微信";
    weChatLab.textColor = WWContentTextColor;
    weChatLab.font = font_size(13);
    [weChatView addSubview:weChatLab];
    // 支付选择按钮
    self.weChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.weChatBtn.frame = CGRectMake(weChatView.width-8-14*kPercenX, (weChatView.height-14*kPercenX)/2, iphone_size_scale(14), iphone_size_scale(14));
    [self.weChatBtn setImage:[UIImage imageNamed:@"btn_zf_n@3x"] forState:UIControlStateNormal];
    [self.weChatBtn setImage:[UIImage imageNamed:@"btn_zf_c@3x"] forState:UIControlStateSelected];
    [weChatView addSubview:self.weChatBtn];
    UIButton *weChat = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    weChat.frame = CGRectMake(0, 0, weChatView.width, weChatView.height);
    [weChat addTarget:self action:@selector(payBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    weChat.tag = 20000;
    [weChatView addSubview:weChat];
    
    // 支付宝
    UIView *allPayView = [[UIView alloc]initWithFrame:CGRectMake(0, weChatView.bottom, MainView_Width, self.payDetailView.height/2)];
    allPayView.backgroundColor = [UIColor whiteColor];
    [self.payDetailView addSubview:allPayView];
    // 图标
    UIImageView *allPayIconImage = [[UIImageView alloc]initWithFrame:CGRectMake(10*kPercenX, (allPayView.height-27*kPercenX)/2, 27*kPercenX, 27*kPercenX)];
    allPayIconImage.image = [UIImage imageNamed:@"支付宝"];
    [allPayView addSubview:allPayIconImage];
    // 支付宝上下线条
    UILabel *allPayUpLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, allPayView.width, 1)];
    allPayUpLine.backgroundColor = WWPageLineColor;
    [allPayView addSubview:allPayUpLine];
    UILabel *allPayDownLine = [[UILabel alloc]initWithFrame:CGRectMake(0, allPayView.height-1, allPayView.width, 1)];
    allPayDownLine.backgroundColor = WWPageLineColor;
    [allPayView addSubview:allPayDownLine];
    // 文字
    UILabel *allPayLab = [[UILabel alloc]initWithFrame:CGRectMake(allPayIconImage.right+5, (allPayView.height-13*kPercenX)/2, 50, iphone_size_scale(13))];
    allPayLab.textAlignment = NSTextAlignmentCenter;
    allPayLab.text = @"支付宝";
    allPayLab.textColor = WWContentTextColor;
    allPayLab.font = font_size(13);
    [allPayView addSubview:allPayLab];
    // 支付选择按钮
    self.allPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.allPayBtn.frame = CGRectMake(allPayView.width-8-14*kPercenX, (allPayView.height-14*kPercenX)/2, iphone_size_scale(14), iphone_size_scale(14));
    [self.allPayBtn setImage:[UIImage imageNamed:@"btn_zf_n@3x"] forState:UIControlStateNormal];
    [self.allPayBtn setImage:[UIImage imageNamed:@"btn_zf_c@3x"] forState:UIControlStateSelected];
    self.allPayBtn.selected = YES;
    [allPayView addSubview:self.allPayBtn];
    UIButton *allpay = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    allpay.frame = CGRectMake(0, 0, allPayView.width, allPayView.height);
    [allpay addTarget:self action:@selector(payBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    allpay.tag = 20001;
    [allPayView addSubview:allpay];
    
    self.payDetailView.hidden = YES;

}

- (void)payBtnClickEvent:(UIButton *)sender{
    if (sender.tag == 20000) {      // 微信
        self.allPayBtn.selected = NO;
        self.weChatBtn.selected = YES;
        self.paySubLab.text = @"微信";
    }else if (sender.tag == 20001){     // 支付宝
        self.allPayBtn.selected = YES;
        self.weChatBtn.selected = NO;
        self.paySubLab.text = @"支付宝";
    }
    [self payDetailViewHidden:NO];
}

// 支付触发事件
- (void)payClickEvnet:(UIButton *)sender{
    if (self.payDetailView.hidden == YES) {
        [self payDetailViewHidden:YES];
    }else{
        [self payDetailViewHidden:NO]; 
    }
}

- (void)payDetailViewHidden:(BOOL)bol{
    [UIView animateWithDuration:0.5 animations:^{
        self.payArrowImage.transform = CGAffineTransformRotate(self.payArrowImage.transform, -M_PI);//旋转180度
    }];
    if (bol == YES) {
        self.payDetailView.hidden = NO;
        self.orderBackScrollView.contentOffset = CGPointMake(0, 140);
    }else{
        self.payDetailView.hidden = YES;
        self.orderBackScrollView.contentOffset = CGPointMake(0, 0);
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [self.orderClothesTableView reloadData];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderClothesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellString = @"cellId";
    WWClothesUseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (cell == nil) {
        cell = [[WWClothesUseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
        cell.backgroundColor = [UIColor clearColor];
    }
    if (indexPath.row < self.orderClothesArray.count) {
        WWClothesUseModel *model = [self.orderClothesArray objectAtIndex:indexPath.row];
        [cell initRequestClothesDetailData:model];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75*kPercenX;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.orderClothesArray.count) {
        WWClothesUseModel *model = [self.orderClothesArray objectAtIndex:indexPath.row];
        WWProductDetailViewController *productDetailVC = [[WWProductDetailViewController alloc]init];
        productDetailVC.strProductId = model.clothes_id;
        [self.navigationController pushViewController:productDetailVC animated:YES];
    }
}

// 添加收货地址
- (void)orderClickEvent:(UIButton *)sender{
    WWOrderAddressViewController *addressVC = [[WWOrderAddressViewController alloc]init];
    addressVC.userOrderAddressBlock= ^(WWAddRessModel *model){
        self.backView.hidden = NO;
        self.userName.text = [NSString stringWithFormat:@"收货人：%@",model.userName];
        self.userPhone.text = model.mobile;
        self.userAddRess.text = [NSString stringWithFormat:@"收货地址：%@%@",model.cityStr,model.content];
        CGSize navSize = CGSizeMake(150, 20000.0f);
        navSize = [self.userName.text sizeWithFont:self.userName.font constrainedToSize:navSize lineBreakMode:NSLineBreakByCharWrapping];
        self.userName.frame = CGRectMake(0, 10, navSize.width, navSize.height);
        CGSize navSizePhone = CGSizeMake(300, 20000.0f);
        navSizePhone = [self.userPhone.text sizeWithFont:self.userPhone.font constrainedToSize:navSize lineBreakMode:NSLineBreakByCharWrapping];
        self.userPhone.frame = CGRectMake(self.backView.width-navSizePhone.width, 10, navSizePhone.width, navSizePhone.height);
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.userAddRess.text];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:5];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.userAddRess.text length])];
        [self.userAddRess setAttributedText:attributedString1];
        [self.userAddRess sizeToFit];
        self.userAddRess.frame =CGRectMake(0, self.userName.bottom+5, 250, 40);
    };
    [self.navigationController pushViewController:addressVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
