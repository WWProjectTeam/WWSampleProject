//
//  ProductDetialView.m
//  WWSampleProject
//
//  Created by ww on 15/10/14.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "ProductDetialView.h"
#import "WWPageControl.h"
#import "WWProductReplyListTableViewCell.h"

@implementation ProductDetialView
@synthesize scrollViewBackground = _scrollViewBackground;
@synthesize scrollBanner         = _scrollBanner;
@synthesize pageControl          = _pageControl;
@synthesize imagePhoto           = _imagePhoto;
@synthesize imgGrey              = _imgGrey;
@synthesize webSection1          = _webSection1;
@synthesize webSection2          = _webSection2;
@synthesize tableReplyList       = _tableReplyList;
@synthesize arrReplyList         = _arrReplyList;
-(id)initProductDetialView{
    self = [super initWithFrame:CGRectMake(0,0,MainView_Width,MainView_Height)];
    
    if (self)
    {
        self.scrollViewBackground = [[UIScrollView alloc]init];
        [self.scrollViewBackground setFrame:CGRectMake(0, -20, self.frame.size.width,self.frame.size.height-29)];
        [self.scrollViewBackground setShowsHorizontalScrollIndicator:NO];
        [self.scrollViewBackground setShowsVerticalScrollIndicator:NO];
        [self.scrollViewBackground setDelegate:self];
       // self.scrollViewBackground.backgroundColor = [UIColor redColor];
        [self.scrollViewBackground setUserInteractionEnabled:YES];
        [self addSubview:self.scrollViewBackground];
        
        
        [self.scrollViewBackground setContentSize:CGSizeMake(MainView_Width, 1000)];

        //轮播图创建
        self.scrollBanner = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, iphone_size_scale(320), iphone_size_scale(300)) animationDuration:4];
        self.scrollBanner.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.1];
        [self.scrollViewBackground addSubview:self.scrollBanner];
        
        //定义pageControl
        self.pageControl = [[WWPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollBanner.frame)-14, 320, 6)];
        
        [self.pageControl setBackgroundColor:[UIColor clearColor]];
        [self.pageControl setImagePageStateHighlighted:[UIImage imageNamed:@"click-on--point"]];
        [self.pageControl setImagePageStateNormal:[UIImage imageNamed:@"-default-point"]];
        [self.pageControl setHidesForSinglePage:YES];
        [self.scrollBanner addSubview:self.pageControl];

        //详情图
        self.labelTitle  = [[UILabel alloc]init];
        [self.labelTitle setFrame:CGRectMake(0, iphone_size_scale(310), MainView_Width, 30)];
        [self.labelTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        [self.labelTitle setNumberOfLines:0];
        [self.labelTitle setTextAlignment:NSTextAlignmentLeft];
        
        //判断内容长度是否大于Label内容宽度，如果不大于，则设置内容宽度为行宽（内容如果小于行宽，Label长度太短，如果Label有背景颜色，将影响布局效果）

        [self.scrollViewBackground addSubview:self.labelTitle];
        
       
        //desc
        self.labelDesc = [[UILabel alloc]init];
        [self.labelDesc setFrame:CGRectMake(0,0,MainView_Width,30)];
        [self.labelDesc setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
        [self.labelDesc setNumberOfLines:0];
        [self.labelDesc setTextAlignment:NSTextAlignmentLeft];
        [self.labelDesc setTextColor:[UIColor grayColor]];
        [self.labelDesc setTextColor:RGBCOLOR(86, 86, 86)];

        [self.scrollViewBackground addSubview:self.labelDesc];
        
        
        //greyimg
        self.imgGrey = [[UIImageView alloc]init];
        [self.imgGrey setBackgroundColor:RGBCOLOR(235, 235, 235)];
        [self.scrollViewBackground addSubview:self.imgGrey];
        
#pragma mark - body
         _menuItems = @[[@"图文介绍" uppercaseString], [@"商品参数" uppercaseString]];
         [self.scrollViewBackground addSubview:self.control];
            
        
        self.webSection1 = [[UIWebView alloc]init];
        [self.webSection1 setTag:10001];
        [self.scrollViewBackground addSubview:self.webSection1];
        
        self.webSection2 = [[UIWebView alloc]init];
        [self.webSection2 setTag:10002];
        [self.webSection2 setHidden:YES];
        [self.scrollViewBackground addSubview:self.webSection2];
        
        
        self.tableReplyList = [[UITableView alloc]init];
        [self.tableReplyList setDelegate:self];
        [self.tableReplyList setDataSource:self];
        [self.tableReplyList setHidden:YES];
        

        
        [self.scrollViewBackground addSubview:self.tableReplyList];
#pragma mark - foot
        
        UIButton * btnSer = [[UIButton alloc]init];
        [btnSer setFrame:CGRectMake(0, MainView_Height-49, iphone_size_scale(58), 49)];
        [btnSer.layer setMasksToBounds:YES];
        [btnSer.layer setBorderWidth:1.0];   //边框宽度
        [btnSer.layer setBorderColor:RGBCOLOR(235, 235, 235).CGColor];//边框颜色
        [btnSer setImage:[UIImage imageNamed:@"default-of-the-service"] forState:UIControlStateNormal];
        [btnSer setImage:[UIImage imageNamed:@"click-on--service"] forState:UIControlStateHighlighted];
        [btnSer setImageEdgeInsets:UIEdgeInsetsMake(7, iphone_size_scale(19), 19, iphone_size_scale(19))];
        
        [btnSer setTitle:@"客服" forState:UIControlStateNormal];
        [btnSer.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [btnSer setTitleEdgeInsets:UIEdgeInsetsMake(27, -btnSer.titleLabel.bounds.size.width-20, 0,0)];
        [btnSer setTitleColor:RGBCOLOR(157, 157, 157) forState:UIControlStateNormal];
        [btnSer setTitleColor:RGBCOLOR(234, 162, 0) forState:UIControlStateHighlighted];
        [btnSer.titleLabel setFont:font_bold_size(11)];
        
        [btnSer addTarget:self action:@selector(supportTel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnSer];
        

        //收藏
        btnFav = ({
            UIButton * btnTemp = [[UIButton alloc]init];
            [btnTemp setFrame:CGRectMake(iphone_size_scale(57), MainView_Height-49, iphone_size_scale(58), 49)];
            [btnTemp.layer setMasksToBounds:YES];
            [btnTemp.layer setBorderWidth:1.0];   //边框宽度
            [btnTemp.layer setBorderColor:RGBCOLOR(235, 235, 235).CGColor];//边框颜色
            [btnTemp setImage:[UIImage imageNamed:@"collect--default"] forState:UIControlStateNormal];
            [btnTemp setImageEdgeInsets:UIEdgeInsetsMake(7, iphone_size_scale(19), 19, iphone_size_scale(19))];
            
            [btnTemp setTitle:@"收藏" forState:UIControlStateNormal];
            [btnTemp.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [btnTemp setTitleEdgeInsets:UIEdgeInsetsMake(27, -btnSer.titleLabel.bounds.size.width-20, 0,0)];
            [btnTemp setTitleColor:RGBCOLOR(157, 157, 157) forState:UIControlStateNormal];
           // [btnSer setTitleColor:RGBCOLOR(234, 162, 0) forState:UIControlStateHighlighted];
            [btnTemp.titleLabel setFont:font_bold_size(11)];
            
            [btnTemp addTarget:self action:@selector(addFav) forControlEvents:UIControlEventTouchUpInside];

            btnTemp;
        });

        [self addSubview:btnFav];
        
        
        btnClo = ({
            UIButton * btnTemp = [[UIButton alloc]init];
            [btnTemp setFrame:CGRectMake(iphone_size_scale(114), MainView_Height-49, iphone_size_scale(58), 49)];
            [btnTemp.layer setMasksToBounds:YES];
            [btnTemp.layer setBorderWidth:1.0];   //边框宽度
            [btnTemp.layer setBorderColor:RGBCOLOR(235, 235, 235).CGColor];//边框颜色
            [btnTemp setImage:[UIImage imageNamed:@"default-chest"] forState:UIControlStateNormal];
            [btnTemp setImage:[UIImage imageNamed:@"click-on--chest"] forState:UIControlStateHighlighted];
            [btnTemp setImageEdgeInsets:UIEdgeInsetsMake(7, iphone_size_scale(19), 19, iphone_size_scale(19))];
            
            [btnTemp setTitle:@"衣柜" forState:UIControlStateNormal];
            [btnTemp.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [btnTemp setTitleEdgeInsets:UIEdgeInsetsMake(27, -btnSer.titleLabel.bounds.size.width-20, 0,0)];
            [btnTemp setTitleColor:RGBCOLOR(157, 157, 157) forState:UIControlStateNormal];
            [btnTemp setTitleColor:RGBCOLOR(234, 162, 0) forState:UIControlStateHighlighted];
            [btnTemp.titleLabel setFont:font_bold_size(11)];
            
            [btnTemp addTarget:self action:@selector(goClo) forControlEvents:UIControlEventTouchUpInside];
            
            ClotheSpressNum = [[UIImageView alloc]init];
            [btnTemp addSubview:ClotheSpressNum];
            
            labelSpressNum = [[UILabel alloc]init];
            [labelSpressNum setTextColor:[UIColor whiteColor]];
            [labelSpressNum setFont:font_bold_size(10)];
            [labelSpressNum setTextAlignment:NSTextAlignmentCenter];
            [ClotheSpressNum addSubview:labelSpressNum];
            
            btnTemp;
        });
        [self addSubview:btnClo];

        UIButton * btnBuy = [[UIButton alloc]init];
        [btnBuy setFrame:CGRectMake(iphone_size_scale(170), MainView_Height-49, iphone_size_scale(150), 49)];
        [btnBuy.layer setMasksToBounds:YES];
        [btnBuy.layer setBorderWidth:1.0];   //边框宽度
        [btnBuy.layer setBorderColor:RGBCOLOR(235, 235, 235).CGColor];//边框颜色
        [btnBuy setBackgroundColor:RGBCOLOR(234, 162, 0)];
        [btnBuy setTitle:@"放入衣柜" forState:UIControlStateNormal];
        [btnBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnBuy.titleLabel setFont:font_bold_size(15)];
        [btnBuy addTarget:self action:@selector(addCart) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btnBuy];
    }
    return self;
}


-(void)reloadProductImgBannerWithImgData:(NSArray *)array{
    
    if (array.count==1) {
        NSString * strImageUrl = array[0];
        self.imagePhoto = [[UIImageView alloc]init];
        
        [self.imagePhoto sd_setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"bg_yfxq"]];
        [self.imagePhoto setFrame:CGRectMake(0,0, iphone_size_scale(320), iphone_size_scale(300))];
        UITapGestureRecognizer * tapImg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapImg)];
        [self.imagePhoto addGestureRecognizer:tapImg];
        [self.imagePhoto setUserInteractionEnabled:YES];
        [self.imagePhoto setContentMode:UIViewContentModeScaleAspectFill];
        self.imagePhoto.clipsToBounds = YES;
        [self.scrollViewBackground addSubview:self.imagePhoto];

    }
    else
    {
              //轮播图数据源准备
        NSMutableArray *viewsArray = [@[] mutableCopy];
        
        for (int i = 0; i<array.count; i++) {
            NSString * strImageUrl = array[i];
            UIImageView * imageTemp = [[UIImageView alloc]init];
            
            [imageTemp sd_setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"bg_yfxq"]];
            [imageTemp setFrame:CGRectMake(0,0, iphone_size_scale(320), iphone_size_scale(300))];
            [imageTemp setContentMode:UIViewContentModeScaleAspectFill];
            [viewsArray addObject:imageTemp];
        }
        
        
        
        _pageControl.numberOfPages = array.count;
        __weak CycleScrollView * scroll = self.scrollBanner;
        
        if (array.count==1) {
            scroll.totalPagesCount = ^NSInteger(void){
                return  1;
            };
            
            scroll.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
                return viewsArray[0];
            };
        }
        else
        {
            scroll.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
                return viewsArray[pageIndex];
            };
            scroll.totalPagesCount = ^NSInteger(void){
                return  array.count;
            };
            
        }
                
        
