//
//  WWMyOrderDetailViewController.m
//  WWSampleProject
//
//  Created by push on 15/11/4.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWMyOrderDetailViewController.h"
#import "HTTPClient+Other.h"
#import "WWWantRantModel.h"
#import "WWWantRentTableViewCell.h"

@interface WWMyOrderDetailViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    WWPublicNavtionBar  *navtionBarView;
    NSDictionary *orderDataDic;
}

@property (nonatomic,strong)UIScrollView    *orderBackScorllView;
@property (nonatomic,strong)UIView          *orderNumberView;
@property (nonatomic,strong)UILabel         *orderNumber;           // 订单号
@property (nonatomic,strong)UILabel         *userName;               // 收获人姓名
@property (nonatomic,strong)UILabel         *userPhone;               // 收获人手机号
@property (nonatomic,strong)UILabel         *userAddRess;               // 收获人地址
@property (nonatomic,strong)UILabel         *orderEndTime;              // 还衣时间

@property (nonatomic,strong)UIView          *orderMoneyView;
@property (nonatomic,strong)UILabel         *orderPayMoney;             // 实付款

@property (nonatomic,strong)UITableView     *orderTabelView;
@property (nonatomic,strong)NSMutableArray  *orderClothesArr;
@property (nonatomic,strong)UIView          *rantDaysView;          // 租赁天数

@end

@implementation WWMyOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WW_BASE_COLOR;
    self.orderClothesArr = [NSMutableArray new];
    navtionBarView = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"订单详情" withRightBtn:NO withRightBtnPicName:nil withRightBtnSize:CGSizeZero];
    [self.view addSubview:navtionBarView];
    
    UILabel *navLine = [[UILabel alloc]initWithFrame:CGRectMake(0, navtionBarView.height-0.5f, MainView_Width, 0.5f)];
    navLine.backgroundColor = WW_BASE_COLOR;
    [navtionBarView addSubview:navLine];
    
    self.orderBackScorllView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, IOS7_Y+44, MainView_Width, MainView_Height-IOS7_Y-44)];
    self.orderBackScorllView.delegate = self;
    self.orderBackScorllView.showsHorizontalScrollIndicator = NO;
    self.orderBackScorllView.showsVerticalScrollIndicator = NO;
    self.orderBackScorllView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.orderBackScorllView];
    
    [SVProgressHUD show];
    [FMHTTPClient GetOrderDetail:self.orderId WithCompletion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response.code == WebAPIResponseCodeSuccess) {
                [SVProgressHUD dismiss];
                orderDataDic = [response.responseObject objectForKey:@"result"];
                // 加载数据
                for (NSDictionary *dic  in [orderDataDic objectForKey:@"clothes"]) {
                    WWWantRantModel *model = [WWWantRantModel initWithClothesRequestData:dic];
                    [self.orderClothesArr addObject:model];
                }
                [self orderNumberView:orderDataDic];    // 订单号
                [self orderAllMoney:orderDataDic];      // 实付款
                [self orderDetailClothes:[orderDataDic objectForKey:@"days"]];
            }else{
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:@"请求出错"];
            }
        });
    }];
}


