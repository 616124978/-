//
//  AppDelegate.m
//  Soulscour
//
//  Created by lanou on 16/10/27.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "AppDelegate.h"
#import "PoeViewController.h"
#import "OtherViewController.h"
#import "BeaViewController.h"
#import "LeftSortsViewController.h"
#import "BelViewController.h"

//第三方
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

-(UIViewController *)createVCWithClass:(Class)class
                                 title:(NSString *)title
                           normalImage:(NSString *)normalImage
                         selectedImage:(NSString *)selectedImage
{
    UIViewController *VC=[[class alloc] init];
    UIImage *norImage=[UIImage imageNamed:normalImage];
    norImage=[norImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *selImage=[UIImage imageNamed:selectedImage];
    selImage=[selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    VC.tabBarItem=[[UITabBarItem alloc] initWithTitle:title image:norImage selectedImage:selImage];
    
    return VC;
}

-(UITabBarController *)createTabbarController
{
    PoeViewController *poeVC=(PoeViewController *)[self createVCWithClass:[PoeViewController class] title:@"诗歌" normalImage:@"poe.png" selectedImage:@"poe1.png"];
    UINavigationController *poeNav=[[UINavigationController alloc] initWithRootViewController:poeVC];
    
    OtherViewController *otherVC = (OtherViewController *)[self createVCWithClass:[OtherViewController class] title:@"其他" normalImage:@"未收藏.png" selectedImage:@"已收藏.png"];
    UINavigationController *otherNav=[[UINavigationController alloc] initWithRootViewController:otherVC];
    //美图美文
    BeaViewController *beaVC=(BeaViewController *)[self createVCWithClass:[BeaViewController class] title:@"美图文" normalImage:@"图文.png" selectedImage:@"图文2.png"];

    //文章
    BelViewController *belVC =(BelViewController *)[self createVCWithClass:[BelViewController class] title:@"美文" normalImage:@"01.png" selectedImage:@"011.png"];
    
    UINavigationController *beaNav=[[UINavigationController alloc]initWithRootViewController:beaVC];
    
    //文章导航栏
     UINavigationController *belNav = [[UINavigationController alloc]initWithRootViewController:belVC];
    
    UITabBarController *tabbarVC=[[UITabBarController alloc] init];
    
    tabbarVC.viewControllers=@[beaNav,belNav,poeNav];
    
    tabbarVC.selectedIndex=0;
    
    tabbarVC.tabBar.translucent=NO;
    
    [ShareSDK registerApp:@"181e588cedb64"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"318426926"
                                           appSecret:@"83bfcd2352e16a9b05606234ad63cfcb"                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                       appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105713721"
                                      appKey:@"dFIj2f76f4joRiVj"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];

    return tabbarVC;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    self.mainNavigationController = [self createTabbarController];
    LeftSortsViewController *leftVC = [[LeftSortsViewController alloc] init];
    self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.mainNavigationController];
    self.window.rootViewController = self.LeftSlideVC;
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.389 green:0.603 blue:1.000 alpha:1.000]];
    
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:0.950 green:0.945 blue:1.000 alpha:1.000]];
    
    [[UITabBar appearance] setTranslucent:NO];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
