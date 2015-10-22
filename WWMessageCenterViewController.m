//
//  WWMessageCenterViewController.m
//  WWSampleProject
//
//  Created by ww on 15/10/22.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWMessageCenterViewController.h"
#import "WWPublicNavtionBar.h"
#import "HTTPClient+Other.h"

#import "WWMessageListTableViewCell.h"


#import "WWMessageDetialViewController.h"
@interface WWMessageCenterViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray * arrMsgList;
}

@end

@implementation WWMessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    WWPublicNavtionBar * navBar = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"消息" withRightBtn:NO withRightBtnPicName:nil withRightBtnSize:CGSizeZero];
    
    [self.view addSubview:navBar];
    
    [self.view setBackgroundColor:RGBCOLOR(242, 242, 242)];

    
    
    UITableView * tableView = [[UITableView alloc]init];
    [tableView setFrame:CGRectMake(0, IOS7_Y+44,MainView_Width , MainView_Height-IOS7_Y-44)];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
     tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [tableView setBackgroundColor:RGBCOLOR(242, 242, 242)];
    [self.view addSubview:tableView];
    
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [[HTTPClient sharedHTTPClient]GetUserFirstMsgWithCompletion:^(WebAPIResponse *operation) {
            
            
            NSDictionary * dict = operation.responseObject[@"result"];
            arrMsgList = [NSMutableArray arrayWithArray:dict[@"list"]];

            [tableView reloadData];

            [tableView.header endRefreshing];
            
        }];

    }];
    [tableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView Delegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrMsgList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    WWMessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WWMessageListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.labelContent.text = arrMsgList[indexPath.row][@"content"];
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WWMessageDetialViewController * MsgVC = [[WWMessageDetialViewController alloc]init];
    [self.navigationController pushViewController:MsgVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return iphone_size_scale(80);
}

@end
