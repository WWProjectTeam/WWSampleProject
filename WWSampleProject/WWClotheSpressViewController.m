//
//  WWClotheSpressViewController.m
//  WWSampleProject
//
//  Created by ww on 15/10/13.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWClotheSpressViewController.h"
#import "WWWantWearView.h"
#import "WWVIPPackageViewController.h"
#import "WWClothesInTheUseView.h"
#import "HTTPClient+Other.h"
#import "WWHomePageViewController.h"
#import "WWProductDetailViewController.h"
#import "WWOrderViewController.h"

@interface WWClotheSpressViewController ()<UIScrollViewDelegate>{
    WWPublicNavtionBar *navtionBarView;
    WWClothesInTheUseView *useVC;
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
    
    if (self.IsHomePush == YES) {
        navtionBarView = [[WWPublicNavtionBar alloc] initWithLeftBtn:YES withTitle:@"衣柜" withRightBtn:NO withRightBtnPicName:nil withRightBtnSize:CGSizeZero];
    }else{
        navtionBarView = [[WWPublicNavtionBar alloc] initWithLeftBtn:NO withTitle:@"衣柜" withRightBtn:NO withRightBtnPicName:nil withRightBtnSize:CGSizeZero];
    }
    [self.view addSubview:navtionBarView];
    
    [self clothesViewLayout];
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
        [buttton setTitle:@"想穿" forState:UIControlStateNormal];
        [buttton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buttton setTitleColor:RGBCOLOR(128, 128, 128) forState:UIControlStateSelected];
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
        [buttton setTitle:@"使用中" forState:UIControlStateNormal];
        [buttton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buttton setTitleColor:RGBCOLOR(128, 128, 128) forState:UIControlStateSelected];
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
    WWWantWearView *wantVC = [[WWWantWearView alloc]initWithFrame:CGRectMake(0, 0, MainView_Width, self.clothesScrollView.height)];
    // 立即拥有
    wantVC.settlementBtnClickBlock = ^{
        WWOrderViewController *orderVC = [[WWOrderViewController alloc]init];
        [self.navigationController pushViewController:orderVC animated:YES];
    };
    // 购买VIP
    wantVC.wantWearBtnClickBlock = ^{
        WWVIPPackageViewController *vipVC = [[WWVIPPackageViewController alloc]init];
        [weakSelf.navigationController pushViewController:vipVC animated:YES];
    };
    // 删除按钮
    wantVC.collectionCellDelegateBlock = ^(NSString *clothesCode){
        [FMHTTPClient GetDelegateWardrobeGoodsUserId:[WWUtilityClass getNSUserDefaults:UserID] andCode:clothesCode WithCompletion:^(WebAPIResponse *response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (response.code == WebAPIResponseCodeSuccess) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:WWDelegateWantWearGoods object:nil];
                }
            });
        }];
    };
    // 点击item
    wantVC.collectionDidSelectItemBlock = ^(NSString *clothes_id){
        if ([clothes_id isEqualToString:@""]) {
            WWHomePageViewController *homeVC = [[WWHomePageViewController alloc]init];
            homeVC.IsClothesSpressPush = YES;
            [weakSelf.navigationController pushViewController:homeVC animated:YES];
        }else{
            WWProductDetailViewController *productDetailVC = [[WWProductDetailViewController alloc]init];
            productDetailVC.strProductId = clothes_id;
            [weakSelf.navigationController pushViewController:productDetailVC animated:YES];
        }
    };
    [self.clothesScrollView addSubview:wantVC];
#pragma mark ---- 使用中
    useVC = [[WWClothesInTheUseView alloc]initWithFrame:CGRectMake(MainView_Width, 0, MainView_Width, self.clothesScrollView.height)];
    // 点击item
    useVC.clothesInTheUseDidSelectItemBlock = ^(NSString *clothesId){
        WWProductDetailViewController *productDetailVC = [[WWProductDetailViewController alloc]init];
        productDetailVC.strProductId = clothesId;
        [weakSelf.navigationController pushViewController:productDetailVC animated:YES];
    };
    [self.clothesScrollView addSubview:useVC];
    
}

- (void)viewWillAppear:(BOOL)animated{
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
