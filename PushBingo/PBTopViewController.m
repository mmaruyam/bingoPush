//
//  PBTopViewController.m
//  PushBingo
//
//  Created by Takumi Yamamoto on 2013/10/16.
//  Copyright (c) 2013年 Takumi Yamamoto. All rights reserved.
//

#import "PBTopViewController.h"
#import "PBAdminViewController.h"
#import "PBGuestInputIDViewController.h"
#import "PBAppDelegate.h"
#import "PBURLConnection.h"
#import "PBAboutThisAppViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface PBTopViewController ()

@end

@implementation PBTopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init
{
    self = [super init];
    
    if(self){
        UIBarButtonItem *btn =
        [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
         target:self  // デリゲートのターゲットを指定
         action:@selector(tapKiyaku:)  // ボタンが押されたときに呼ばれるメソッドを指定
         ];
        self.navigationItem.rightBarButtonItem = btn;

    }
    
    return self;
}

-(void)tapKiyaku:(id)sender
{
    NSLog(@"hogehogehogehoeg kiyaku ");
    PBAboutThisAppViewController* aboutCnt = [[PBAboutThisAppViewController alloc] init];
    
    
    UINavigationController* naviCnt = [[UINavigationController alloc] init];
    [naviCnt initWithRootViewController:aboutCnt];
    
    
    [self.navigationController presentViewController:naviCnt animated:YES completion:nil];
}

- (void)viewDidLoad
{
    
    NSLog(@"viewdid");
    
    
    welcome = [[UILabel alloc] initWithFrame:CGRectMake(15,70, self.view.frame.size.width - 15, 40)];
    welcome.text = @"まずはログインしてください。";
    welcome.font = [UIFont systemFontOfSize:16.0f];
    welcome.textAlignment = NSTextAlignmentCenter;
    welcome.textColor = [UIColor blackColor];
    [self.view addSubview:welcome];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIButton *adminBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    adminBtn.frame = CGRectMake((self.view.frame.size.width - 150)/2, 270, 150, 44);
    [adminBtn setTitle:@"つくる" forState:UIControlStateNormal];
    adminBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [adminBtn setTintColor:[UIColor whiteColor]];
    [adminBtn setBackgroundColor:[UIColor colorWithRed:1.0 green:0.078 blue:0.576 alpha:1.0]];
    adminBtn.layer.cornerRadius = 6;
    adminBtn.clipsToBounds = true;
    adminBtn.tag = 1;
    [adminBtn addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    [adminBtn addTarget:self action:@selector(changeGray:) forControlEvents:UIControlEventTouchDown];
    [adminBtn addTarget:self action:@selector(changeNormal:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];

    [self.view addSubview:adminBtn];
    
    UIButton *guestBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    guestBtn.frame = CGRectMake((self.view.frame.size.width - 150)/2, 330, 150, 44);
    [guestBtn setTitle:@"さんか" forState:UIControlStateNormal];
    guestBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [guestBtn setTintColor:[UIColor whiteColor]];
    [guestBtn setBackgroundColor:[UIColor colorWithRed:0.0 green:0.749 blue:1.0 alpha:1.0]];
    guestBtn.layer.cornerRadius = 6;
    guestBtn.clipsToBounds = true;
    guestBtn.tag = 2;
    [guestBtn addTarget:self action:@selector(changeGray:) forControlEvents:UIControlEventTouchDown];
    [guestBtn addTarget:self action:@selector(changeNormal:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [guestBtn addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:guestBtn];
    
    buttonLoginLogout = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonLoginLogout.frame = CGRectMake((self.view.frame.size.width - 80)/2, 120, 80, 38);
    [buttonLoginLogout setBackgroundColor:[UIColor colorWithRed:0 green:0.839 blue:0 alpha:1.0]];
    [buttonLoginLogout setTitle:@"ログイン" forState:UIControlStateNormal];
    buttonLoginLogout.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [buttonLoginLogout setTintColor:[UIColor whiteColor]];
    buttonLoginLogout.layer.cornerRadius = 12;
    buttonLoginLogout.clipsToBounds = true;
    buttonLoginLogout.tag = 3;
    [buttonLoginLogout addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:buttonLoginLogout];
    
    
    
    [self updateView];
    
    NSLog(@"updateView done");
    
    PBAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        NSLog(@"all delegate no open");
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        NSLog(@"session init");
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            NSLog(@"locked ? ");
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                [self updateView];
            }];
        }
    }
    
}

