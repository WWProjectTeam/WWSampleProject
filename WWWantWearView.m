//
//  WWWantWearView.m
//  WWSampleProject
//
//  Created by push on 15/10/20.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWWantWearView.h"
#import "WWWantWearCollectionViewCell.h"
#import "HTTPClient+Other.h"
#import "WWProductDetailViewController.h"

#define wantWearCollectionCell      @"wantWearCollectionCell"
#define CollectionCell              @"CollectionCell"

@interface WWWantWearView ()<UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate>{
    NSDictionary *clothesRequestDataDic;
}

@property (nonatomic,strong)UICollectionView            *clothesCollection;
@property (nonatomic,strong)NSMutableArray              *clothesArray;

@property (nonatomic,strong)UILabel                     *otherContentLab;
@property (nonatomic,strong)UIButton                    *settlementBtn;

@end

@implementation WWWantWearView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = WW_BASE_COLOR;
        self.clothesArray = [NSMutableArray new];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshWantWearClothesNum:)
                                                     name:WWDelegateWantWearGoods
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshWantWearClothesNum:)
                                                     name:WWRefreshUserInformation
                                                   object:nil];
        
        //collectView
        UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
        self.clothesCollection  =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height-44*kPercenX) collectionViewLayout:flowLayout];
        [self.clothesCollection setBackgroundColor:[UIColor whiteColor]];
        [self.clothesCollection setDataSource:self];
        [self.clothesCollection setDelegate:self];
        [self.clothesCollection registerClass:[WWWantWearCollectionViewCell class] forCellWithReuseIdentifier:wantWearCollectionCell];
        [self.clothesCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionCell];
        [self.clothesCollection setBackgroundColor:[UIColor clearColor]];
        [self.clothesCollection setShowsHorizontalScrollIndicator:NO];
        [self.clothesCollection setShowsVerticalScrollIndicator:NO];
        [self addSubview:self.clothesCollection];
        // 底部view
        UIView *bottonView = [[UIView alloc]initWithFrame:CGRectMake(0, self.clothesCollection.bottom, frame.size.width, iphone_size_scale(44))];
        bottonView.backgroundColor = [UIColor blackColor];
        bottonView.alpha = 0.8f;
        [self addSubview:bottonView];
        // 运费+次数
        self.otherContentLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, bottonView.width-125*kPercenX-10, bottonView.height)];
        self.otherContentLab.font = font_size(12);
        self.otherContentLab.textColor = [UIColor whiteColor];
        [bottonView addSubview:self.otherContentLab];
        // 立即拥有
        self.settlementBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        self.settlementBtn.frame = CGRectMake(bottonView.width-125*kPercenX, 0, iphone_size_scale(125), bottonView.height);
        [self.settlementBtn setTitle:@"立即拥有" forState:UIControlStateNormal];
        self.settlementBtn.titleLabel.font = font_size(14);
        self.settlementBtn.backgroundColor = WWBtnYellowColor;
        [self.settlementBtn setBackgroundImage:[WWUtilityClass imageWithColor:RGBCOLOR(211, 120, 23)] forState:UIControlStateHighlighted];
        [self.settlementBtn addTarget:self action:@selector(settlementClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [bottonView addSubview:self.settlementBtn];
        
        // 添加下拉刷新控件
        
        self.clothesCollection.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //
            [FMHTTPClient GetWardrobeGoodsUserId:[WWUtilityClass getNSUserDefaults:UserID] WithCompletion:^(WebAPIResponse *response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (response.code == WebAPIResponseCodeSuccess) {
                        
                        NSDictionary *resultDic = [response.responseObject objectForKey:@"result"];
                        clothesRequestDataDic = resultDic;
                        // 免费次数
                        NSString *expressCount = [resultDic objectForKey:@"expressCount"];
                        // 运费
                        NSString *freight = [resultDic objectForKey:@"freight"];
                        if ([expressCount intValue] == 0) {
                            self.otherContentLab.text = [NSString stringWithFormat:@"运费：￥%@",freight];
                        }else{
                            self.otherContentLab.text = [NSString stringWithFormat:@"您还可免费更换%@次",expressCount];
                        }
                        self.clothesArray = [resultDic objectForKey:@"clientWardrobes"];
                        
                        [self.clothesCollection reloadData];
                        [self.clothesCollection.header endRefreshing];
                    }
                });
            }];
        }];
        
        [self.clothesCollection.header beginRefreshing];
    }
    return self;
}

