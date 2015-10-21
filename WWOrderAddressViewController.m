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

@interface WWOrderAddressViewController ()<UITableViewDelegate,UITableViewDataSource>{
    WWPublicNavtionBar *navTionBarView;
}

@property (nonatomic,strong)UITableView         *addRessTableView;
@property (nonatomic,strong)NSMutableArray      *addRessArray;

@end

@implementation WWOrderAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WW_BASE_COLOR;
    self.addRessArray = [NSMutableArray new];
    
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

//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
//    // 删除的操作
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        [_titleArray removeObjectAtIndex:indexPath.row];
//        [_icoArray removeObjectAtIndex:indexPath.row];
//        
//        
//        NSArray *indexPaths = @[indexPath]; // 构建 索引处的行数 的数组
//        // 删除 索引的方法 后面是动画样式
//        [self.addRessTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationLeft)];
//
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
