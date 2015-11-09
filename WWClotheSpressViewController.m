//
//  WWClotheSpressViewController.m
//  WWSampleProject
//
//  Created by ww on 15/10/13.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWClotheSpressViewController.h"
#import "WWWantWearView.h"
#import "WWClothesInTheUseView.h"
#import "HTTPClient+Other.h"
#import "WWHomePageViewController.h"
#import "WWMyOrderDetailViewController.h"
#import "WWOrderViewController.h"
#import "WWWantRantModel.h"
#import "WWProductDetailViewController.h"
////MSGCENTER
#import "WWMessageCenterViewController.h"


@interface WWClotheSpressViewController ()<UIScrollViewDelegate,HomePageNavtionDelegate>{
    WWPublicNavtionBar *navtionBarView;
    WWClothesInTheUseView *useVC;
    WWWantWearView *wantVC;
}

@property (nonatomic,strong)        UIView              *clockbakcGroupView;
@property (nonatomic,strong)        UIButton            *clockDynamicButton;
@property (nonatomic,strong)        UIButton            *clockNumberButton;
@property (nonatomic,strong)        UILabel             *clockChooseLabel;
@property (nonatomic,strong)        UIScrollView        *clothesScrollView;

@end

@implementation WWClotheSpressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = WW_BASE_COLOR;
    
    navtionBarView = [[WWPublicNavtionBar alloc]initHomePageNavtion:@"租衣" flay:NO];
    [navtionBarView setHomePageNavtionDelegate:self];
    if (self.IsHomePush == YES) {
        navtionBarView = [[WWPublicNavtionBar alloc] initWithLeftBtn:YES withTitle:@"租衣" withRightBtn:NO withRightBtnPicName:nil withRightBtnSize:CGSizeZero];
    }
    [self.view addSubview:navtionBarView];
    
    [self clothesViewLayout];
    
    // 推送通知消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refrshNotification:) name:WWRefreshInformationNum object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshWantWearClothesNum:)
                                                 name:WWRefreshUserInformation
                                               object:nil];
}

- (void)refreshWantWearClothesNum:(NSNotification *)notification{
    [wantVC.clothesTabelView.header beginRefreshing];
}