- (void)refreshWantWearClothesNum:(NSNotification *)notification{
    [self.clothesCollection.header beginRefreshing];
}

- (void)settlementClickEvent:(UIButton *)sender{
    if (self.clothesArray.count != 3) {
        [SVProgressHUD showInfoWithStatus:@"衣柜必够3件衣服才可以配送哦~"];
        return;
    }else{
        if ([[WWUtilityClass getNSUserDefaults:UserVipID] intValue] != 1) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"需要购买会员服务才可以完成后继操作" delegate:self cancelButtonTitle:@"咨询客服" otherButtonTitles:@"购买会员", nil];
            alert.delegate = self;
            [alert show];
            return;
        }
    }
    self.settlementBtnClickBlock(clothesRequestDataDic);
    
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.clothesArray.count+1;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(MainView_Width/2, iphone_size_scale(155));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.clothesArray.count < indexPath.row) {
        return;
    }
    NSDictionary * dicTemp = self.clothesArray[indexPath.row];
    
    if (indexPath.row < self.clothesArray.count){
        self.collectionDidSelectItemBlock(StringForKeyInUnserializedJSONDic(dicTemp, @"id"));
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.clothesArray.count) {
        static NSString * CellIdentifier = wantWearCollectionCell;
        
        WWWantWearCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (indexPath.row < self.clothesArray.count) {
            
            NSDictionary * dicTemp = self.clothesArray[indexPath.row];
            NSString *imageURL = StringForKeyInUnserializedJSONDic(dicTemp, @"imgurl");
            [cell.clothesImage sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"默认衣服图片"]];
            NSString *name = [NSString stringWithFormat:@"%@ %@",StringForKeyInUnserializedJSONDic(dicTemp, @"color"),StringForKeyInUnserializedJSONDic(dicTemp, @"size")];
            [cell.clothesNameLab setText:name];
            // 删除按钮
            cell.clothesDelegateBlock = ^{
                self.collectionCellDelegateBlock(StringForKeyInUnserializedJSONDic(dicTemp, @"code"));
            };

        }
        
        return cell;
    }else{
        static NSString *colletionCellStr = CollectionCell;
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:colletionCellStr forIndexPath:indexPath];
        cell.backgroundColor =[UIColor clearColor];
        //////遮罩View
        UIView * viewt = [[UIView alloc]initWithFrame:CGRectMake(7, 10, 145*kPercenX, 145*kPercenX)];
        [viewt setBackgroundColor:[UIColor whiteColor]];
        viewt.layer.borderColor = WWPageLineColor.CGColor;
        viewt.layer.borderWidth = 0.5f;
        [viewt setUserInteractionEnabled:YES];
        [cell.contentView addSubview:viewt];
        // 添加按钮
        UIButton *addClothesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addClothesBtn.backgroundColor = [UIColor clearColor];
        addClothesBtn.frame = CGRectMake(0, 0, viewt.width, viewt.height);
        [addClothesBtn setImage:[UIImage imageNamed:@"add-clos"] forState:UIControlStateNormal];
        [addClothesBtn setImage:[WWUtilityClass imageWithColor:WWBtnStateHighlightedColor] forState:UIControlStateHighlighted];
        [addClothesBtn addTarget:self action:@selector(addBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [viewt addSubview:addClothesBtn];
        
        return cell;
    }
    
}

- (void)addBtnClickEvent:(UIButton *)sender{
    self.collectionDidSelectItemBlock(@"");
}

#pragma mark --- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        // 打开tel：开头的URL代表拨打电话，使用tel：或tel：//前缀都行
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",WWSupportTel]]];
    }else{
        if (self.wantWearBtnClickBlock) {
            self.wantWearBtnClickBlock();
        }
    }
}

@end