#pragma mark - banner点击事件
        
        scroll.TapActionBlock = ^(NSInteger pageIndex){
            if (self.TapPhotoAction) {
                self.TapPhotoAction(pageIndex);
            }
            
        };
        scroll.ScrollActionBlock = ^(NSInteger pageIndex){
            _pageControl.currentPage = pageIndex;
           
        };
        

    }
    
   
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint pointTemp =scrollView.contentOffset;
    
    if (self.ScrollViewDidScroll) {
        self.ScrollViewDidScroll(pointTemp);
    }
}


-(void)TapImg{
    
    if (self.TapPhotoAction) {
        self.TapPhotoAction(0);
    }
}


//客服电话
-(void)supportTel{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"电话咨询" message:WWSupportTel delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString * strSupportTel = [NSString stringWithFormat:@"tel:%@",WWSupportTel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strSupportTel]];
    }
}


#pragma mark - btnSelect
-(void)addFav{
    if (self.AddToCollection) {
        self.AddToCollection();
    }
}

-(void)goClo{
    if (self.TapClotheSpress) {
        self.TapClotheSpress();
    }
}

-(void)addCart{
    if (self.AddToCart) {
        self.AddToCart();
    }
}


#pragma mark - setAction
-(void)setCollectionStatu:(BOOL)statu{
    if (statu) {
        [btnFav setImage:[UIImage imageNamed:@"click-on--collection"] forState:UIControlStateNormal];
        [btnFav setTitle:@"已收藏" forState:UIControlStateNormal];
    }
    else
    {
        [btnFav setImage:[UIImage imageNamed:@"collect--default"] forState:UIControlStateNormal];
        [btnFav setTitle:@"收藏" forState:UIControlStateNormal];
    }
}

