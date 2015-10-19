//
//  WWClotheSpressViewController.m
//  WWSampleProject
//
//  Created by ww on 15/10/13.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWClotheSpressViewController.h"
#define KLANGUAGELOCALIZABLE_LANGUAGENameKey    @"LANGUAGELOCALIZABLE_LANGUAGENameKey"
@interface WWClotheSpressViewController (){
    WWPublicNavtionBar *navtionBarView;
}

@property (nonatomic,strong)        UIView              *clockbakcGroupView;
@property (nonatomic,strong)        UIButton            *clockDynamicButton;
@property (nonatomic,strong)        UIButton            *clockNumberButton;
@property (nonatomic,strong)        UILabel             *clockChooseLabel;

@end

@implementation WWClotheSpressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = WW_BASE_COLOR;
    
    navtionBarView = [[WWPublicNavtionBar alloc] initWithLeftBtn:NO withTitle:@"衣柜" withRightBtn:NO withRightBtnPicName:nil withRightBtnSize:CGSizeZero];
    [self.view addSubview:navtionBarView];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *string = [def valueForKey:KLANGUAGELOCALIZABLE_LANGUAGENameKey];
    if(string.length == 0){
        //获取系统当前语言版本
        NSArray* languages = [def objectForKey:@"AppleLanguages"];
        
        if (languages.count > 0) {
            NSString *current = [languages objectAtIndex:0];
            string = current;
            [def setValue:current forKey:KLANGUAGELOCALIZABLE_LANGUAGENameKey];
            [def synchronize];//持久化，不加的话不会保存
        }
    }
    
    NSString *language = [def valueForKey:KLANGUAGELOCALIZABLE_LANGUAGENameKey];
    
    NSLog(@"current is %@",language);
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