-(void)changeGray:(id)sender
{
    UIButton* targetBtn = sender;
    [targetBtn setBackgroundColor:[UIColor lightGrayColor]];
}

-(void)changeNormal:(id)sender
{
    UIButton* targetBtn = sender;
    if(targetBtn.tag == 1){
        [targetBtn setBackgroundColor:[UIColor colorWithRed:1.0 green:0.078 blue:0.576 alpha:1.0]];
    }
    else if(targetBtn.tag == 2){
        [targetBtn setBackgroundColor:[UIColor colorWithRed:0.0 green:0.749 blue:1.0 alpha:1.0]];
    }
}

-(void)tapButton:(id)sender
{
    UIButton* targetBtn = sender;
    
//    [self changeNormal:sender];
    
    if(targetBtn.tag == 1){
        
        PBAdminViewController* pbAdminCon = [[PBAdminViewController alloc] init];
        [pbAdminCon setTitle:@"管理者ページ"];
        [self.navigationController pushViewController:pbAdminCon animated:YES];
        
    }
    else if(targetBtn.tag == 2){
        PBGuestInputIDViewController* pbGInputCon = [[PBGuestInputIDViewController alloc] init];
        [pbGInputCon setTitle:@"ゲストページ"];
        [self.navigationController pushViewController:pbGInputCon animated:YES];
    }
    else if(targetBtn.tag == 3){
        PBAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];

        if (appDelegate.session.isOpen) {
            [appDelegate.session closeAndClearTokenInformation];
            
        } else {
            if (appDelegate.session.state != FBSessionStateCreated) {
                // Create a new, logged out session.
                appDelegate.session = [[FBSession alloc] init];
            }
            
            // if the session isn't open, let's open it now and present the login UX to the user
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // and here we make sure to update our UX according to the new session state
                [self updateView];
            }];
        }
    }
    
}

- (void)finishExecute
{
    NSLog(@"hgehogehogeohge");
}

- (void)updateView {
    // get the app delegate, so that we can reference the session property
     PBAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSLog(@"updateView");
    if (appDelegate.session.isOpen) {
        // valid account UI is shown whenever the session is open
        
        [buttonLoginLogout setTitle:@"ログアウト" forState:UIControlStateNormal];
        
        /*
        [textNoteOrLink setText:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",
                                      appDelegate.session.accessTokenData.accessToken]];
         */
        
        NSString* strUrl = [NSString stringWithFormat:@"https://graph.facebook.com/me/?fields=name,id&access_token=%@" , appDelegate.session.accessTokenData.accessToken];
        
        [self getFBProfileData:strUrl];
        
    } else {
        // login-needed account UI is shown whenever the session is closed
        [buttonLoginLogout setTitle:@"ログイン" forState:UIControlStateNormal];
        NSLog(@"no Log in");
        welcome.text = @"まずはログインしてください。";
    }
}

-(void)getFBProfileData:(NSString *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *json_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError *error=nil;
    
    id jsonObj = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingAllowFragments error:&error];
    
    NSLog(@"tototo = %@",jsonObj);
    
    NSDictionary* profile = jsonObj;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];

    NSString* fbid = [profile objectForKey:@"id"];
    NSString* fbname = [profile objectForKey:@"name"];
    NSString* token = [userDef objectForKey:@"DEVICE_TOKEN"];

    [userDef setObject:fbid forKey:@"FACEBOOK_ID"];
    [userDef setObject:fbname forKey:@"FACEBOOK_NAME"];
    
    [userDef synchronize];

    welcome.text = [[NSString alloc] initWithFormat:@"%@さん" , fbname];
    
    NSString* params = [[NSString alloc] initWithFormat:@"token=%@&fbName=%@&fbId=%@",token,fbid,fbname];
    
//    [PBURLConnection postUserInfo:params];
    [PBURLConnection registUserData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
