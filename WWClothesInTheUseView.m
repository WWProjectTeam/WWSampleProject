//
//  WWClothesInTheUseView.m
//  WWSampleProject
//
//  Created by push on 15/10/20.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWClothesInTheUseView.h"
#import "WWClothesUseTableViewCell.h"
#import "WWClothesUseModel.h"
#import "HTTPClient+Other.h"

@interface WWClothesInTheUseView ()<UITableViewDataSource,UITableViewDelegate>



@property (nonatomic,strong)NSMutableArray      *clothesUseArray;

@property (nonatomic,strong)UIView              *clothesHeaderView;

@end

@implementation WWClothesInTheUseView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = WW_BASE_COLOR;
        self.clothesUseArray = [NSMutableArray new];

        self.clothesUseTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        self.clothesUseTableView.delegate = self;
        self.clothesUseTableView.dataSource = self;
        self.clothesUseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.clothesUseTableView.backgroundColor = [UIColor clearColor];
        self.clothesUseTableView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.clothesUseTableView];
        
        // 添加下拉刷新控件
        NSString *orderId = @"1";
        if (self.myOrder == NO) {
            orderId = @"0";
        }else{
            orderId = @"1";
        }
        self.clothesUseTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.clothesUseArray removeAllObjects];
            //
            [FMHTTPClient GetuserOrderListUserId:[WWUtilityClass getNSUserDefaults:UserID] orderId:orderId WithCompletion:^(WebAPIResponse *response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (response.code == WebAPIResponseCodeSuccess) {
                        NSArray *resultArr = [response.responseObject objectForKey:@"result"];
                        for (NSDictionary *dic in resultArr) {
                            WWClothesUseModel *model = [WWClothesUseModel initWithClothesModel:dic];
                            [self.clothesUseArray addObject:model];
                        }
                        [self.clothesUseTableView reloadData];
                        [self.clothesUseTableView.header endRefreshing];
                    }
                });
            }];
        }];
        [self.clothesUseTableView.header beginRefreshing];
    }
    return self;
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.clothesUseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellString = @"cellId";
    WWClothesUseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (cell == nil) {
        cell = [[WWClothesUseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
        cell.backgroundColor = [UIColor clearColor];
    }
    if (indexPath.row < self.clothesUseArray.count) {
        WWClothesUseModel *model = [self.clothesUseArray objectAtIndex:indexPath.row];
        [cell initRequestClothesDetailData:model];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100*kPercenX;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.clothesUseArray.count) {
        WWClothesUseModel *model = [self.clothesUseArray objectAtIndex:indexPath.row];
        self.clothesInTheUseDidSelectItemBlock(model.clothes_id);
    }
}

@end
