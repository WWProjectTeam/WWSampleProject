//
//  WWProductDetailViewController.m
//  WWSampleProject
//
//  Created by ww on 15/10/14.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWProductDetailViewController.h"
#import "WWPublicNavtionBar.h"
#import "ProductDetialView.h"
#import "HTTPClient+Other.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "WWLoginViewController.h"

#import "WWClotheSpressViewController.h"
@interface WWProductDetailViewController (){

    ProductDetialView * productView;
//    NSMutableArray * arrayImgs;
    
    
    BOOL CollectionStatu;
}

@end

@implementation WWProductDetailViewController
@synthesize strProductId = _strProductId;
@synthesize arrayImgs =  _arrayImgs;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    productView = [[ProductDetialView alloc]initProductDetialView];
    [productView setFrame:CGRectMake(0, 0, MainView_Width, MainView_Height)];
    [self.view addSubview:productView];

   
    
    WWPublicNavtionBar * navtionBar = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"详情" withRightBtn:NO withRightBtnPicName:nil withRightBtnSize:CGSizeZero];    
    [navtionBar setAlpha:0];
    
    [self.view addSubview:navtionBar];
    
    
    UIButton * btnBack = [[UIButton alloc]init];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"round-return"] forState:UIControlStateNormal];
    [btnBack setFrame:CGRectMake(10, IOS7_Y+5, 32, 32)];
    [btnBack addTarget:self action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    
    
    
    productView.ScrollViewDidScroll = ^(CGPoint point){
        [btnBack setAlpha:1-point.y/100];
        [navtionBar setAlpha:point.y/100];
    };
    
#pragma mark - tapPhoto
    __weak typeof(self) weakself = self;
    productView.TapPhotoAction = ^(NSInteger index){
    

        if (!index) {
            index = 0;
        }
        
        int count = weakself.arrayImgs.count;
        // 1.封装图片数据
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i<count; i++) {
            // 替换为中等尺寸图片

            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:weakself.arrayImgs[i]]; // 图片路径
            
            UIImageView * imgT = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, iphone_size_scale(400), iphone_size_scale(300))];
            [imgT setImage:[UIImage imageNamed:@"bg_yfxq"]];
           // photo.srcImageView = imgT; // 来源于哪个UIImageView
            [photos addObject:photo];
        }
        
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = index; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];


    };
   
    
    [self productDetialUpdate];
 
#pragma mark - foot
    /////////添加收藏
    __weak ProductDetialView * productTemp = productView;
    productView.AddToCollection = ^(){
        if ([AppDelegate isAuthentication]) {
            if (CollectionStatu==YES) {
                [productTemp setCollectionStatu:NO];
                CollectionStatu = NO;
            }
            else{
                [productTemp setCollectionStatu:YES];
                CollectionStatu = YES;
            }
            
            ///调用收藏接口
            [weakself CollectionStatuUpdate];

        }
    
    };
    
    
    ////////添加到衣柜
    productView.AddToCart = ^(){
        if ([AppDelegate isAuthentication]) {
            
        }
    
    };
    
    ///////打开衣柜
    productView.TapClotheSpress = ^(){
        if ([AppDelegate isAuthentication]) {
            WWClotheSpressViewController * clotheVC = [[WWClotheSpressViewController alloc]init];
            [weakself.navigationController pushViewController:clotheVC animated:YES];
        }
    };
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.UserLoginStatuUpdate = ^(){
        [self productDetialUpdate];
    };
    
}


#pragma mark - update
-(void)CollectionStatuUpdate{
    [[HTTPClient sharedHTTPClient]AddToCollection:self.strProductId WithCompletion:^(WebAPIResponse *operation) {
        NSDictionary * dict = operation.responseObject;
        WWLog(@"%@",dict);
    }];

}

-(void)productDetialUpdate{
    [SVProgressHUD show];
    [[HTTPClient sharedHTTPClient]ProductDetailPriductId:self.strProductId WithComletion:^(WebAPIResponse *operation) {
        NSDictionary * dict = operation.responseObject;
        
        if ([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:WWAppSuccessCode]) {
            [SVProgressHUD dismiss];
            
            NSDictionary * dicData = dict[@"result"];
            NSString * strImgUrl = dicData[@"imgurl"];
            
            NSArray *array = [strImgUrl componentsSeparatedByString:@","];
            
            self.arrayImgs = [NSMutableArray arrayWithArray:array];
            /////////刷新图片
            [productView reloadProductImgBannerWithImgData:array];
            
            
            /////////标题
            NSString * strTitle = dicData[@"title"];
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:strTitle];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            [paragraphStyle setLineSpacing:5];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, strTitle.length)];
            productView.labelTitle.attributedText = attributedString;
            CGSize size = CGSizeMake(iphone_size_scale(300), MAXFLOAT);
            CGSize sizeTitle = [productView.labelTitle sizeThatFits:size];
            
            productView.labelTitle.frame = CGRectMake(iphone_size_scale(10), productView.labelTitle.frame.origin.y, iphone_size_scale(300), sizeTitle.height);
            
            
            /////////描述
            NSString * strContent = dicData[@"content"];
            
            NSMutableAttributedString *attributedStringt = [[NSMutableAttributedString alloc]initWithString:strContent];
            NSMutableParagraphStyle *paragraphStylet = [[NSMutableParagraphStyle alloc]init];
            [paragraphStylet setLineSpacing:7];
            [attributedStringt addAttribute:NSParagraphStyleAttributeName value:paragraphStylet range:NSMakeRange(0, strContent.length)];
            productView.labelDesc.attributedText = attributedStringt;
            CGSize sizet = CGSizeMake(iphone_size_scale(300), MAXFLOAT);
            CGSize sizeContent = [productView.labelDesc sizeThatFits:sizet];
            
            productView.labelDesc.frame = CGRectMake(iphone_size_scale(10), CGRectGetMaxY(productView.labelTitle.frame)+10, iphone_size_scale(300), sizeContent.height);
            
            
            [productView.imgGrey setFrame:CGRectMake(0, CGRectGetMaxY(productView.labelDesc.frame)+10, MainView_Width, 10)];
            
            //分段控制器
            NSString * strReply = [NSString stringWithFormat:@"评论(%@)",dicData[@"replyCount"]];
           // productView.menuItems
            productView.menuItems = @[[@"图文介绍" uppercaseString], [@"商品参数" uppercaseString],[strReply uppercaseString]];
            [productView.control setFrame:CGRectMake(0, CGRectGetMaxY(productView.imgGrey.frame), MainView_Width, 160)];

          //  [productView.scrollViewBackground addSubview:productView.control];

            
            //////////////////////setObj
            [productView setClotheSpressNum:[dicData[@"favoriterCount"] integerValue]];
            if ([[NSString stringWithFormat:@"%@",dicData[@"isFavoriter"]]isEqualToString:@"0"]) {
                [productView setCollectionStatu:NO];
                CollectionStatu = NO;
            }
            else
            {
                [productView setCollectionStatu:YES];
                CollectionStatu = YES;
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"出错,请稍后再试!"];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)btnBack{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