// 订单号+收货地址+还衣时间
- (void)orderNumberView:(NSDictionary *)dicInfor{
    self.orderNumberView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainView_Width, 40+75+40)];
    self.orderNumberView.backgroundColor = [UIColor whiteColor];
    [self.orderBackScorllView addSubview:self.orderNumberView];
    UILabel *orderNumberOnLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.orderNumberView.width, 0.5f)];
    orderNumberOnLine.backgroundColor = WWPageLineColor;
    [self.orderNumberView addSubview:orderNumberOnLine];
    UILabel *orderNumberUpLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.orderNumberView.height-0.5f, self.orderNumberView.width, 0.5f)];
    orderNumberUpLine.backgroundColor = WWPageLineColor;
    [self.orderNumberView addSubview:orderNumberUpLine];
    // 订单号
    self.orderNumber = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.orderNumberView.width,40)];
    self.orderNumber.text = [NSString stringWithFormat:@"订单号：%@",dicInfor[@"orderNumber"]];
    self.orderNumber.textColor = WWContentTextColor;
    self.orderNumber.font = font_size(12);
    [self.orderNumberView addSubview:self.orderNumber];
    // 分割线
    UILabel *orderNumberLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.orderNumber.bottom, self.orderNumberView.width, 0.5f)];
    orderNumberLine.backgroundColor = WWPageLineColor;
    [self.orderNumberView addSubview:orderNumberLine];
    // 收货地址
    // 用户名称
    self.userName = [[UILabel alloc]init];
    self.userName.textColor = RGBCOLOR(20, 20, 20);
    self.userName.font = font_size(14);
    self.userName.text = [NSString stringWithFormat:@"收货人：%@",[[dicInfor objectForKey:@"address"] objectForKey:@"userName"]];
    [self.orderNumberView addSubview:self.userName];
    CGSize navSize = CGSizeMake(150, 20000.0f);
    navSize = [self.userName.text sizeWithFont:self.userName.font constrainedToSize:navSize lineBreakMode:NSLineBreakByCharWrapping];
    self.userName.frame = CGRectMake(10, orderNumberLine.bottom+10, navSize.width, navSize.height);
    
    // 用户手机
    self.userPhone = [[UILabel alloc]init];
    self.userPhone.font = font_size(13);
    self.userPhone.textColor = [UIColor blackColor];
    self.userPhone.text = [NSString stringWithFormat:@"%@",[[dicInfor objectForKey:@"address"] objectForKey:@"mobile"]];
    [self.orderNumberView addSubview:self.userPhone];
    CGSize navSizePhone = CGSizeMake(300, 20000.0f);
    navSizePhone = [self.userPhone.text sizeWithFont:self.userPhone.font constrainedToSize:navSize lineBreakMode:NSLineBreakByCharWrapping];
    self.userPhone.frame = CGRectMake(self.orderNumberView.width-navSizePhone.width-10, orderNumberLine.bottom+10, navSizePhone.width, navSizePhone.height);
    
    // 用户收货地址
    self.userAddRess = [[UILabel alloc]init];
    self.userAddRess.font = font_size(12);
    self.userAddRess.textColor = WWContentTextColor;
    self.userAddRess.numberOfLines = 2;
    self.userAddRess.text = [NSString stringWithFormat:@"收货地址：%@",[[dicInfor objectForKey:@"address"] objectForKey:@"content"]];
    [self.orderNumberView addSubview:self.userAddRess];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.userAddRess.text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:6];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.userAddRess.text length])];
    [self.userAddRess setAttributedText:attributedString1];
    [self.userAddRess sizeToFit];
    self.userAddRess.frame =CGRectMake(10, self.userName.bottom+5, self.orderNumberView.width-20, 40);
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, self.orderNumberView.height-40.5, self.orderNumberView.width, 0.5f)];
    line.backgroundColor = WWPageLineColor;
    [self.orderNumberView addSubview:line];
    // 还衣时间
    UILabel *endTime = [[UILabel alloc]initWithFrame:CGRectMake(10, self.orderNumberView.height-40, 150, 40)];
    endTime.textColor = WWContentTextColor;
    endTime.text = @"最晚还衣时间";
    endTime.font = font_size(12);
    [self.orderNumberView addSubview:endTime];
    
    self.orderEndTime = [[UILabel alloc]init];
    self.orderEndTime.textAlignment = NSTextAlignmentRight;
    self.orderEndTime.textColor = WWContentTextColor;
    self.orderEndTime.font = font_size(12);
    self.orderEndTime.text = [dicInfor objectForKey:@"endTime"];
    [self.orderNumberView addSubview:self.orderEndTime];
    CGSize navSizeEndTime = CGSizeMake(300, 20000.0f);
    navSizeEndTime = [self.orderEndTime.text sizeWithFont:self.orderEndTime.font constrainedToSize:navSizeEndTime lineBreakMode:NSLineBreakByCharWrapping];
    self.orderEndTime.frame = CGRectMake(self.orderNumberView.width-navSizeEndTime.width-10, line.bottom, navSizeEndTime.width, 40);
    
}

