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
    
    indexNum = 0;
    
    [self registPlayBingoNumber];
    
    UIButton *pullBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pullBtn.frame = CGRectMake(60, 150, 200, 30);
    [pullBtn setTitle:@"番号を引く" forState:UIControlStateNormal];
    pullBtn.tag = 1;
    [pullBtn addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:pullBtn];
    
    UIButton *guestBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    guestBtn.frame = CGRectMake(60, 250, 200, 30);
    [guestBtn setTitle:@"Finish BINGO" forState:UIControlStateNormal];
    guestBtn.tag = 2;
    [guestBtn addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:guestBtn];
    
}

-(void)tapButton:(id)sender
{
    UIButton* targetBtn = sender;
    if(targetBtn.tag == 1){
        [self pullNumber];
    }
    else if(targetBtn.tag == 2){
        [self finishBingo];
    }
}

-(void)finishBingo
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(NSString *)pullNumber
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSArray* ary = [userDef objectForKey:@"ADMIN_PLAY_NUMBER"];
    
    NSLog(@"aiuro = %@",[ary objectAtIndex:indexNum]);
    
    [PBURLConnection pushNumber:[ary objectAtIndex:indexNum]];
    
    indexNum++;
    
    return [ary objectAtIndex:indexNum-1];
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
