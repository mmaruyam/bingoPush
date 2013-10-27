
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
    makeIdBtn.frame = CGRectMake(80, 80, 100, 50);
    [makeIdBtn setTitle:@"つくる" forState:UIControlStateNormal];
    [makeIdBtn setBackgroundColor:[UIColor lightGrayColor]];
    makeIdBtn.tag = 1;
    [makeIdBtn addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:makeIdBtn];
    
    labelID = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, 100, 40)];
    labelID.text = @"hoge";
    [self.view addSubview:labelID];
    
    startBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startBtn.frame = CGRectMake(80, 260, 100, 50);
    [startBtn setTitle:@"Start BINGO" forState:UIControlStateNormal];
    [startBtn setBackgroundColor:[UIColor lightGrayColor]];
    startBtn.tag = 2;
    startBtn.enabled = NO;
    [startBtn addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:startBtn];
    
    
    hoge = [[PBIndicatorView alloc] init];
    [self.view addSubview:hoge];
     
    
    
    
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
    labelID.text = @"1092";
    startBtn.enabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
