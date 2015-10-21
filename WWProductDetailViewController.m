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

#import "WWAddToCartPopView.h"

///////////tf
@interface WWProductDetailViewController (){

    ProductDetialView * productView;
    BOOL CollectionStatu;
    UITapGestureRecognizer *tapGestureRecognizer;
    
}

@end

@implementation WWProductDetailViewController
@synthesize strProductId    = _strProductId;
@synthesize arrayImgs       =  _arrayImgs;
@synthesize btnAddReply     = _btnAddReply;
@synthesize tfReply         = _tfReply;
@synthesize viewAddReply    = _viewAddReply;
@synthesize addCartPopView  = _addCartPopView;
@synthesize dicProductMsg   = _dicProductMsg;

- (void)viewDidLoad {
    [super viewDidLoad];

    ////监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
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
            if (!weakself.addCartPopView) {
                weakself.addCartPopView = [[WWAddToCartPopView alloc]initAddToCartPopView];
                [weakself.view addSubview:weakself.addCartPopView];
                [weakself.addCartPopView showWithProductMsg:weakself.dicProductMsg];

            }
            else
            {
                weakself.addCartPopView.hidden = NO;
            }
            
        }
#pragma mark - 添加到衣柜
        weakself.addCartPopView.AddToCart = ^(NSString * strColor,NSString * strSize){
            [SVProgressHUD show];
            [[HTTPClient sharedHTTPClient]PostAddToCartWithProductId:weakself.strProductId WithColor:strColor WithSize:strSize WithCompletion:^(WebAPIResponse *operation) {
                NSDictionary * dict = operation.responseObject;
                
                if ([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:WWAppSuccessCode]) {
                    [SVProgressHUD showSuccessWithStatus:@"添加成功!"];
                    [weakself.addCartPopView setHidden:YES];
                    
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:dict[@"result"]];
                }
            }];

        };
    
    };
    
    ///////打开衣柜
    productView.TapClotheSpress = ^(){
        if ([AppDelegate isAuthentication]) {
            WWClotheSpressViewController * clotheVC = [[WWClotheSpressViewController alloc]init];
            clotheVC.IsHomePush = YES;
            [weakself.navigationController pushViewController:clotheVC animated:YES];
        }
    };
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.UserLoginStatuUpdate = ^(){
        [self productDetialUpdate];
    };
    
    
#pragma mark - switchTab
    
    productView.SwitchTab = ^(NSInteger index){
        switch (index) {
            case 0:
            {
                productTemp.webSection1.hidden = NO;
                productTemp.webSection2.hidden = YES;
                productTemp.tableReplyList.hidden = YES;
                weakself.btnAddReply.hidden = YES;

                
                [productTemp.scrollViewBackground setContentSize:CGSizeMake(MainView_Width, CGRectGetMaxY(productTemp.webSection1.frame))];
            }
                break;
                
                
            case 1:
            {
                productTemp.webSection1.hidden = YES;
                productTemp.webSection2.hidden = NO;
                productTemp.tableReplyList.hidden = YES;
                weakself.btnAddReply.hidden = YES;

                [productTemp.scrollViewBackground setContentSize:CGSizeMake(MainView_Width, CGRectGetMaxY(productTemp.webSection2.frame))];
            }
                break;
                
            case 2:
            {
                productTemp.webSection1.hidden = YES;
                productTemp.webSection2.hidden = YES;
                productTemp.tableReplyList.hidden = NO;
                weakself.btnAddReply.hidden = NO;

                [productTemp.scrollViewBackground setContentSize:CGSizeMake(MainView_Width, CGRectGetMaxY(productTemp.tableReplyList.frame))];
            }
                break;

                
            default:
                break;
        }
    
    
    
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
            
            
            self.dicProductMsg = dicData;
            
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
            

            [productView.control setFrame:CGRectMake(0, CGRectGetMaxY(productView.imgGrey.frame), MainView_Width, 40)];

            [productView.control removeAllSegments];
            [productView.control setItems:@[[@"图文介绍" uppercaseString], [@"商品参数" uppercaseString],strReply ]];

            
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
            
            
            ///////////////websection01
            
            /////////////////继续请求图文详情
            [self productPictureDetialUpdate];
            [self productParamerUpdate];
            [self productReplyList];
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"出错,请稍后再试!"];
        }
    }];
    
    ////////手势
    tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

///商品图文详情
-(void)productPictureDetialUpdate{
    
    [productView.webSection1 setFrame:CGRectMake(0,CGRectGetMaxY(productView.control.frame)+10,MainView_Width, 0)];
    [productView.webSection1 setDelegate:self];
    
    NSString * strUrl = [NSString stringWithFormat:@"http://apitest.aishou.com:8080/yiyouv/clothes/details?id=%@",self.strProductId];
    NSURL *url=[NSURL URLWithString:strUrl];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [productView.webSection1 loadRequest:request];
  


   
}

-(void)productParamerUpdate{
    [productView.webSection2 setFrame:CGRectMake(0,CGRectGetMaxY(productView.control.frame)+10,MainView_Width, 0)];
    [productView.webSection2 setDelegate:self];
    
    NSString * strUrl = [NSString stringWithFormat:@"http://apitest.aishou.com:8080/yiyouv/clothes/parameter?id=%@",self.strProductId];
    NSURL *url=[NSURL URLWithString:strUrl];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [productView.webSection2 loadRequest:request];
  
   
}