// 实付款+押金费用等
- (void)orderAllMoney:(NSDictionary *)dicInfor{
    self.orderMoneyView =[[UIView alloc]initWithFrame:CGRectMake(0, self.orderNumberView.bottom+5, MainView_Width, 150)];
    self.orderMoneyView.backgroundColor = [UIColor whiteColor];
    [self.orderBackScorllView addSubview:self.orderMoneyView];
    UILabel *orderMoneyOnLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.orderMoneyView.width, 0.5f)];
    orderMoneyOnLine.backgroundColor = WWPageLineColor;
    [self.orderMoneyView addSubview:orderMoneyOnLine];
    UILabel *orderMoneyUpLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.orderMoneyView.height-0.5f, self.orderMoneyView.width, 0.5f)];
    orderMoneyUpLine.backgroundColor = WWPageLineColor;
    [self.orderMoneyView addSubview:orderMoneyUpLine];
    
    self.orderPayMoney = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.orderMoneyView.width-20, 40)];
    self.orderPayMoney.text = [NSString stringWithFormat:@"实付款：￥%@",[dicInfor objectForKey:@"deposit"]];
    self.orderPayMoney.textColor = WWContentTextColor;
    self.orderPayMoney.font = font_size(12);
    [self.orderMoneyView addSubview:self.orderPayMoney];
    
    UILabel *moneyLine = [[UILabel alloc]initWithFrame:CGRectMake(10, self.orderPayMoney.bottom, self.orderMoneyView.width-20, 0.5f)];
    moneyLine.backgroundColor = WWPageLineColor;
    [self.orderMoneyView addSubview:moneyLine];
    // 押金、租金、清洁费、运费
    NSInteger maxHeight = moneyLine.bottom;
    NSArray *title = @[@"服装押金",@"租凭费用",@"服装清洁费",@"运费"];
    NSString *deposit = [NSString stringWithFormat:@"￥%@",[dicInfor objectForKey:@"deposit"]];
    NSString *leaseCost = [NSString stringWithFormat:@"￥%@(归还后从押金扣除)",[dicInfor objectForKey:@"leaseCost"]];
    NSArray *content = @[deposit,leaseCost,@"￥0.00",@"￥0.00"];
    for (int i = 0; i<4; i++) {
        UILabel *moneyTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, maxHeight+10, 100, iphone_size_scale(12))];
        moneyTitle.text = title[i];
        moneyTitle.textColor = RGBCOLOR(102, 102, 102);
        moneyTitle.font = font_size(12);
        [self.orderMoneyView addSubview:moneyTitle];
        UILabel *montyNum = [[UILabel alloc]initWithFrame:CGRectMake(self.orderMoneyView.width-260, maxHeight+10, 250, iphone_size_scale(12))];
        montyNum.text = content[i];
        montyNum.textColor = RGBCOLOR(224, 162, 28);
        montyNum.font = font_size(12);
        montyNum.textAlignment = NSTextAlignmentRight;
        [self.orderMoneyView addSubview:montyNum];
        maxHeight = CGRectGetMaxY(moneyTitle.frame);
    }
}

- (void)orderDetailClothes:(NSString*)orderDays{
    self.orderTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.orderMoneyView.bottom+5, MainView_Width, 70*kPercenX*self.orderClothesArr.count) style:UITableViewStylePlain];
    self.orderTabelView.delegate = self;
    self.orderTabelView.dataSource = self;
    self.orderTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.orderTabelView.backgroundColor = [UIColor redColor];
    self.orderTabelView.showsVerticalScrollIndicator = NO;
    self.orderTabelView.scrollEnabled = NO;
    [self.orderBackScorllView addSubview:self.orderTabelView];
    [self.orderTabelView reloadData];
    
    self.rantDaysView = [[UIView alloc]initWithFrame:CGRectMake(0, self.orderTabelView.bottom+5, self.orderBackScorllView.width, 40)];
    self.rantDaysView.backgroundColor = [UIColor whiteColor];
    [self.orderBackScorllView addSubview:self.rantDaysView];
    UILabel *rantDaysOnLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.rantDaysView.width, 0.5f)];
    rantDaysOnLine.backgroundColor = WWPageLineColor;
    [self.rantDaysView addSubview:rantDaysOnLine];
    UILabel *rantDaysUpLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.rantDaysView.height-0.5f, self.rantDaysView.width, 0.5f)];
    rantDaysUpLine.backgroundColor = WWPageLineColor;
    [self.rantDaysView addSubview:rantDaysUpLine];
    UILabel *rantDaysLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, self.rantDaysView.height)];
    rantDaysLab.text = @"租凭天数";
    rantDaysLab.textColor = WWContentTextColor;
    rantDaysLab.font = font_size(12);
    [self.rantDaysView addSubview:rantDaysLab];
    UILabel *rantDaysNum = [[UILabel alloc]initWithFrame:CGRectMake(self.rantDaysView.width-110, 0, 100, self.rantDaysView.height)];
    rantDaysNum.text = [NSString stringWithFormat:@"%@天",orderDays];
    rantDaysNum.textColor = WWContentTextColor;
    rantDaysNum.font = font_size(12);
    rantDaysNum.textAlignment = NSTextAlignmentRight;
    [self.rantDaysView addSubview:rantDaysNum];
    
    self.orderBackScorllView.contentSize = CGSizeMake(MainView_Width, self.orderNumberView.height+self.orderMoneyView.height+self.orderTabelView.height+self.rantDaysView.height+40);

}

- (void)viewWillAppear:(BOOL)animated{
    [self.orderTabelView reloadData];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderClothesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellString = @"cellId";
    WWWantRentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (cell == nil) {
        cell = [[WWWantRentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    if (indexPath.row < self.orderClothesArr.count) {
        WWWantRantModel *model = [self.orderClothesArr objectAtIndex:indexPath.row];
        [cell wantRentClothesReqeuestData:model];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70*kPercenX;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
