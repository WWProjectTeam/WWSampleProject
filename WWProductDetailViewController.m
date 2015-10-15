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
@interface WWProductDetailViewController (){

    ProductDetialView * productView;
//    NSMutableArray * arrayImgs;
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
            
            
            NSString * strTitle = dicData[@"title"];
            
            
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:strTitle];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            
            [paragraphStyle setLineSpacing:5];
            
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, strTitle.length)];
            
            
            productView.labelTitle.attributedText = attributedString;
            
            //调节高度
            
            CGSize size = CGSizeMake(iphone_size_scale(300), MAXFLOAT);
            
            
           // [productView.labelTitle sizeToFit];
           CGSize sizeTitle = [productView.labelTitle sizeThatFits:size];
            
            productView.labelTitle.frame = CGRectMake(iphone_size_scale(10), productView.labelTitle.frame.origin.y, iphone_size_scale(300), sizeTitle.height);

//            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:strTitle];
//            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
//            [style setLineSpacing:10.0f];
//            NSInteger leng = iphone_size_scale(300);
//            if (attStr.length < iphone_size_scale(300)) {
//                leng = attStr.length;
//            }
//            [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, strTitle.length)];
//            productView.labelTitle.attributedText = attStr;
//
//            
//            CGSize titleSize = [WWUtilityClass boundingRectWithSize:CGSizeMake(iphone_size_scale(300), MAXFLOAT) withText:strTitle withFont:font_size(15)];
//            [productView.labelTitle setFrame:CGRectMake(iphone_size_scale(10), iphone_size_scale(300), iphone_size_scale(300), titleSize.height)];
           // [productView.labelTitle setText:strTitle];
            
            
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
