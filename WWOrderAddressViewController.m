//
//  WWOrderAddressViewController.m
//  WWSampleProject
//
//  Created by push on 15/10/21.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWOrderAddressViewController.h"
#import "WWAddRessTableViewCell.h"
#import "WWAddRessModel.h"
#import "HTTPClient+Other.h"
#import "RadioButton.h"
#import "WWAddShippingAddressViewController.h"

@interface WWOrderAddressViewController ()<UITableViewDelegate,UITableViewDataSource>{
    WWPublicNavtionBar *navTionBarView;
    NSMutableArray *arrSelectBtn;
}

@property (nonatomic,strong)UITableView         *addRessTableView;
@property (nonatomic,strong)NSMutableArray      *addRessArray;

@end

@implementation WWOrderAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WW_BASE_COLOR;
    self.addRessArray = [NSMutableArray new];
    arrSelectBtn = [NSMutableArray new];
    navTionBarView = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"选择收货地址" withRightBtn:NO withRightBtnPicName:nil withRightBtnSize:CGSizeZero];
    [self.view addSubview:navTionBarView];
    
    UILabel *navLine = [[UILabel alloc]initWithFrame:CGRectMake(0, navTionBarView.height-0.5f, MainView_Width, 0.5f)];
    navLine.backgroundColor = WW_BASE_COLOR;
    [navTionBarView addSubview:navLine];
    
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    navRightBtn.frame = CGRectMake(MainView_Width-40-10, IOS7_Y+(44-20)/2, 40,20);
    [navRightBtn setTitle:@"添加" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:RGBCOLOR(20, 20, 20) forState:UIControlStateNormal];
    navRightBtn.titleLabel.font = font_size(14);
    [navRightBtn addTarget:self action:@selector(navRightClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navRightBtn];

    // 消息通知刷新信息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshUserAddRessInformation:)
                                                 name:WWSaveUserAddress
                                               object:nil];
    
    self.addRessTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, IOS7_Y+44, MainView_Width, MainView_Height-IOS7_Y-44) style:UITableViewStylePlain];
    self.addRessTableView.delegate = self;
    self.addRessTableView.dataSource = self;
    self.addRessTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.addRessTableView.backgroundColor = [UIColor clearColor];
    self.addRessTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.addRessTableView];
    // 添加下拉刷新控件
    
    self.addRessTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.addRessArray removeAllObjects];
        [arrSelectBtn removeAllObjects];
        //
        [FMHTTPClient GetUserAddRessListUserId:[WWUtilityClass getNSUserDefaults:UserID] WithCompletion:^(WebAPIResponse *response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (response.code == WebAPIResponseCodeSuccess) {
                    NSArray *resultArr = [response.responseObject objectForKey:@"result"];
                    for (NSDictionary *dic in resultArr) {
                        WWAddRessModel *model = [WWAddRessModel initWithUserAddRessModel:dic];
                        [self.addRessArray addObject:model];
                    }
                    if (self.addRessArray.count == 0) {
                        WWAddShippingAddressViewController *addVC = [[WWAddShippingAddressViewController alloc]init];
                        [self.navigationController pushViewController:addVC animated:YES];
                    }
                    [self.addRessTableView reloadData];
                    [self.addRessTableView.header endRefreshing];
                }
            });

        }];

    }];
    [self.addRessTableView.header beginRefreshing];
    
}

- (void)refreshUserAddRessInformation:(NSNotification *)notification{
    [self.addRessTableView.header beginRefreshing];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addRessArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellString = @"cellId";
    WWAddRessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (cell == nil) {
        cell = [[WWAddRessTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    RadioButton *radio = [[RadioButton alloc]init];
    [radio setBackgroundImage:[WWUtilityClass imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [radio setBackgroundImage:[WWUtilityClass imageWithColor:RGBCOLOR(5, 178, 15)] forState:UIControlStateSelected];
    radio.layer.cornerRadius = 20*kPercenX/2;
    radio.layer.borderColor = RGBCOLOR(128, 128, 128).CGColor;
    radio.layer.borderWidth = 1;
    radio.layer.masksToBounds = YES;
    radio.tag = indexPath.row;
    [radio addTarget:self action:@selector(selectBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [arrSelectBtn addObject:radio];
    //设置默认
    if (indexPath.row==0) {
        [radio setSelected:YES];
    }
    //设置单选组
    if (indexPath.row==arrSelectBtn.count-1) {
        radio.groupButtons = arrSelectBtn;
    }
    
    radio.frame = CGRectMake(cell.backView.width-16*kPercenX-24, (cell.backView.height-20*kPercenX)/2, iphone_size_scale(20), iphone_size_scale(20));
    [cell.backView addSubview:radio];

    
    if (indexPath.row < self.addRessArray.count) {
        WWAddRessModel *model = [self.addRessArray objectAtIndex:indexPath.row];
        [cell initRequestAddRessData:model];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76*kPercenX;
}

#pragma mark 提交编辑操作时会调用这个方法(删除，添加)
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 删除操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WWAddRessModel *model = [self.addRessArray objectAtIndex:indexPath.row];
        [FMHTTPClient GEtDeleteUserAddressId:model.addressId WithCompletion:^(WebAPIResponse *response) {
            if (response.code == WebAPIResponseCodeSuccess) {
                NSLog(@"删除成功");
            }
        }];
        
        // 1.删除数据
        [self.addRessArray removeObjectAtIndex:indexPath.row];
        
        // 2.更新UITableView UI界面
        // [tableView reloadData];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
       
    }
}

#pragma mark 只有实现这个方法，编辑模式中才允许移动Cell
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // 更换数据的顺序
    [self.addRessArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

- (void)selectBtnClickEvent:(RadioButton *)sender{
    if (sender.tag < self.addRessArray.count) {
        WWAddRessModel *model = [self.addRessArray objectAtIndex:sender.tag];
        self.userOrderAddressBlock(model);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)navRightClickEvent:(UIButton *)sender{
    WWAddShippingAddressViewController *addVC = [[WWAddShippingAddressViewController alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
