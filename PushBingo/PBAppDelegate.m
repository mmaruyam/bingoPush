//
//  PBAppDelegate.m
//  PushBingo
//
//  Created by Takumi Yamamoto on 2013/10/16.
//  Copyright (c) 2013年 Takumi Yamamoto. All rights reserved.
//

#import "PBAppDelegate.h"
#import "PBTopViewController.h"

@implementation PBAppDelegate

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSLog(@"FBLogin sourceApplication");
    
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:self.session];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge
                                                                           | UIRemoteNotificationTypeSound
                                                                           | UIRemoteNotificationTypeAlert)];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    PBTopViewController* pbTopCon = [[PBTopViewController alloc] init];
    [pbTopCon setTitle:@"トップページ"];
    UINavigationController* naviCon = [[UINavigationController alloc] initWithRootViewController:pbTopCon];
    self.window.rootViewController = naviCon;

    return YES;
}

// デバイストークンを受信した際の処理
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    NSMutableString *tokenId = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",devToken]];
    [tokenId setString:[tokenId stringByReplacingOccurrencesOfString:@" " withString:@""]]; //余計な文字を消す
    [tokenId setString:[tokenId stringByReplacingOccurrencesOfString:@"<" withString:@""]];
    [tokenId setString:[tokenId stringByReplacingOccurrencesOfString:@">" withString:@""]];
    NSLog(@"deviceToken: %@", tokenId);
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:tokenId forKey:@"DEVICE_TOKEN"];
    
}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)err{
    NSLog(@"Errorinregistration:%@",err);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"becomeActive");
    [FBAppEvents activateApp];
    
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self.session close];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    NSLog(@"hogehoge - %@",userInfo);
    
    NSLog(@"remote notification: %@",[userInfo description]);
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
    NSString *alert = [apsInfo objectForKey:@"alert"];
    NSLog(@"Received Push Alert: %@", alert);
    
    /*
    NSString *sound = [apsInfo objectForKey:@"sound"];
    NSLog(@"Received Push Sound: %@", sound);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    */
    
    NSString *badge = [apsInfo objectForKey:@"badge"];
    NSLog(@"Received Push Badge: %@", badge);
    application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];

    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSArray* pullNem = [userDef objectForKey:@"PULL_NUMBER"];
    NSMutableArray* maryPullNum = [pullNem mutableCopy];
    [maryPullNum addObject:[apsInfo objectForKey:@"custom"]];
    [userDef setObject:maryPullNum forKey:@"PULL_NUMBER"];
    
    NSLog(@"mary mary = %@" , maryPullNum);
    
    
    
    UIAlertView *pushAlert = [[UIAlertView alloc] initWithTitle:@"info" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                              delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil];
    [pushAlert show];
    
}

@end
