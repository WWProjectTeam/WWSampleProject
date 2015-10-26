//
//  WWYiYouVProtocolViewController.m
//  WWSampleProject
//
//  Created by push on 15/10/26.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWYiYouVProtocolViewController.h"

@interface WWYiYouVProtocolViewController (){
    WWPublicNavtionBar *navtionBarView;
}

@end

@implementation WWYiYouVProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WW_BASE_COLOR;
    navtionBarView = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"衣优V租衣协议" withRightBtn:NO withRightBtnPicName:nil withRightBtnSize:CGSizeZero];
    __weak __typeof(&*self)weakSelf = self;
    navtionBarView.TapLeftButton = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    [self.view addSubview:navtionBarView];
    
    UIScrollView *backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, IOS7_Y+44, MainView_Width, MainView_Height-IOS7_Y-44)];
    backScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backScrollView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, MainView_Width, 16*kPercenX)];
    titleLab.text = @"衣优V租衣协议";
    titleLab.textColor = [UIColor blackColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = font_size(16);
    [backScrollView addSubview:titleLab];
    
    UILabel *content = [[UILabel alloc]init];
    content.text = @"1.衣优V保证所有上架商品均系100%正品并保证品质良好，商品在前一用户退租返还后均会由衣优V特约养护服务商进行清洁保养、除菌处理，才会再次上架对外出租。用户点击“【登录】”即视为用户已阅读并接受《衣优V用户使用协议》，并视为用户认可衣优V选定的特约养护服务商及其提供的服务和认定成果，并视为用户认可衣优V选定的鉴定机构及其作出的鉴定结果。请成功购买VIP用户悉心使用租赁商品，不得对商品造成损坏。\n2.购买租赁会员服务的用户仅获得该商品相应天数的使用权，并不获得该商品的所有权。\n3.用户应在购买会员时确定购买会员天数，并按天数支付会员费用，会员时长一旦确定，不得缩短。如用户在会员时长届满前欲延长会员时长的，需及时续费会员服务。\n4.衣优V为了提高用户的体验，不向用户收取任何的押金费用。\n5.根据用户信用记录，衣优V为每位用户授予一定的信用额度，信用额度可用于抵扣应缴的押金，当信用额度降低到一定值将立即终止衣优V提供的服务。\n6.如用户在使用过程中造成对商品的非正常磨损、严重损坏、丢失或被窃、逾期归还或归还商品不一致的，用户不需要赔偿但是信用额度会更具实际情况有所下降，具体规则如下：\n• 非正常损坏：经衣优V特约养护服务商查验认为需要对商品进行“非常规保养”等额外修复后方能再次使用的归还商品。\n• 严重损坏：用户造成商品严重损坏，并经衣优V特约养护服务商查验认为该商品无法再次使用的，并将用户信用额度清零。衣优V特约养护服务商查验认为将就无法再次使用的商品出具“商品无法修复恢复使用说明” 并供用户查阅，衣优V将以该说明作为停止服务的依据，衣优V将在该用户档案中记录此事项及处理结果。\n• 丢失或被窃：如商品在用户租用期间丢失或被盗，该用户需立即联系衣优V客服，并及时向公安机关报案。如该商品在丢失后【30日】内未能找回，则将用户信用额度清零\n• 逾期归还：用户在约定的会员时长届满后未及时归还所租商品的，衣优V将以天为单位收取会员费用。\n• 归还商品不一致：如寄回的商品经衣优V选定的鉴定机构鉴定与衣优V发出的原商品不一致的，衣优V有权拒绝收回外租商品并立即停止会员服务。\n7.因衣优V原因产生的换货邮寄费用（不包含商品保险费用）由衣优V承担，衣优V客服将在收到换货商品后为用户办理邮寄费用报销手续。\n8.为保护消费者利益，衣优V会在商品上贴附“衣优V查验标签”（一枚印有衣优V标识的贴纸），请用户在仔细检查所收商品后确认无任何问题再撕毁“衣优V查验标签”，一旦“标签”破损，将视为用户确认对所收商品无任何异议，且不能申请换货。\n9.对于恶意换货等行为，衣优V有权终止该用户账户（包含用户对应唯一手机号）的资格并追究其法律责任。\n10.因租赁商品而产生的一切税费，最终均由租赁用户承担。";
    content.textColor = [UIColor blackColor];
    content.font = font_size(12);
    content.numberOfLines = 0;
    content.textAlignment = NSTextAlignmentCenter;
    CGSize navSizePhone = CGSizeMake(MainView_Width-10, 20000.0f);
    navSizePhone = [content.text sizeWithFont:content.font constrainedToSize:navSizePhone lineBreakMode:NSLineBreakByCharWrapping];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:content.text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [content.text length])];
    [content setAttributedText:attributedString1];
    [content sizeToFit];
    content.frame = CGRectMake(5, titleLab.bottom+20, navSizePhone.width, navSizePhone.height);
    [backScrollView addSubview:content];
    
    backScrollView.contentSize = CGSizeMake(MainView_Width, content.height+titleLab.height+35*kPercenX);

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
