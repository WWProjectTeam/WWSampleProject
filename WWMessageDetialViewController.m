//
//  WWMessageDetialViewController.m
//  WWSampleProject
//
//  Created by ww on 15/10/22.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWMessageDetialViewController.h"
#import "WWPublicNavtionBar.h"
#import "HTTPClient+Other.h"

#import "WWMessageDetialCellTableViewCell.h"

#import "NSDate+Tool.h"
#import "KZLinkLabel.h"

//#import "MessageModel.h"
//#import "CellFrameModel.h"
//#import "MessageCell.h"


@interface WWMessageDetialViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIActionSheetDelegate>{

    NSMutableArray * arrayList;
    
    NSInteger maxId;
}
@property (nonatomic,strong) NSDictionary *selectedLinkDic;

@end

@implementation WWMessageDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    WWPublicNavtionBar * navtionBar = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"系统通知" withRightBtn:NO withRightBtnPicName:nil withRightBtnSize:CGSizeZero];
    [self.view addSubview:navtionBar];
    
    

    
    UITableView * tableView = [[UITableView alloc]init];
    [tableView setFrame:CGRectMake(0, IOS7_Y+44,MainView_Width , MainView_Height-IOS7_Y-44)];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [tableView setBackgroundColor:RGBCOLOR(242, 242, 242)];
    [self.view addSubview:tableView];
    
    maxId = 0;
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [[HTTPClient sharedHTTPClient]GetUserMsgList:[NSString stringWithFormat:@"%d",maxId] WithCompletion:^(WebAPIResponse *operation) {
            
            
            NSDictionary * dict = operation.responseObject[@"result"];
            
            NSString * strIndex = [NSString stringWithFormat:@"%@",dict[@"next"]];
            if ([strIndex isEqualToString:@"0"]) {
                [tableView.header removeFromSuperview];
            }

            if (maxId==0) {
                arrayList = [NSMutableArray arrayWithArray:dict[@"list"]];

            }
            else
            {
                [arrayList addObjectsFromArray:dict[@"list"]];
            }
            
            NSDictionary * dicTemp = [arrayList lastObject];
            maxId = [dicTemp[@"id"] integerValue];
            
            
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
    return arrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    WWMessageDetialCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WWMessageDetialCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString * strTime = arrayList[indexPath.row][@"createTime"];
    strTime = [self setupDisplayDateInfor:strTime];
    
    cell.labelTime.text = strTime;
    
    
    NSString * strContent = arrayList[indexPath.row][@"content"];
    
    

    
    CGSize size = CGSizeMake(iphone_size_scale(200), 10000.0f);
    UIFont *font = [UIFont fontWithName:@"Arial" size:13];
    
    
    NSDictionary *attributes = @{NSFontAttributeName: font};
    NSAttributedString *attributedString = [NSAttributedString emotionAttributedStringFrom:strContent attributes:attributes];
    cell.labelContent.numberOfLines = 0;
    cell.labelContent.lineBreakMode = NSLineBreakByTruncatingTail;
    cell.labelContent.attributedText = attributedString;
    
    
    cell.labelContent.linkTapHandler = ^(KZLinkType linkType, NSString *string, NSRange range){
        if (linkType == KZLinkTypeURL) {
            [self openURL:[NSURL URLWithString:string]];
        } else if (linkType == KZLinkTypePhoneNumber) {
            [self openTel:string];
        } else {
            NSLog(@"Other Link");
        }
    };
    cell.labelContent.linkLongPressHandler = ^(KZLinkType linkType, NSString *string, NSRange range){
        NSMutableDictionary *linkDictionary = [NSMutableDictionary dictionaryWithCapacity:3];
        [linkDictionary setObject:@(linkType) forKey:@"linkType"];
        [linkDictionary setObject:string forKey:@"link"];
        [linkDictionary setObject:[NSValue valueWithRange:range] forKey:@"range"];
        self.selectedLinkDic = linkDictionary;
        
        NSString *openTypeString;
        if (linkType == KZLinkTypeURL) {
            openTypeString = @"在Safari中打开";
        } else if (linkType == KZLinkTypePhoneNumber) {
            openTypeString = @"直接拨打";
        }
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"拷贝",openTypeString, nil];
        [sheet showInView:self.view];
    };
    
    
    
    //设置字体
    cell.labelContent.font = font;
    
    size = [WWUtilityClass boundingRectWithSize:size withText:cell.labelContent.text withFont:font];

    
    [cell.labelContent setFrame:(CGRect){iphone_size_scale(80),iphone_size_scale(50),size.width,size.height+22}];

    
    [cell.backImg setFrame:CGRectMake(iphone_size_scale(60), iphone_size_scale(40), size.width+40, size.height+40)];
   
    [cell.backImg setImage:[self resizeImage:@"chat_recive_nor"]];

    cell.frame = CGRectMake(0, 0, MainView_Width, CGRectGetMaxY(cell.backImg.frame));

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}



- (UIImage *)resizeImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat imageW = image.size.width * 0.5;
    CGFloat imageH = image.size.height * 0.5;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(imageH, imageW, imageH, imageW) resizingMode:UIImageResizingModeTile];
}


- (NSString *)setupDisplayDateInfor:(NSString *)dateString{
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateInfor = [inputFormatter dateFromString:dateString];
    NSTimeInterval timeTemp =[dateInfor timeIntervalSince1970];
    return [NSDate timeStringWithInterval:timeTemp];;
}



- (BOOL)openURL:(NSURL *)url
{
    BOOL safariCompatible = [url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"];
    if (safariCompatible && [[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    } else {
        return NO;
    }
}
- (BOOL)openTel:(NSString *)tel
{
    NSString *telString = [NSString stringWithFormat:@"tel://%@",tel];
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
}
#pragma mark - Action Sheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!self.selectedLinkDic) {
        return;
    }
    switch (buttonIndex)
    {
        case 0:
        {
            [UIPasteboard generalPasteboard].string = self.selectedLinkDic[@"link"];
            break;
        }
        case 1:
        {
            KZLinkType linkType = [self.selectedLinkDic[@"linkType"] integerValue];
            if (linkType == KZLinkTypeURL) {
                NSURL *url = [NSURL URLWithString:self.selectedLinkDic[@"link"]];
                [self openURL:url];
            } else if (linkType == KZLinkTypePhoneNumber) {
                [self openTel:self.selectedLinkDic[@"link"]];
            }
            break;
        }
    }
}
@end