-(void)productReplyList{
    if (!self.btnAddReply) {
        self.btnAddReply = [[UIButton alloc]init];
        [self.btnAddReply setBackgroundImage:[UIImage imageNamed:@"write-reviews"] forState:UIControlStateNormal];
        [self.btnAddReply setFrame:CGRectMake(iphone_size_scale(250), MainView_Height-100, 36, 36)];
        [self.btnAddReply setHidden:YES];
        [self.btnAddReply addTarget:self action:@selector(addReply) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.btnAddReply];
    }
    
    if (!self.viewAddReply) {
        self.viewAddReply = [[UIView alloc]init];
        [self.viewAddReply setBackgroundColor:WWPageLineColor];
        [self.viewAddReply setFrame:CGRectMake(0, MainView_Height-44, MainView_Width, 44)];
        [self.viewAddReply setHidden:YES];
        [self.viewAddReply setUserInteractionEnabled:YES];
        
        [self.view addSubview:self.viewAddReply];
        
        self.tfReply = [[UITextField alloc]init];
        [self.tfReply setBorderStyle:UITextBorderStyleRoundedRect];
        [self.tfReply setFrame:CGRectMake(iphone_size_scale(10), 7, iphone_size_scale(260), 30)];
        [self.tfReply setPlaceholder:@"输入评论..."];
        [self.viewAddReply addSubview:self.tfReply];
        
        UIButton * btnSendReply = [[UIButton alloc]init];
        [btnSendReply setTitle:@"发送" forState:UIControlStateNormal];
        [btnSendReply setFrame:CGRectMake(CGRectGetMaxX(self.tfReply.frame)+5, 0, iphone_size_scale(40), 44)];
        [btnSendReply setTitleColor:WWSubTitleTextColor forState:UIControlStateNormal];
        [btnSendReply.titleLabel setFont:font_size(14)];
        [btnSendReply addTarget:self action:@selector(postReply) forControlEvents:UIControlEventTouchUpInside];
        [self.viewAddReply addSubview:btnSendReply];
    }
    
    
    
    [productView.tableReplyList setFrame:CGRectMake(0,CGRectGetMaxY(productView.control.frame)+10,MainView_Width, MainView_Height-CGRectGetMaxY(productView.control.frame)-10)];

    [[HTTPClient sharedHTTPClient]ProductReplyList:self.strProductId maxId:@"0" WithCompletion:^(WebAPIResponse *operation) {
        NSDictionary * dict = operation.responseObject;
        
        if ([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:WWAppSuccessCode]) {
            
            ///////////////websection01
            NSDictionary * dicResult = dict[@"result"];
            productView.arrReplyList = [NSMutableArray arrayWithArray:dicResult[@"list"]];
            [productView.tableReplyList reloadData];
            [productView.tableReplyList setFrame:CGRectMake(0, productView.tableReplyList.frame.origin.y, MainView_Width, productView.tableReplyList.contentSize.height)];
            
            [productView.scrollViewBackground setContentSize:CGSizeMake(MainView_Width, CGRectGetMaxY(productView.tableReplyList.frame))];

        }
        else
        {
            WWLog(@"商品评论请求失败!!")
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

#pragma mark - webViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
   
  NSString * htmlHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
  UIScrollView *tempView=(UIScrollView *)[webView.subviews objectAtIndex:0];
  tempView.scrollEnabled=NO;
    
  [webView setFrame:CGRectMake(0, CGRectGetMaxY(productView.control.frame)+10, MainView_Width
                               , [htmlHeight integerValue])];
    
    
    if (webView.tag==10001) {
        [productView.scrollViewBackground setContentSize:CGSizeMake(MainView_Width, CGRectGetMaxY(webView.frame))];
    }
}




#pragma mark - addReply
-(void)addReply{
    
    if ([AppDelegate isAuthentication]) {
        [self.viewAddReply setHidden:NO];
        [self.tfReply becomeFirstResponder];
        
        [productView setUserInteractionEnabled:NO];
        
    }
}

-(void)postReply{
    if (self.tfReply.text.length==0) {
        return;
    }
    
    [SVProgressHUD show];
    [[HTTPClient sharedHTTPClient]AddProductReply:self.strProductId  content:self.tfReply.text WithCompletion:^(WebAPIResponse *operation) {
        NSDictionary * dict = operation.responseObject;
        
        if ([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:WWAppSuccessCode]) {
            [SVProgressHUD dismiss];
            [self hideInput];
            [self productReplyList];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"出错,请稍后再试!"];
        }
    }];

}

- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    
    [UIView animateWithDuration:duration animations:^{
        self.viewAddReply.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}


-(void)hideInput{
    [WWUtilityClass hidderKeyboard];
    self.tfReply.text = @"";
    self.viewAddReply.hidden = YES;
    [productView setUserInteractionEnabled:YES];
}

-(void)hideKeyboard{
    [self hideInput];
}
@end
