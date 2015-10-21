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

@interface WWOrderViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    WWPublicNavtionBar *navTionBarView;
}

@property (nonatomic,strong)UIScrollView    *orderBackScrollView;

@property (nonatomic,strong)UITableView     *orderClothesTableView;

@property (nonatomic,strong)UIView          *orderAddressView;  // 收货地址背景

@property (nonatomic,strong)NSMutableArray  *orderClothesArray;

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
    self.orderBackScrollView.contentSize = CGSizeMake(0, 0);
    self.orderBackScrollView.scrollEnabled = NO;
    self.orderBackScrollView.bounces = NO;
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
    
    self.orderClothesTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, promptView.bottom, MainView_Width, 75*kPercenX*3) style:UITableViewStylePlain];
    self.orderClothesTableView.delegate = self;
    self.orderClothesTableView.dataSource = self;
    self.orderClothesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.orderClothesTableView.backgroundColor = [UIColor clearColor];
    self.orderClothesTableView.showsVerticalScrollIndicator = NO;
    [self.orderBackScrollView addSubview:self.orderClothesTableView];
}

#pragma mark ----- UITableViewDataSource
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
    }
}

// 添加收货地址
- (void)orderClickEvent:(UIButton *)sender{
    WWOrderAddressViewController *addressVC = [[WWOrderAddressViewController alloc]init];
    [self.navigationController pushViewController:addressVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
