//
//  WWUserInformationViewController.m
//  WWSampleProject
//
//  Created by push on 15/10/14.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWUserInformationViewController.h"
#import "OSSsendPicture.h"
#import "WWUserNameModifyViewController.h"
#import "HTTPClient+Other.h"


@interface WWUserInformationViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MLImageCropDelegate,ModifyUserNameDelegate>{
    WWPublicNavtionBar *viewNavBarView;
    UIImagePickerController *_pickerImage;
    NSString * uploadTheImagePath;
}

@property (nonatomic,strong)UIView              *headView;      // 头像背静view
@property (nonatomic,strong)UILabel             *headContent;
@property (nonatomic,strong)UIImageView         *headImage;
@property (nonatomic,strong)UIImageView         *headArrow;
@property (nonatomic,strong)UIButton            *headBtn;
@property (nonatomic,strong)UIView              *nameView;      // 名称
@property (nonatomic,strong)UILabel             *nameContent;
@property (nonatomic,strong)UILabel             *nameText;
@property (nonatomic,strong)UIImageView         *nameArrow;
@property (nonatomic,strong)UIButton            *nameBtn;

@property (nonatomic,strong)NSString            *userNameStr;       // 用户名称

@end

@implementation WWUserInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WW_BASE_COLOR;
    
    viewNavBarView = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"基本信息" withRightBtn:NO withRightBtnPicName:@"" withRightBtnSize:CGSizeZero];
    __weak __typeof(&*self)weakSelf = self;
    viewNavBarView.TapLeftButton = ^{
        [weakSelf leftBackBtn];
    };
    [self.view addSubview:viewNavBarView];
    
#pragma mark ---  用户头像
    self.headView = ({
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, IOS7_Y+49, MainView_Width, 60*kPercenX)];
        headView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:headView];
        headView;
    });
    // 上下线条
    UILabel *upLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.headView.width, 1)];
    upLine.backgroundColor = WWPageLineColor;
    [self.headView addSubview:upLine];
    UILabel *downLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.headView.height-1, self.headView.width, 1)];
    downLine.backgroundColor = WWPageLineColor;
    [self.headView addSubview:downLine];
    self.headContent = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, (self.headView.height-13*kPercenX)/2, 100, 13*kPercenX)];
        label.text = @"头像";
        label.textColor = WWContentTextColor;
        label.font = [UIFont systemFontOfSize:13.0f*kPercenX];
        [self.headView addSubview:label];
        label;
    });
    self.headArrow = ({
        // 方向箭头
        UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.headView.width-24*kPercenX, (self.headView.height-24*kPercenX)/2, 24*kPercenX, 24*kPercenX)];
        arrowImage.image = [UIImage imageNamed:@"check--details"];
        [self.headView addSubview:arrowImage];
        arrowImage;
    });
    // 头像
    self.headImage = ({
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(self.headArrow.left-45*kPercenX, (self.headView.height-45*kPercenX)/2, 45*kPercenX, 45*kPercenX)];
        if ([self.userFaceUrl isEqualToString:@""]) {
            image.image = [UIImage imageNamed:@"img_ftx"];
        }{
            [image sd_setImageWithURL:[NSURL URLWithString:self.userFaceUrl] placeholderImage:[UIImage imageNamed:@"img_ftx"]];
        }
        
        [self.headView addSubview:image];
        image;
    });
    self.headBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.headBtn.frame = CGRectMake(0, 0, self.headView.width, self.headView.height);
    [self.headBtn setBackgroundImage:[WWUtilityClass imageWithColor:WWBtnStateHighlightedColor] forState:UIControlStateHighlighted];
    [self.headBtn addTarget:self action:@selector(headImageBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:self.headBtn];
    
#pragma mark ---  用户名称
    self.nameView = ({
        UIView *nameView = [[UIView alloc]initWithFrame:CGRectMake(0, self.headView.bottom+5, MainView_Width, 44*kPercenX)];
        nameView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:nameView];
        nameView;
    });
    // 上下线条
    UILabel *nameUpLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.nameView.width, 1)];
    nameUpLine.backgroundColor = WWPageLineColor;
    [self.nameView addSubview:nameUpLine];
    UILabel *nameDownLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.nameView.height-1, self.nameView.width, 1)];
    nameDownLine.backgroundColor = WWPageLineColor;
    [self.nameView addSubview:nameDownLine];
    self.nameContent = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, (self.nameView.height-13*kPercenX)/2, 100, 13*kPercenX)];
        label.text = @"昵称";
        label.textColor = WWContentTextColor;
        label.font = [UIFont systemFontOfSize:13.0f*kPercenX];
        [self.nameView addSubview:label];
        label;
    });
    self.nameArrow = ({
        // 方向箭头
        UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.nameView.width-24*kPercenX, (self.nameView.height-24*kPercenX)/2, 24*kPercenX, 24*kPercenX)];
        arrowImage.image = [UIImage imageNamed:@"check--details"];
        [self.nameView addSubview:arrowImage];
        arrowImage;
    });
    self.nameText = ({
        // 内容
        UILabel *subContentLab = [[UILabel alloc]initWithFrame:CGRectMake(self.nameArrow.left-100, (self.nameView.height-13*kPercenX)/2, 100, 13*kPercenX)];
        subContentLab.textAlignment = NSTextAlignmentRight;
        subContentLab.text = self.userName;
        subContentLab.textColor = WWSubTitleTextColor;
        subContentLab.font = [UIFont systemFontOfSize:13.0f*kPercenX];
        [self.nameView addSubview:subContentLab];
        subContentLab;
    });
    self.nameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.nameBtn.frame = CGRectMake(0, 0, self.nameView.width, self.nameView.height);
    [self.nameBtn setBackgroundImage:[WWUtilityClass imageWithColor:WWBtnStateHighlightedColor] forState:UIControlStateHighlighted];
    [self.nameBtn addTarget:self action:@selector(nameBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.nameView addSubview:self.nameBtn];
    
}

