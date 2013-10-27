//
//  PBAdminBingoViewController.m
//  PushBingo
//
//  Created by Takumi Yamamoto on 2013/10/26.
//  Copyright (c) 2013年 Takumi Yamamoto. All rights reserved.
//

#import "PBAdminBingoViewController.h"
#import "PBURLConnection.h"
#import "PBIndicatorView.h"

@interface PBAdminBingoViewController ()

@end

@implementation PBAdminBingoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    
    [self registPlayBingoNumber];
    
    
    UIButton *guestBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    guestBtn.frame = CGRectMake(80, 250, 200, 30);
    [guestBtn setTitle:@"Finish BINGO" forState:UIControlStateNormal];
    guestBtn.tag = 1;
    [guestBtn addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:guestBtn];
    
}

-(void)tapButton:(id)sender
{
    UIButton* targetBtn = sender;
    if(targetBtn.tag == 1){
        [self finishBingo];
    }
}

-(void)finishBingo
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)registPlayBingoNumber
{
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:[PBURLConnection getPlayBingoNumber] forKey:@"ADMIN_PLAY_NUMBER"];
    
    NSLog(@"hogehoge tuitui %@",[PBURLConnection getPlayBingoNumber]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
