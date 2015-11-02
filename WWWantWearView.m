//
//  WWWantWearView.m
//  WWSampleProject
//
//  Created by push on 15/10/20.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWWantWearView.h"
#import "HTTPClient+Other.h"
#import "WWProductDetailViewController.h"
#import "WWWantRentTableViewCell.h"
#import "WWWantRantModel.h"

@interface WWWantWearView ()<UITableViewDataSource,UITableViewDelegate>{
    NSDictionary *clothesRequestDataDic;
    UILabel *clothesNum;
    int num;
}

@property (nonatomic,strong)UIView                      *clothesBackView;

@property (nonatomic,strong)UILabel                     *otherContentLab;
@property (nonatomic,strong)UILabel                     *rantMoneyLab;
@property (nonatomic,strong)UIButton                    *settlementBtn;

@end

@implementation WWWantWearView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = WW_BASE_COLOR;
        self.clothesArray = [NSMutableArray new];
        num = 1;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshWantWearClothesNum:)
                                                     name:WWDelegateWantWearGoods
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshWantWearClothesNum:)
                                                     name:WWRefreshUserInformation
                                                   object:nil];
        
        [self clotheNumLayout:frame];
        
    }
    return self;
}

// 衣柜为空的时候
- (void)clothesNotNum{
    
}

// 衣柜有衣服的时候
- (void)clotheNumLayout:(CGRect)frame{
    self.clothesBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainView_Width, frame.size.height)];
    self.clothesBackView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.clothesBackView];
    // 添加数量
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.clothesBackView.width, 46)];
    [self addSubview:view];
    UILabel *upLine = [[UILabel alloc]initWithFrame:CGRectMake(0, view.height-0.5f, view.width, 0.5f)];
    upLine.backgroundColor = WWPageLineColor;
    [view addSubview:upLine];
    
    UILabel *rantLab = [[UILabel alloc]initWithFrame:CGRectMake(10, (view.height-13*kPercenX)/2, 100, iphone_size_scale(13))];
    rantLab.textColor = WWContentTextColor;
    rantLab.font = font_size(13);
    rantLab.text = @"租凭天数";
    [view addSubview:rantLab];
    
    UIView *numView = [[UIView alloc]initWithFrame:CGRectMake(view.width-107, (view.height-26)/2, 97, 26)];
    numView.layer.borderColor = WWPageLineColor.CGColor;
    numView.layer.borderWidth = 1.0f;
    [view addSubview:numView];
    UIButton *minBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    minBtn.tag = 10000;
    minBtn.frame = CGRectMake(0, 0, 31, 26);
    [minBtn setImage:[UIImage imageNamed:@"btn_jian_n"] forState:UIControlStateNormal];
    [minBtn addTarget:self action:@selector(clothesNumBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [numView addSubview:minBtn];
    UIButton *maxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    maxBtn.tag = 10001;
    maxBtn.frame = CGRectMake(numView.width-31, 0, 31, 26);
    [maxBtn setImage:[UIImage imageNamed:@"btn_jia_n"] forState:UIControlStateNormal];
    [maxBtn addTarget:self action:@selector(clothesNumBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [numView addSubview:maxBtn];
    
    clothesNum = [[UILabel alloc]initWithFrame:CGRectMake(minBtn.right, 0, numView.width-minBtn.width-maxBtn.width, 26)];
    clothesNum.textAlignment = NSTextAlignmentCenter;
    clothesNum.adjustsFontSizeToFitWidth = YES;
    clothesNum.text = @"1";
    clothesNum.textColor = WWContentTextColor;
    clothesNum.font = font_size(13);
    [numView addSubview:clothesNum];
    
    self.clothesTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, view.bottom, MainView_Width, self.clothesBackView.height-44-46) style:UITableViewStylePlain];
    self.clothesTabelView.delegate = self;
    self.clothesTabelView.dataSource = self;
    self.clothesTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.clothesTabelView.backgroundColor = [UIColor clearColor];
    self.clothesTabelView.showsVerticalScrollIndicator = NO;
    [self.clothesBackView addSubview:self.clothesTabelView];
    
    // 底部view
    UIView *bottonView = [[UIView alloc]initWithFrame:CGRectMake(0, self.clothesBackView.height-44*kPercenX, MainView_Width, iphone_size_scale(44))];
    bottonView.backgroundColor = [UIColor blackColor];
    [self.clothesBackView addSubview:bottonView];
    // 运费+次数
    self.otherContentLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 9, bottonView.width-125*kPercenX-10, iphone_size_scale(12))];
    self.otherContentLab.font = font_size(12);
    self.otherContentLab.textColor = [UIColor whiteColor];
    [bottonView addSubview:self.otherContentLab];
    self.rantMoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(5, self.otherContentLab.bottom+8, self.otherContentLab.width, iphone_size_scale(11))];
    self.rantMoneyLab.textColor = WWSubTitleTextColor;
    self.rantMoneyLab.font = font_size(11);
    [bottonView addSubview:self.rantMoneyLab];
    // 立即拥有
    self.settlementBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    self.settlementBtn.frame = CGRectMake(bottonView.width-125*kPercenX, 0, iphone_size_scale(125), bottonView.height);
    [self.settlementBtn setTitle:@"结算（1）" forState:UIControlStateNormal];
    self.settlementBtn.titleLabel.font = font_size(14);
    self.settlementBtn.backgroundColor = WWBtnYellowColor;
    [self.settlementBtn setBackgroundImage:[WWUtilityClass imageWithColor:RGBCOLOR(211, 120, 23)] forState:UIControlStateHighlighted];
