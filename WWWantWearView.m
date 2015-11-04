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

@property (nonatomic,strong)UIView  *chooseView;

@end

@implementation WWWantWearView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = WW_BASE_COLOR;
        self.clothesArray = [NSMutableArray new];
        num = 1;
        
        [self clotheNumLayout:frame];
        
        
        
    }
    return self;
}

- (void)refreshView{
    if (self.clothesArray.count == 0) {
        self.clothesBackView.hidden = YES;
        [self clothesNotNum:CGRectMake(0, 0, MainView_Width, self.size.height)];
        self.chooseView.hidden = NO;
        return;
    }else{
        self.clothesBackView.hidden = NO;
        self.chooseView.hidden = YES;
    }
}

// 衣柜有衣服的时候
- (void)clotheNumLayout:(CGRect)frame{
    self.clothesBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainView_Width, frame.size.height)];
    self.clothesBackView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.clothesBackView];
    // 添加数量
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.clothesBackView.width, 46)];
    [self.clothesBackView addSubview:view];
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
    
    self.clothesTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, view.bottom, MainView_Width, self.clothesBackView.height-45-50) style:UITableViewStylePlain];
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
    [self.settlementBtn addTarget:self action:@selector(settlementClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [bottonView addSubview:self.settlementBtn];

}

// 衣柜为空的时候
- (void)clothesNotNum:(CGRect)frame{
    self.chooseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainView_Width, frame.size.height)];
    self.chooseView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.chooseView];
    UILabel *prompt = [[UILabel alloc]initWithFrame:CGRectMake((self.chooseView.width-170)/2, 145, 170, 13)];
    prompt.text = @"现在还没有想租的衣服哦";
    prompt.textColor = WWContentTextColor;
    prompt.font = font_size(13);
    [self.chooseView addSubview:prompt];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake((self.chooseView.width-100)/2, prompt.bottom+15, 100, 44);
    [button setTitle:@"挑选衣服" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = WWBtnYellowColor;
    [button setBackgroundImage:[WWUtilityClass imageWithColor:RGBCOLOR(211, 120, 23)] forState:UIControlStateHighlighted];
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(chooseClothesClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.chooseView addSubview:button];
}

- (void)chooseClothesClick:(UIButton *)sender{
    if (self.chooseClothesBtnBlock) {
        self.chooseClothesBtnBlock();
    }
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
#pragma mark 提交编辑操作时会调用这个方法(删除，添加)
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 删除操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WWWantRantModel *model = [self.clothesArray objectAtIndex:indexPath.row];
        [FMHTTPClient GetDelegateWardrobeGoodsUserId:[WWUtilityClass getNSUserDefaults:UserID] andCode:model.code WithCompletion:^(WebAPIResponse *response) {
            if (response.code == WebAPIResponseCodeSuccess) {
                NSLog(@"删除成功");
                if (self.clothesArray.count == 0) {
                    [self.clothesTabelView.header beginRefreshing];
                }
            }
        }];
        
        // 1.删除数据
        [self.clothesArray removeObjectAtIndex:indexPath.row];
        
        // 2.更新UITableView UI界面
        // [tableView reloadData];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.clothesArray.count) {
        WWWantRantModel *model = [self.clothesArray objectAtIndex:indexPath.row];
        self.wantRantTableCellSelectBlock(model.id_s);
    }

}

#pragma mark 只有实现这个方法，编辑模式中才允许移动Cell
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // 更换数据的顺序
    [self.clothesArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70*kPercenX;
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

- (void)settlementClickEvent:(UIButton *)sender{
    if (self.wantWearOrderBtnClickBlock) {
        self.wantWearOrderBtnClickBlock(self.clothesDic,num);
    }
}

@end
