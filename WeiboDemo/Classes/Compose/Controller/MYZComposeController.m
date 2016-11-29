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
#import "MYZComposeEmotionKeyboard.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import "MYZEmotion.h"
#import "MYZStatusTool.h"



NSInteger const ComposePicRowColumnCount = 3; //要发布的图片每行每列展示的个数
CGFloat const ComposePicMarginLR = 10.0; //要展示的图片大视图左右间距
CGFloat const ComposePicMarginAmong = 6.0; //展示的图片和图片之间的间隙

CGFloat const ComposeEmotionKeyboardH = 216.0; //表情键盘高度

//表情键盘删除按钮通知标志
NSString * const ComposeEmotionKeyboardDeleteKey = @"EmotionKeyboardDeleteKey";
//表情键盘选择表情通知标志
NSString * const ComposeEmotionSelectedKey = @"EmotionSelectedKey";

@interface MYZComposeController () <UITextViewDelegate, MYZComposeToolsBarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//输入框
@property (nonatomic, weak) MYZComposeTextView * textView;

//展示图片视图
@property (nonatomic, weak) MYZComposePicsView * picsView;

//键盘上的工具条
@property (nonatomic, weak) MYZComposeToolsBar * toolsBar;

//是否正在切换键盘标志
@property (nonatomic, assign, getter=isChangingKeyboard) BOOL changingKeyboard;

//表情键盘
@property (nonatomic, strong) MYZComposeEmotionKeyboard * emotionKeyboard;

@end

@implementation MYZComposeController

- (MYZComposeEmotionKeyboard *)emotionKeyboard
{
    if (_emotionKeyboard == nil)
    {
        _emotionKeyboard = [[MYZComposeEmotionKeyboard alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, ComposeEmotionKeyboardH)];
        
        NSMutableArray * emotionKeyboardDataArray = [NSMutableArray array];
        
        //2016.11.18 修改在获取表情的时候就去分组20个一组，数组里面放数组，这样在下面的视图中就不用去算了
        //默认表情
        NSString * defaultPlist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        NSArray * defaultEmotionInfos = [NSArray arrayWithContentsOfFile:defaultPlist];
        NSMutableArray * defaultEmotionArray = [NSMutableArray array];
//        for (NSDictionary * tempDic in defaultEmotionInfos)
//        {
//            MYZEmotion * emotion = [[MYZEmotion alloc] initEmotionWithDictionary:tempDic];
//            [defaultEmotionArray addObject:emotion];
//        }
//        [defaultEmotionArray makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/default"];
        
        __block NSMutableArray * defaultSectionArray = [NSMutableArray array];
        [defaultEmotionInfos enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (idx % 20 == 0 && idx != 0)
            {
                [defaultEmotionArray addObject:defaultSectionArray];
                defaultSectionArray = [NSMutableArray array];
            }
            
            MYZEmotion * emotion = [[MYZEmotion alloc] initEmotionWithDictionary:obj];
            emotion.directory = @"EmotionIcons/default";
            [defaultSectionArray addObject:emotion];
            
        }];
        [defaultEmotionArray addObject:defaultSectionArray];
        [emotionKeyboardDataArray addObject:defaultEmotionArray];
        
        
        //emoji表情
        NSString * emojiPlist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        NSArray * emojiInfos = [NSArray arrayWithContentsOfFile:emojiPlist];
        NSMutableArray * emojiArray = [NSMutableArray array];
        
        __block NSMutableArray * emojiSectionArray = [NSMutableArray array];
        [emojiInfos enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (idx % 20 == 0 && idx != 0)
            {
                [emojiArray addObject:emojiSectionArray];
                emojiSectionArray = [NSMutableArray array];
            }
            MYZEmotion * emotion = [[MYZEmotion alloc] initEmotionWithDictionary:obj];
            emotion.directory = @"EmotionIcons/emoji";
            [emojiSectionArray addObject:emotion];
            
        }];
        [emojiArray addObject:emojiSectionArray];
        [emotionKeyboardDataArray addObject:emojiArray];
        
        
        
        //小浪花表情
        NSString * lxhPlist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        NSArray * lxhInfos = [NSArray arrayWithContentsOfFile:lxhPlist];
        NSMutableArray * lxhArray = [NSMutableArray array];
        
        __block NSMutableArray * lxhSectionArray = [NSMutableArray array];
        [lxhInfos enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (idx % 20 == 0 && idx != 0)
            {
                [lxhArray addObject:lxhSectionArray];
                lxhSectionArray = [NSMutableArray array];
            }
            MYZEmotion * emotion = [[MYZEmotion alloc] initEmotionWithDictionary:obj];
            emotion.directory = @"EmotionIcons/lxh";
            [lxhSectionArray addObject:emotion];
            
        }];
        [lxhArray addObject:lxhSectionArray];
        [emotionKeyboardDataArray addObject:lxhArray];
        
        _emotionKeyboard.emotionKeyboardDataArray = emotionKeyboardDataArray;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(composeEmotionKeyboardDeleteBtnTouch) name:ComposeEmotionKeyboardDeleteKey object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(composeEmotionViewTouch:) name:ComposeEmotionSelectedKey object:nil];
