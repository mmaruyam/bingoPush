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
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    
    NSLog(@"viewdid");
    
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIButton *adminBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    adminBtn.frame = CGRectMake(80, 80, 100, 30);
    [adminBtn setTitle:@"Admin" forState:UIControlStateNormal];
    adminBtn.tag = 1;
    [adminBtn addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:adminBtn];
    
    UIButton *guestBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    guestBtn.frame = CGRectMake(80, 120, 100, 30);
    [guestBtn setTitle:@"Guest" forState:UIControlStateNormal];
    guestBtn.tag = 2;
    [guestBtn addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:guestBtn];
    
    buttonLoginLogout = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonLoginLogout.frame = CGRectMake(80, 180, 100, 30);
    [buttonLoginLogout setTitle:@"Guest" forState:UIControlStateNormal];
    buttonLoginLogout.tag = 3;
    [buttonLoginLogout addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:buttonLoginLogout];
    
    textNoteOrLink = [[UITextView alloc] initWithFrame:CGRectMake(20,230, 300, 200)];
    textNoteOrLink.editable =  NO;
    textNoteOrLink.text = @"あいうえお\nかきくけこ";
    [self.view addSubview:textNoteOrLink];
    
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

-(void)tapButton:(id)sender
{
    UIButton* targetBtn = sender;
    
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

- (void)updateView {
    // get the app delegate, so that we can reference the session property
     PBAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSLog(@"updateView");
    if (appDelegate.session.isOpen) {
        // valid account UI is shown whenever the session is open
        [buttonLoginLogout setTitle:@"Log out" forState:UIControlStateNormal];
        
        /*
        [textNoteOrLink setText:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",
                                      appDelegate.session.accessTokenData.accessToken]];
         */
        
        NSString* strUrl = [NSString stringWithFormat:@"https://graph.facebook.com/me/?fields=name,id&access_token=%@" , appDelegate.session.accessTokenData.accessToken];
        [textNoteOrLink setText:strUrl];
        [self getFBProfileData:strUrl];
        
    } else {
        // login-needed account UI is shown whenever the session is closed
        [buttonLoginLogout setTitle:@"Log in" forState:UIControlStateNormal];
        [textNoteOrLink setText:@"Login to create a link to fetch account data"];
        NSLog(@"no Log in");
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

    
    NSString* params = [[NSString alloc] initWithFormat:@"token=%@&fbName=%@&fbId=%@",token,fbid,fbname];
    
    [PBURLConnection postUserInfo:params];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
