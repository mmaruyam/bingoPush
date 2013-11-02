
//
//  PBAdminViewController.m
//  PushBingo
//
//  Created by Takumi Yamamoto on 2013/10/16.
//  Copyright (c) 2013年 Takumi Yamamoto. All rights reserved.
//

#import "PBAdminViewController.h"
#import "PBAdminBingoViewController.h"
#import "PBIndicatorView.h"
#import "PBURLConnection.h"


@interface PBAdminViewController ()

@end

@implementation PBAdminViewController

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
    
    UIButton *makeIdBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    makeIdBtn.frame = CGRectMake((self.view.frame.size.width - 150)/2, 100, 150, 44);
    [makeIdBtn setTitle:@"つくる" forState:UIControlStateNormal];
    makeIdBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [makeIdBtn setTintColor:[UIColor whiteColor]];
    [makeIdBtn setBackgroundColor:[UIColor colorWithRed:1.0 green:0.078 blue:0.576 alpha:1.0]];
    makeIdBtn.layer.cornerRadius = 6;
    makeIdBtn.clipsToBounds = true;
    makeIdBtn.tag = 1;
    [makeIdBtn addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchDown];
    [makeIdBtn addTarget:self action:@selector(changeGray:) forControlEvents:UIControlEventTouchDown];
    [makeIdBtn addTarget:self action:@selector(changeNormal:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self.view addSubview:makeIdBtn];
    
    labelID = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, 100, 40)];
    labelID.text = @"";
    [self.view addSubview:labelID];
    
    startBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startBtn.frame = CGRectMake((self.view.frame.size.width - 150)/2, 260, 150, 44);
    [startBtn setTitle:@"Start BINGO" forState:UIControlStateNormal];
    [startBtn setBackgroundColor:[UIColor lightGrayColor]];
    startBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [startBtn setTintColor:[UIColor whiteColor]];
    startBtn.layer.cornerRadius = 6;
    startBtn.clipsToBounds = true;
    startBtn.tag = 2;
    startBtn.enabled = NO;
    [startBtn addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:startBtn];
    
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

- (void)tapButton:(id)sender
{
    UIButton* targetBtn = sender;
    if(targetBtn.tag == 1){
        [indicator startAnimating];
        [self makeBingoGamgeId];
    }
    else if(targetBtn.tag == 2){
        
        PBAdminBingoViewController* adminBingoCnt = [[PBAdminBingoViewController alloc] init];
        [self.navigationController pushViewController:adminBingoCnt animated:YES];
        
    }
    
}


- (void)makeBingoGamgeId
{
    NSString* bingoID = [PBURLConnection createBingoTable];
    labelID.text = [[NSString alloc] initWithFormat:@"%@",bingoID];
    startBtn.enabled = YES;
    [startBtn setBackgroundColor:[UIColor colorWithRed:1.0 green:0.078 blue:0.576 alpha:1.0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