//    [self.settlementBtn addTarget:self action:@selector(settlementClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [bottonView addSubview:self.settlementBtn];
    
    // 添加下拉刷新控件
    self.clothesTabelView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.clothesArray removeAllObjects];
        //
        [FMHTTPClient GetWardrobeGoodsUserId:[WWUtilityClass getNSUserDefaults:UserID] WithCompletion:^(WebAPIResponse *response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (response.code == WebAPIResponseCodeSuccess) {
                    
                    self.clothesDic = [response.responseObject objectForKey:@"result"];
                    
                    self.otherContentLab.text = [NSString stringWithFormat:@"押金：￥%@.00",[self.clothesDic objectForKey:@"deposit"]];
                    self.rantMoneyLab.text = [NSString stringWithFormat:@"租金￥%@.00从押金扣除",[self.clothesDic objectForKey:@"leaseCost"]];
                    
                    NSArray *clientWardrobes = [self.clothesDic objectForKey:@"clientWardrobes"];
                    for (NSDictionary *dic in clientWardrobes) {
                        WWWantRantModel *model = [WWWantRantModel initWithClothesRequestData:dic];
                        [self.clothesArray addObject:model];
                    }
                    [self.settlementBtn setTitle:[NSString stringWithFormat:@"结算（%d）",self.clothesArray.count] forState:UIControlStateNormal];
                    [self.clothesTabelView reloadData];
                    [self.clothesTabelView.header endRefreshing];
                }
            });
        }];
    }];
    
    [self.clothesTabelView.header beginRefreshing];

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.clothesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellStr = @"cellId";
    WWWantRentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[WWWantRentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    
    WWWantRantModel *model = [self.clothesArray objectAtIndex:indexPath.row];
    [cell wantRentClothesReqeuestData:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70*kPercenX;
}

- (void)refreshWantWearClothesNum:(NSNotification *)notification{
    [self.clothesTabelView.header beginRefreshing];
}

- (void)clothesNumBtnClickEvent:(UIButton *)sender{
    
    if (sender.tag == 10000) {
        num--;
        if (num<=1) {
            clothesNum.text = @"1";
            num = 1;
            self.rantMoneyLab.text = [NSString stringWithFormat:@"租金￥%@.00从押金扣除",[self.clothesDic objectForKey:@"leaseCost"]];
            return;
        }
    }else{
        num++;
    }
    clothesNum.text = [NSString stringWithFormat:@"%d",num];
    int money = [[self.clothesDic objectForKey:@"leaseCost"] intValue];
    self.rantMoneyLab.text = [NSString stringWithFormat:@"租金￥%d.00从押金扣除",money*num];
}


@end