- (void)clothesViewLayout{
    // 选择view
    self.clockbakcGroupView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, IOS7_Y+44, MainView_Width, 40)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        view;
    });
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, self.clockbakcGroupView.height-0.5f, self.clockbakcGroupView.width, 0.5f)];
    line.backgroundColor = WWPageLineColor;
    [self.clockbakcGroupView addSubview:line];
    UILabel *upLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.clockbakcGroupView.width, 0.5f)];
    upLine.backgroundColor = WWPageLineColor;
    [self.clockbakcGroupView addSubview:upLine];
    UILabel *centerLine = [[UILabel alloc]initWithFrame:CGRectMake(self.clockbakcGroupView.width/2, (self.clockbakcGroupView.height-28)/2, 0.5f, 28)];
    centerLine.backgroundColor = WWPageLineColor;
    [self.clockbakcGroupView addSubview:centerLine];
    
    // 最新动态
    self.clockDynamicButton = ({
        UIButton *buttton = [UIButton buttonWithType:UIButtonTypeCustom];
        buttton.frame = CGRectMake(0, 0, self.clockbakcGroupView.width/2, self.clockbakcGroupView.height);
        [buttton setTitle:@"想租" forState:UIControlStateNormal];
        [buttton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [buttton setTitleColor:RGBCOLOR(128, 128, 128) forState:UIControlStateNormal];
        buttton.titleLabel.font = [UIFont systemFontOfSize:13*kPercenX];
        [buttton addTarget:self action:@selector(clockJumpToDynamic) forControlEvents:UIControlEventTouchUpInside];
        [self.clockbakcGroupView addSubview:buttton];
        buttton.selected = YES;
        buttton;
    });
    // 在线xxxx
    self.clockNumberButton = ({
        UIButton *buttton = [UIButton buttonWithType:UIButtonTypeCustom];
        buttton.frame = CGRectMake(self.clockbakcGroupView.width/2, 0, self.clockbakcGroupView.width/2, self.clockbakcGroupView.height);
        [buttton setTitle:@"已租凭" forState:UIControlStateNormal];
        [buttton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [buttton setTitleColor:RGBCOLOR(128, 128, 128) forState:UIControlStateNormal];
        buttton.titleLabel.font = [UIFont systemFontOfSize:13*kPercenX];
        [buttton addTarget:self action:@selector(clockJumpToNumber) forControlEvents:UIControlEventTouchUpInside];
        [self.clockbakcGroupView addSubview:buttton];
        buttton;
    });
    // 加载指示线条
    self.clockChooseLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.clockbakcGroupView.height-2, self.clockbakcGroupView.width/2, 2)];
        label.backgroundColor = RGBCOLOR(244, 162, 28);
        [self.clockbakcGroupView addSubview:label];
        label;
    });
    
    self.clothesScrollView = ({
        UIScrollView *scrllView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.clockbakcGroupView.bottom, MainView_Width, MainView_Height-self.clockbakcGroupView.height-IOS7_Y-44-49)];
        scrllView.contentSize = CGSizeMake(MainView_Width*2, 0);
        scrllView.scrollEnabled = NO;
        scrllView.bounces = NO;
        scrllView.delegate = self;
        scrllView.showsHorizontalScrollIndicator = NO;
        scrllView.showsVerticalScrollIndicator = NO;
        scrllView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:scrllView];
        scrllView;
    });
    if (self.IsHomePush == YES) {
        self.clothesScrollView.frame = CGRectMake(0, self.clockbakcGroupView.bottom, MainView_Width, MainView_Height-self.clockbakcGroupView.height-IOS7_Y-44);
    }
    //创建滑动手势
    UISwipeGestureRecognizer *recogizerRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    recogizerRight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.clothesScrollView addGestureRecognizer:recogizerRight];
    UISwipeGestureRecognizer *recogizerLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    recogizerLeft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.clothesScrollView addGestureRecognizer:recogizerLeft];
#pragma mark ---- 想穿
    __weak __typeof(&*self)weakSelf = self;
    wantVC = [[WWWantWearView alloc]initWithFrame:CGRectMake(0, 0, MainView_Width, self.clothesScrollView.height)];
    wantVC.wantWearOrderBtnClickBlock = ^(NSDictionary *dic,int days){
        WWOrderViewController *order = [[WWOrderViewController alloc]init];
        order.orderDataDic = dic;
        order.days = days;
        [weakSelf.navigationController pushViewController:order animated:YES];
    };
    wantVC.chooseClothesBtnBlock = ^{
        AppDelegate * appdelegate = (AppDelegate * )[UIApplication sharedApplication].delegate;
        [appdelegate.tabBarController setSelectedIndex:0];
//        WWHomePageViewController *homeVC = [[WWHomePageViewController alloc]init];
//        homeVC.IsClothesSpressPush = YES;
//        [weakSelf.navigationController pushViewController:homeVC animated:YES];
    };
    wantVC.wantRantTableCellSelectBlock = ^(NSString *id_s){
        WWProductDetailViewController *productVC = [[WWProductDetailViewController alloc]init];
        productVC.strProductId = id_s;
        [weakSelf.navigationController pushViewController:productVC animated:YES];
    };
   [self.clothesScrollView addSubview:wantVC];
