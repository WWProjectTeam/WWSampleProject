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
        //
        [FMHTTPClient GetUserAddRessListUserId:@"1000" WithCompletion:^(WebAPIResponse *response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (response.code == WebAPIResponseCodeSuccess) {
                    NSArray *resultArr = [response.responseObject objectForKey:@"result"];
         
                    for (NSDictionary *dic in resultArr) {
                        WWAddRessModel *model = [WWAddRessModel initWithUserAddRessModel:dic];
                        [self.addRessArray addObject:model];
                    }
                    [self.addRessTableView reloadData];
                    [self.addRessTableView.header endRefreshing];
                }
            });

        }];

    }];
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
    }
    cell.addRessSelectBtnClickBlock= ^{
        
    };
    
    RadioButton *radio = [[RadioButton alloc]init];
    [radio setTitleColor:WWSubTitleTextColor forState:UIControlStateNormal];
    [radio setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [radio setImage:[UIImage imageNamed:@"btn_zf_n@3x"] forState:UIControlStateNormal];
    [radio setImage:[UIImage imageNamed:@"btn_zf_c@3x"] forState:UIControlStateSelected];
//    [radio addTarget:self action:@selector(selectBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [arrSelectBtn addObject:radio];
    //设置默认
    if (indexPath.row==0) {
        [radio setSelected:YES];
    }
    //设置单选组
    if (indexPath.row==arrSelectBtn.count-1) {
        radio.groupButtons = arrSelectBtn;
    }
    
    radio.frame = CGRectMake(cell.backView.width-14*kPercenX-24, (cell.backView.height-14*kPercenX)/2, iphone_size_scale(14), iphone_size_scale(14));
    [cell.backView addSubview:radio];

    
    if (indexPath.row < self.addRessArray.count) {
        WWAddRessModel *model = [self.addRessArray objectAtIndex:indexPath.row];
        [cell initRequestAddRessData:model];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81*kPercenX;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.addRessArray.count) {
        WWAddRessModel *model = [self.addRessArray objectAtIndex:indexPath.row];
        
    }
}

#pragma mark 提交编辑操作时会调用这个方法(删除，添加)
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 删除操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
