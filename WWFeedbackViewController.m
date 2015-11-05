//
//  WWFeedbackViewController.m
//  WWSampleProject
//
//  Created by push on 15/10/14.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWFeedbackViewController.h"
#import "HTTPClient+Other.h"

@interface WWFeedbackViewController ()<UITextViewDelegate>{
    WWPublicNavtionBar *navtaionBarView;
}

@property (nonatomic,strong)        UIView              *backView;
@property (nonatomic,strong)        UITextView          *textView;
@property (nonatomic,strong)        UILabel             *placeholder;
@property (nonatomic,strong)        UIButton            *feedbackBtn;
@property (nonatomic,strong)        UILabel             *textNum;
@property (nonatomic,strong)        UILabel             *allTextNum;
@property (nonatomic,strong)        UIButton            *goodBtn;

@end

@implementation WWFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WW_BASE_COLOR;
    
    navtaionBarView = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"意见反馈" withRightBtn:NO withRightBtnPicName:@"" withRightBtnSize:CGSizeZero];
    [self.view addSubview:navtaionBarView];
    
    [self feedbackViewLayout];
    
}

- (void)feedbackViewLayout{
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, IOS7_Y+54, MainView_Width, 290)];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backView];
    // 上下线条
    UILabel *upLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.backView.width, 0.5f)];
    upLine.backgroundColor = WWPageLineColor;
    [self.backView addSubview:upLine];
    UILabel *downLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.backView.height-0.5f, self.backView.width, 0.5f)];
    downLine.backgroundColor = WWPageLineColor;
    [self.backView addSubview:downLine];
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, MainView_Width-20, self.backView.height-35)];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.textColor = WWSubTitleTextColor;
    self.textView.font = [UIFont systemFontOfSize:14.0f];
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeyDone;
    [self.backView addSubview:self.textView];
    
    self.placeholder = [[UILabel alloc]initWithFrame:CGRectMake(5, 9, self.textView.width, 12)];
    self.placeholder.textColor = WWSubTitleTextColor;
    self.placeholder.font =[UIFont systemFontOfSize:12.0f];
    self.placeholder.text = @"您有任何的问题或者建议，都可以在这里向我们提出哦！";
    [self.textView addSubview:self.placeholder];
    
    // 数量
    self.allTextNum = [[UILabel alloc]initWithFrame:CGRectMake(MainView_Width-40, self.backView.height-25, 40, 14)];
    self.allTextNum.text = @"/500";
    self.allTextNum.textColor = WWSubTitleTextColor;
    self.allTextNum.font = [UIFont systemFontOfSize:14.0f];
    [self.backView addSubview:self.allTextNum];
    
    self.textNum = [[UILabel alloc]initWithFrame:CGRectMake(self.allTextNum.left-40, self.backView.height-25, 40, 15)];
    int number = self.textView.text.length > 0 ? (int)self.textView.text.length:0;
    self.textNum.text = [NSString stringWithFormat:@"%d",number];
    self.textNum.textAlignment = NSTextAlignmentRight;
    self.textNum.textColor = WWSubTitleTextColor;
    self.textNum.font = [UIFont systemFontOfSize:14.0f];
    [self.backView addSubview:self.textNum];
    
    self.feedbackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.feedbackBtn.frame = CGRectMake(0, self.backView.bottom+15, MainView_Width, 44);
    [self.feedbackBtn setTitle:@"发送" forState:UIControlStateNormal];
    self.feedbackBtn.backgroundColor = WWBtnYellowColor;
    [self.feedbackBtn setBackgroundImage:[WWUtilityClass imageWithColor:RGBCOLOR(211, 120, 23)] forState:UIControlStateHighlighted];
    [self.feedbackBtn addTarget:self action:@selector(submitFeedBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.feedbackBtn];

}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    int number = (textView.text.length-range.length+text.length) > 0 ? (int)(textView.text.length-range.length+text.length):0;
    self.textNum.text = [NSString stringWithFormat:@"%d",number];
    if (textView.text.length-range.length+text.length >= 500) {
        [SVProgressHUD showInfoWithStatus:@"不能超过500字哦！"];
        
        return NO;
    }
    if ([text isEqualToString:@"\n"]) {
        if ([self.textNum.text intValue]-1 > 0) {
            self.placeholder.hidden = YES;
        }else{
            self.placeholder.hidden = NO;
        }
        [textView resignFirstResponder];
        return NO;
    }
    if (![self.textNum.text isEqualToString:@"0"]) {
        self.placeholder.hidden = YES;
    }else{
        self.placeholder.hidden = NO;
    }
    
    return YES;
}

- (void)submitFeedBack{
    if ([self.textView.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请输入反馈内容"];
        return;
    }
    [self.textView resignFirstResponder];

    [FMHTTPClient PostFeedBackToServerContent:self.textView.text WithCompletion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response.code == WebAPIResponseCodeSuccess) {
                self.textView.text = @"";
                self.textNum.text = @"0";
                self.placeholder.hidden = NO;
                [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            }
        });
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