#pragma mark ---- 使用中
    
    useVC = [[WWClothesInTheUseView alloc]initWithFrame:CGRectMake(MainView_Width, 0, MainView_Width, self.clothesScrollView.height)];
    // 点击item
    useVC.clothesInTheUseDidSelectItemBlock = ^(NSString *clothesId){
        WWMyOrderDetailViewController *orderDetailVC = [[WWMyOrderDetailViewController alloc]init];
        orderDetailVC.orderId = clothesId;
        [weakSelf.navigationController pushViewController:orderDetailVC animated:YES];
    };
    useVC.clothesSelectPayBlock = ^(NSString *id_s){
        [SVProgressHUD showInfoWithStatus:@"服务器又返回错误"];
    };
    [self.clothesScrollView addSubview:useVC];
    
    __weak UITableView *tableView = wantVC.clothesTabelView;
    
    // 添加下拉刷新控件
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [wantVC.clothesArray removeAllObjects];
        //
        [FMHTTPClient GetWardrobeGoodsUserId:[WWUtilityClass getNSUserDefaults:UserID] WithCompletion:^(WebAPIResponse *response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (response.code == WebAPIResponseCodeSuccess) {
                    
                    wantVC.clothesDic = [response.responseObject objectForKey:@"result"];
                    
                    double otherContentDouble = [[wantVC.clothesDic objectForKey:@"deposit"] doubleValue];
                    wantVC.otherContentLab.text = [NSString stringWithFormat:@"押金:￥%.2f",otherContentDouble];
                    double rantMoneyDouble = [[wantVC.clothesDic objectForKey:@"leaseCost"] doubleValue];
                    wantVC.rantMoneyLab.text = [NSString stringWithFormat:@"租金￥%.2f从押金扣除",rantMoneyDouble];
                    
                    NSArray *clientWardrobes = [wantVC.clothesDic objectForKey:@"clientWardrobes"];
                    for (NSDictionary *dic in clientWardrobes) {
                        WWWantRantModel *model = [WWWantRantModel initWithClothesRequestData:dic];
                        [wantVC.clothesArray addObject:model];
                    }
                    [wantVC.settlementBtn setTitle:[NSString stringWithFormat:@"结算（%d）",wantVC.clothesArray.count] forState:UIControlStateNormal];
                    [wantVC refreshView];
                    [wantVC.clothesTabelView reloadData];
                    [wantVC.clothesTabelView.header endRefreshing];
                }
            });
        }];
    }];
    
    [wantVC.clothesTabelView.header beginRefreshing];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [wantVC.clothesTabelView reloadData];
    [useVC.clothesUseTableView reloadData];
}

/**
 *  选择button触发事件
 */
- (void)clockJumpToDynamic{
    [UIView animateWithDuration:0.3 animations:^{
        [self.clothesScrollView setContentOffset:CGPointMake(0, 0)];
        self.clockDynamicButton.selected = YES;
        self.clockNumberButton.selected = NO;
        self.clockChooseLabel.frame = CGRectMake(0, self.clockbakcGroupView.height-2, self.clockbakcGroupView.width/2, 2);
    }];
    
}

- (void)clockJumpToNumber{
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.clothesScrollView setContentOffset:CGPointMake(MainView_Width, 0)];
        self.clockDynamicButton.selected = NO;
        self.clockNumberButton.selected = YES;
        self.clockChooseLabel.frame = CGRectMake(self.clockbakcGroupView.width/2, self.clockbakcGroupView.height-2, self.clockbakcGroupView.width/2, 2);
    }];
}


#pragma mark --- 手势滑动改变界面刷新请求数据
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)swipeGesture{
    
    if (swipeGesture.direction == UISwipeGestureRecognizerDirectionRight) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.clothesScrollView setContentOffset:CGPointMake(0, 0)];
            self.clockDynamicButton.selected = YES;
            self.clockNumberButton.selected = NO;
            self.clockChooseLabel.frame = CGRectMake(0, self.clockbakcGroupView.height-2, self.clockbakcGroupView.width/2, 2);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self.clothesScrollView setContentOffset:CGPointMake(MainView_Width, 0)];
            self.clockDynamicButton.selected = NO;
            self.clockNumberButton.selected = YES;
            self.clockChooseLabel.frame = CGRectMake(self.clockbakcGroupView.width/2, self.clockbakcGroupView.height-2, self.clockbakcGroupView.width/2, 2);
        }];
    }
}


// 刷新铃铛数
- (void)refrshNotification:(NSNotification*)notification{
    [navtionBarView HomePageSetMsgNum:1];
}
//点击消息
-(void)rightBtnSelect{
    if ([AppDelegate isAuthentication]) {
        [navtionBarView HomePageSetMsgNum:0];
        WWMessageCenterViewController * MsgVc = [[WWMessageCenterViewController alloc]init];
        [self.navigationController pushViewController:MsgVc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
