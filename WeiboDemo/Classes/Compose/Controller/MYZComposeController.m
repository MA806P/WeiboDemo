//
//  MYZComposeController.m
//  WeiboDemo
//
//  Created by MA806P on 16/9/27.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZComposeController.h"
#import "MYZComposeTextView.h"
#import "MYZComposeToolsBar.h"
#import "MYZComposePicsView.h"

#import <AssetsLibrary/AssetsLibrary.h>


NSInteger const ComposePicRowColumnCount = 3; //要发布的图片每行每列展示的个数
CGFloat const ComposePicMarginLR = 13.0; //要展示的图片大视图左右间距
CGFloat const ComposePicMarginAmong = 6.0; //展示的图片和图片之间的间隙


@interface MYZComposeController () <UITextViewDelegate, MYZComposeToolsBarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//输入框
@property (nonatomic, weak) MYZComposeTextView * textView;

//展示图片视图
@property (nonatomic, weak) MYZComposePicsView * picsView;

//键盘上的工具条
@property (nonatomic, weak) MYZComposeToolsBar * toolsBar;

@end

@implementation MYZComposeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置导航栏
    [self setupNavigationBar];
    
    //创建发送微博输入视图
    [self setupSendTextView];
    
    //创建键盘上的工具条
    [self setupToolsBar];
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - 导航栏 视图 点击事件处理

- (void)setupNavigationBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendStatus)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.title = @"名称";
}


- (void)sendStatus
{
}


- (void)cancelBack
{
    [self.textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 发送微博输入视图

- (void)setupSendTextView
{
    CGFloat textViewY = 64;
    CGFloat textViewH = self.view.frame.size.height - textViewY;
    CGFloat textViewX = ComposePicMarginLR;
    CGFloat textViewW = self.view.frame.size.width - textViewX * 2.0;
    
    MYZComposeTextView * textView = [[MYZComposeTextView alloc] initWithFrame:CGRectMake(textViewX, textViewY, textViewW, textViewH)];
    textView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    textView.placeholder = @"分享新鲜事...";
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
    
    //选择图片展示的视图
    MYZComposePicsView * picsView = [[MYZComposePicsView alloc] initWithFrame:CGRectMake(0, 110, textViewW, textViewW)];
    picsView.backgroundColor = [UIColor lightGrayColor];
    [self.textView addSubview:picsView];
    self.picsView = picsView;
}


#pragma mark  UITextView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //当textView滚动时收起键盘
    [self.textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    //根据textView是否输入来判断是否显示发送按钮
    self.navigationItem.rightBarButtonItem.enabled = (textView.text.length != 0);
}



#pragma mark - 键盘上的工具条

- (void)setupToolsBar
{
    CGFloat toolsBarH = 44;
    CGFloat toolsBarW = self.view.frame.size.width;
    CGFloat toolsBarY = self.view.frame.size.height - toolsBarH;
    MYZComposeToolsBar * toolsBar = [[MYZComposeToolsBar alloc] initWithFrame:CGRectMake(0, toolsBarY, toolsBarW, toolsBarH)];
    toolsBar.delegate = self;
    [self.view addSubview:toolsBar];
    self.toolsBar = toolsBar;
    
    //监听键盘弹出或回收,设置toolsBar的位置
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(composeKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(composeKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    
}


- (void)composeToolsBar:(MYZComposeToolsBar *)bar didClickedButton:(ComposeToolsBarButtonType)btnType
{
    if (btnType == ComposeToolsBarButtonTypePicture)
    {
        [self openPicture]; //打开相册
    }
    else if (btnType == ComposeToolsBarButtonTypeMention)
    {
        [self openMention]; //打开@好友页
    }
    else if (btnType == ComposeToolsBarButtonTypeTrend)
    {
        [self openTrend]; //打开话题页
    }
    else if (btnType == ComposeToolsBarButtonTypeEmotion)
    {
        [self openEmotion]; //切换表情键盘
    }
}


- (void)openPicture
{
    //是否支持相册功能
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        [MYZTools showAlertWithText:@"该设备不支持相册功能"];
        return;
    }
    
    //是否授权访问照片
    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    if (authStatus == ALAuthorizationStatusDenied)
    {
        //应用名称, 提示信息里会用到
        NSDictionary * mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString * appName = [mainInfoDictionary objectForKey:@"CFBundleName"];
        
        NSString * message = [NSString stringWithFormat:@"没有权限访问照片\n请进入系统 设置>隐私>照片 允许\"%@\"访问您的照片",appName];
        [MYZTools showAlertWithText:message];
        return;
    }
    
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerImage.delegate = self;
    [self presentViewController:pickerImage animated:YES completion:nil];
}

- (void)openMention
{
    MYZLog(@"@XXX");
}

- (void)openTrend
{
    MYZLog(@"#XXX#");
}

- (void)openEmotion
{
    
}

#pragma mark - Imagepicker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
    
        UIImage * originImage = [info objectForKey:UIImagePickerControllerEditedImage];
        //NSData * headImageData = UIImageJPEGRepresentation(originImage, 1.0); //UIImagePNGRepresentation(originImage);
        //NSUInteger headImageSize = headImageData.length;
        //if (headImageSize > 100 * 1024) //图片大小 100K
        
        [self.picsView addImageInView:originImage];
    
    }];
    
    
}


#pragma mark - 键盘弹出或回收事件处理

- (void)composeKeyboardWillShow:(NSNotification *)notification
{
    //键盘弹出时间
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //键盘的高度
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardH = keyboardFrame.size.height;
    
    //移动toolsbar动画
    [UIView animateWithDuration:duration animations:^{
        self.toolsBar.transform = CGAffineTransformMakeTranslation(0, -keyBoardH);
    }];
}

- (void)composeKeyboardWillHide:(NSNotification *)notification
{
    //键盘回收时间
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.toolsBar.transform = CGAffineTransformIdentity;
    }];
}





@end
