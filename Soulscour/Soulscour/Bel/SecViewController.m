//
//  SecViewController.m
//  Article
//
//  Created by 小强 on 16/10/26.
//  Copyright © 2016年 xiaoqiang. All rights reserved.
//

#import "SecViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <WebKit/WebKit.h>
#import "UIImageView+WebCache.h"

#define kWealUrl @"http://jtbk.vipappsina.com/yulu/card21/articleDetail.php?id="
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface SecViewController ()<UIWebViewDelegate>

@property(nonatomic,strong) UIWebView *webView;
@property(nonatomic,strong) WKWebView *wkView;
//是否已经加载
@property (nonatomic, assign) BOOL isLoaded;

//加载进度条
@property (nonatomic,strong)UIProgressView *progressView;

@end

@implementation SecViewController

//懒加载进度条
-(UIProgressView *)progressView
{
    if (_progressView == nil) {
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.origin.y =0;
        frame.size.height =2;
        _progressView =[[UIProgressView alloc]initWithFrame:frame];
        _progressView.progressViewStyle = UIProgressViewStyleDefault;
    }
    return _progressView;
}

#pragma mark webView的懒加载
-(UIWebView *)webView
{
    if (_webView == nil) {
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.origin.y -=80;
        frame.size.height +=80;
        
        _webView =[[UIWebView alloc]initWithFrame:frame];
        _webView.delegate =self;
        _webView.scrollView.bounces =NO;
    }
    return _webView;
}


#pragma mark wkView的懒加载
-(WKWebView *)wkView
{
    if (_wkView ==nil) {
        CGRect frame =[UIScreen mainScreen].bounds;
        frame.origin.y -= 80;
        frame.size.height += 80;
        _wkView =[[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    }
    return _wkView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.mode.title;
    UIImage *rightImage = [UIImage imageNamed:@"share.png"];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(action:)];
    self.navigationItem.rightBarButtonItem =right;
    
    UIImage *leftImage = [UIImage imageNamed:@"back.png"];
    leftImage =[leftImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    
    //添加webView
    [self.view addSubview:self.wkView];
    [self.view addSubview:self.progressView];
    self.progressView.progress = 0.0;
    
    //加载webView数据
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kWealUrl,self.mode.id1];
    NSLog(@"%@",urlString);
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.wkView loadRequest:request];
    [self.wkView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"%f",self.wkView.estimatedProgress);
        [self.progressView setProgress:self.wkView.estimatedProgress animated:YES];
        
        if (self.wkView.estimatedProgress == 1) {
            self.progressView.hidden = YES;
            [self.wkView removeObserver:self forKeyPath:@"estimatedProgress"];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

-(void)back:(id)sender
{
    while ([self.wkView observationInfo]) {
        NSLog(@"%@",[self.wkView observationInfo]);
        [self.wkView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)action:(id)sender
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kWealUrl,self.mode.id1];
    NSLog(@"%@",urlString);
    NSURL *urls =[NSURL URLWithString:urlString];
    NSLog(@"%@",_mode.pic);
    NSString *str = _mode.title;
    NSURL *url =[NSURL URLWithString:_mode.pic];
    NSData *data =[NSData dataWithContentsOfURL:url];
    UIImage *imageName=[UIImage imageWithData:data];
    //1、创建分享参数
    NSArray* imageArray = @[urlString,_mode.title,imageName];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:urlString
                                         images:@[imageName]
                                            url:urls
                                          title:str
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
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