//        //__weak typeof(self) weakSelf = self;
//        _emotionKeyboard.emotionKeyboardBlock = ^(MYZEmotion * emotion){
//            MYZLog(@" --- compose %@", emotion);
//        };
    }
    return _emotionKeyboard;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}


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
    //[SVProgressHUD show];
    
    NSMutableDictionary * paramDic = [NSMutableDictionary dictionary];
    [paramDic setValue:[[MYZTools account] access_token] forKey:@"access_token"];
    [paramDic setValue:self.textView.text forKey:@"status"];
    
    if (self.picsView.imageArray.count > 0)
    {
        UIImage * uploadImage = [self.picsView.imageArray firstObject];
        NSData * uploadImageData = UIImageJPEGRepresentation(uploadImage, 0.8);
        [paramDic setValue:uploadImageData forKey:@"pic"];

    }
    
    
    [MYZStatusTool sendStatusWithParam:paramDic success:^(id result) {
        //[SVProgressHUD dismiss];
        [MYZTools showAlertWithText:@"发送成功"];
        
    } failure:^(NSError *error) {
        //[SVProgressHUD dismiss];
        [MYZTools showAlertWithText:@"发送失败，稍后重试"];
    }];
    
    //在后台发送
    [MYZTools showAlertWithText:@"已发送"];
    [self cancelBack];
    
//    //http://ww1.sinaimg.cn/large/00696P6Fjw1f9vhzfzt11j31kw11yqqb.jpg
//    NSMutableDictionary * paramDic = [NSMutableDictionary dictionary];
//    [paramDic setValue:[[MYZTools account] access_token] forKey:@"access_token"];
//    [paramDic setValue:self.textView.text forKey:@"status"];
//    
//    [paramDic setValue:@"http://ww1.sinaimg.cn/large/00696P6Fjw1f9vhzfzt11j31kw11yqqb.jpg,http://ww1.sinaimg.cn/large/00696P6Fjw1f9vhzfzt11j31kw11yqqb.jpg,http://ww1.sinaimg.cn/large/00696P6Fjw1f9vhzfzt11j31kw11yqqb.jpg,http://ww1.sinaimg.cn/large/00696P6Fjw1f9vhzfzt11j31kw11yqqb.jpg" forKey:@"pic_id"];
//    
//    
//    [MYZStatusTool sendStatusUploadUrlTextWithParam:paramDic success:^(id result) {
//        MYZLog(@"--- %@ ", result);
//        [MYZTools showAlertWithText:@"发送成功"];
//    } failure:^(NSError *error) {
//        MYZLog(@"--- %@ ", error);
//    }];
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
    [textView addSubview:picsView];
    self.picsView = picsView;
}


#pragma mark  UITextView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.changingKeyboard = NO;
    //当textView滚动时收起键盘
    [self.textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    //根据textView是否输入来判断是否显示发送按钮
    self.navigationItem.rightBarButtonItem.enabled = (textView.text.length != 0);
}



#pragma mark - 自定义表情键盘点击事件

- (void)composeEmotionKeyboardDeleteBtnTouch
{
    MYZLog(@" --- composeEmotionKeyboardDeleteBtnTouch");
}

- (void)composeEmotionViewTouch:(MYZEmotion *)emotion
{
    MYZLog(@" --- composeEmotionViewTouch: %@ ", emotion);
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
    self.changingKeyboard = YES;
    
    if (self.textView.inputView)
    {
        self.textView.inputView = nil;
        self.toolsBar.showEmotionButton = YES;
    }
    else
    {
        self.textView.inputView = self.emotionKeyboard;
        self.toolsBar.showEmotionButton = NO;
    }
    
    
    [self.textView resignFirstResponder]; //这个要放在self.changingKeyboard = YES;的后面否则toolbar收不回去
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView becomeFirstResponder];
    });
    
}

#pragma mark - Imagepicker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];

    UIImage * originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //NSData * headImageData = UIImageJPEGRepresentation(originImage, 1.0); //UIImagePNGRepresentation(originImage);
    //NSUInteger headImageSize = headImageData.length;
    //if (headImageSize > 100 * 1024) //图片大小 100K
    
    [self.picsView addImageInView:originImage];
    
    
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
    //是否正在切换emotion键盘，是就不需要移动toolsbar了
    if(self.isChangingKeyboard)
    {
        self.changingKeyboard = NO;
        return;
    }
    
    //键盘回收时间
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.toolsBar.transform = CGAffineTransformIdentity;
    }];
}





@end