- (void)headImageBtnClickEvent:(UIButton *)sender{
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选取", nil];
    [action showInView:self.view];
}

- (void)nameBtnClickEvent:(UIButton *)sender{
    WWUserNameModifyViewController *modifyVC = [[WWUserNameModifyViewController alloc]init];
    modifyVC.delegate = self;
    modifyVC.nameStr = self.userName;
    [self.navigationController pushViewController:modifyVC animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        _pickerImage = [[UIImagePickerController alloc]init];
        _pickerImage.delegate = self;
        _pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        _pickerImage.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        _pickerImage.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        _pickerImage.showsCameraControls = YES;
        _pickerImage.allowsEditing = YES;
        [self presentViewController:_pickerImage animated:YES completion:nil];
        
    }else if (buttonIndex == 1) {
        _pickerImage  = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            _pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
        _pickerImage.delegate = self;
        _pickerImage.allowsEditing = NO;
        [self presentViewController:_pickerImage animated:YES completion:^{
            
        }];
    }
}

#pragma mark ----- UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //关闭相册选取控制器
    [picker dismissViewControllerAnimated:YES completion:^{
        //获取到媒体的类型
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        //判断选取的资源是否为相片
        
        if([mediaType isEqualToString:@"public.image"]) {
            UIImage  *images = [info objectForKey:UIImagePickerControllerOriginalImage];
            [self ClipPhoto:images];
            
        }
    }];
}

//用户取消拍照
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)ClipPhoto:(UIImage *)imageObj
{
    MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
    imageCrop.delegate = self;
    imageCrop.ratioOfWidthAndHeight = 1;
    imageCrop.image = imageObj;
    [imageCrop showWithAnimation:YES];
}

#pragma mark - crop delegate
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    self.headImage.image = [self imageWithImageSimple:cropImage scaledToSize:CGSizeMake(100, 100)];
    // 上传图片
    [self userHeadPhotoSendOSS];
}

- (void)userHeadPhotoSendOSS{
    
//    if (self.headImage.image) {
//        OSSsendPicture *sendPic = [OSSsendPicture sharedInstance];
//        sendPic.bucketKey = kBucketKeyFormAS;
//        sendPic.cnameKey = kCnameKeyFormCN_HZ;
//        if ([sendPic OSSJudgeImageSizeFormImage:self.headImage.image]) {
//            return;
//        }
//        uploadTheImagePath = [sendPic OSSsendImageToOSSFormImageData:self.headImage.image imageContentOfRoute:@"face"];
//        if (IsStringEmptyOrNull(uploadTheImagePath)) {
//            [SVProgressHUD showErrorWithStatus:@"图片上传失败，请重新选择"];
//            uploadTheImagePath = @"";
//        }
//    }
}

//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

// WWUserNameModifyViewControllerViewDelegate
- (void)userNameModifyDelegate:(NSString *)userName{
    self.nameText.text = userName;
    self.userNameStr = userName;
}

- (void)leftBackBtn{
    if (uploadTheImagePath == NULL) {
        uploadTheImagePath = @"";
    }
    if (self.userNameStr == NULL) {
        self.userNameStr = self.nameText.text;
    }
    
    NSDictionary * parme = @{@"id":[WWUtilityClass getNSUserDefaults:UserID],
                             @"faceUrl":uploadTheImagePath,
                             @"userName":self.userNameStr};
    
    [FMHTTPClient PostRequestModityUserInformationParmae:parme WithCompletion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response.code == WebAPIResponseCodeSuccess) {
                // 通知--刷新个人信息
                [[NSNotificationCenter defaultCenter] postNotificationName:WWRefreshUserInformation object:nil];
            }
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
