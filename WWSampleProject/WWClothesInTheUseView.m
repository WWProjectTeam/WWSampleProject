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
     //   self.clothesUseTableView = [UITableView alloc]initWithFrame:CGRectMake(0, 0, <#CGFloat width#>, <#CGFloat height#>) style:<#(UITableViewStyle)#>
        self.backgroundColor = WW_BASE_COLOR;
        self.clothesUseArray = [NSMutableArray new];
//        if ([[WWUtilityClass getNSUserDefaults:UserVipID] intValue] != 1) {
//            return self;
//        }
        self.clothesUseTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        self.clothesUseTableView.delegate = self;
        self.clothesUseTableView.dataSource = self;
        self.clothesUseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.clothesUseTableView.backgroundColor = [UIColor clearColor];
        self.clothesUseTableView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.clothesUseTableView];
        
        self.clothesHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainView_Width, 44*kPercenX)];
        self.clothesHeaderView.backgroundColor = [UIColor clearColor];
        self.clothesUseTableView.tableHeaderView = self.clothesHeaderView;
        
        UILabel *endTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.clothesHeaderView.width-20, self.clothesHeaderView.height)];
        endTimeLab.font = font_size(12);
        endTimeLab.textColor = WWContentTextColor;
        [self.clothesHeaderView addSubview:endTimeLab];
        
        // 添加下拉刷新控件
        
        self.clothesUseTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.clothesUseArray removeAllObjects];
            //
            [FMHTTPClient GetWardrobeIsGoodsUserId:[WWUtilityClass getNSUserDefaults:UserID] WithCompletion:^(WebAPIResponse *response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (response.code == WebAPIResponseCodeSuccess) {
                        NSDictionary *resultDic = [response.responseObject objectForKey:@"result"];
                        endTimeLab.text = [resultDic objectForKey:@"endTime"];
                        NSArray *clientWardrobesArr = [resultDic objectForKey:@"clientWardrobes"];
                        for (NSDictionary *dic in clientWardrobesArr) {
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
    return 75*kPercenX;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.clothesUseArray.count) {
        WWClothesUseModel *model = [self.clothesUseArray objectAtIndex:indexPath.row];
        self.clothesInTheUseDidSelectItemBlock(model.clothes_id);
    }
}

@end