-(void)setClotheSpressNum:(NSInteger)num{
    if (num==0) {
        [ClotheSpressNum setHidden:YES];
        return;
    }
    
    if (num<10) {
        [ClotheSpressNum setHidden:NO];
        [ClotheSpressNum setImage:[UIImage imageNamed:@"icon_xx"]];
        [ClotheSpressNum setFrame:CGRectMake(iphone_size_scale(32), 3, 13, 13)];
        
        [labelSpressNum setFrame:CGRectMake(0, 0, 13, 13)];

        [labelSpressNum setText:[NSString stringWithFormat:@"%d",num]];
        
        return;
    }
    
    if (num<100) {
        [ClotheSpressNum setHidden:NO];
        [ClotheSpressNum setImage:[UIImage imageNamed:@"icon_xxd"]];
        [ClotheSpressNum setFrame:CGRectMake(iphone_size_scale(30), 3, 19, 13)];
        
        [labelSpressNum setFrame:CGRectMake(0, 0, 20, 13)];

        [labelSpressNum setText:[NSString stringWithFormat:@"%d",num]];

        return;
    }
    
    
    if (num>=100) {
        [ClotheSpressNum setHidden:NO];
        [ClotheSpressNum setImage:[UIImage imageNamed:@"icon_xxd"]];
        [ClotheSpressNum setFrame:CGRectMake(iphone_size_scale(30), 3, 19, 13)];
        
        [labelSpressNum setFrame:CGRectMake(0, 0, 20, 13)];
        [labelSpressNum setText:@"99+"];
        [labelSpressNum setFont:font_bold_size(8)];
        
        return;
    }
}


//////DZN
- (DZNSegmentedControl *)control
{
    if (!_control)
    {
        _control = [[DZNSegmentedControl alloc] initWithItems:self.menuItems];
        _control.delegate = self;
        _control.selectedSegmentIndex = 0;
        _control.bouncySelectionIndicator = YES;
        _control.backgroundColor = [UIColor clearColor];
        _control.tintColor = WWBtnYellowColor;
       // _control.hairlineColor = WWContentTextColor;
        _control.showsCount = NO;
        _control.autoAdjustSelectionIndicatorWidth = NO;
        _control.selectionIndicatorHeight = 2;
        
        [_control addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    }
    return _control;
}

#pragma mark - UIBarPositioningDelegate Methods

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)view
{
    return UIBarPositionBottom;
}


- (void)selectedSegment:(DZNSegmentedControl *)control
{
    if (self.SwitchTab) {
        self.SwitchTab(control.selectedSegmentIndex);
    }
}


#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrReplyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"replyListCell";
    //
    WWProductReplyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[WWProductReplyListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    NSDictionary * dicTemp = [self.arrReplyList objectAtIndex:indexPath.row];
    
    NSDictionary * dicUserTemp = dicTemp[@"user"];
    
    [cell.imgUserPic sd_setImageWithURL:[NSURL URLWithString:dicUserTemp[@"faceurl"]] placeholderImage:[UIImage imageNamed:@"-avatars"]];
    cell.labelTime.text = dicTemp[@"createTime"];
    cell.labelContent.text = dicTemp[@"content"];
    
    
    NSString * strUserName = dicUserTemp[@"userName"];
    if ([WWUtilityClass validateMobile:strUserName]) {
        strUserName = [NSString stringWithFormat:@"%@****",[strUserName substringToIndex:3]];
    }
    else if(strUserName.length>=1)
    {
        strUserName = [NSString stringWithFormat:@"%@****",[strUserName substringToIndex:1]];
    }
    
    cell.labelUserName.text = strUserName;
    

    
    CGSize size = [WWUtilityClass boundingRectWithSize:CGSizeMake(iphone_size_scale(260), MAXFLOAT) withText:cell.labelContent.text withFont:font_size(14)];
    [cell.labelContent setFrame:CGRectMake(cell.labelContent.frame.origin.x, cell.labelContent.frame.origin.y,iphone_size_scale(260), size.height)];
    
    
     cell.frame = CGRectMake(0, 0, MainView_Width, CGRectGetMaxY(cell.labelContent.frame)+10);
    
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;

}



#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
