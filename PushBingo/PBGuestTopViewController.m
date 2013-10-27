//
//  PBGuestTopViewController.m
//  PushBingo
//
//  Created by Takumi Yamamoto on 2013/10/16.
//  Copyright (c) 2013年 Takumi Yamamoto. All rights reserved.
//

#import "PBGuestTopViewController.h"

@interface PBGuestTopViewController ()

@end

@implementation PBGuestTopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        maryBingoMasu = [NSMutableArray array];
        iBingo = 0;
        iReach = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    UIView* bingoCard = [self makeBingoCard];
    [self.view addSubview:bingoCard];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(30,360,220,40)];
    label.text = @"ビンゴ　0 : リーチ  1";
    label.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
    
}

-(NSDictionary *)getBingoMasuData
{
    NSString *url = @"http://www1066uj.sakura.ne.jp/bingo/api/entry/makeCard.php";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *json_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError *error=nil;
    
    id jsonObj = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingAllowFragments error:&error];
    
    return  jsonObj;
}

- (void)checkBingoStatus
{
    iBingo = 0;
    iReach = 0;
    [self checkVerticalLine];
    [self checkHorizonalLine];
    [self checkDiagonalLine];
    
    NSLog(@"bingo = %d, reach = %d",iBingo,iReach);
    
    NSString* str = [[NSString alloc] initWithFormat:@"ビンゴ　%d : リーチ %d" , iBingo , iReach];
    label.text = str;
}

-(void)checkVerticalLine
{
    for(int i = 0;i<5;i++){
        NSInteger num = 0;
        for(int j = 0; j<5;j++){
            UIButton* btn = [maryBingoMasu objectAtIndex:(i)+(5*j)];
            if(!btn.enabled) num++;
        }
        
        if(num == 5){
            iBingo++;
        }
        else if(num == 4){
            iReach++;
        }
    }
}

-(void)checkHorizonalLine
{
    for(int i = 0; i <5;i++){
        NSInteger num = 0;
        for(int j = 0; j < 5; j++){
            UIButton* btn = [maryBingoMasu objectAtIndex:j+(i*5)];
            if(!btn.enabled) num++;
        }

        if(num == 5){
            iBingo++;
        }
        else if(num == 4){
            iReach++;
        }
    }
}

-(void)checkDiagonalLine
{
    NSInteger num =0;
    for(int i = 0;i<5;i++){
        UIButton* btn = [maryBingoMasu objectAtIndex:i*6];
        if(!btn.enabled) num++;
    }
    
    if(num == 5){
        iBingo++;
    }
    else if(num == 4){
        iReach++;
    }
    
    num = 0;
    
    for(int i = 0;i<5;i++){
        UIButton* btn = [maryBingoMasu objectAtIndex:(i+1)*4];
        if(!btn.enabled) num++;
    }
    
    if(num == 5){
        iBingo++;
    }
    else if(num == 4){
        iReach++;
    }
    
}

- (id)makeBingoCard
{
    NSDictionary* dicMasuData = [self getBingoMasuData];
    
    UIView* baseView = [[UIView alloc] initWithFrame:CGRectMake(20,100,44*5,44*5)];
    baseView.backgroundColor = [UIColor lightGrayColor];
    
    for(int i = 0; i < 5; i++){
        for(int j = 0; j< 5; j++){
            UIButton* tmpBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            tmpBtn.frame = CGRectMake(i*44, j*44, 44, 44);
            NSString* strI = [[NSString alloc] initWithFormat:@"%d",i];
            NSString* masuData =[[dicMasuData objectForKey:strI] objectAtIndex:j];
            NSString* strMasu = [[NSString alloc] initWithFormat:@"%@",masuData];
            [tmpBtn setTitle:strMasu forState:UIControlStateNormal];
            [tmpBtn setTitle:@"×" forState:UIControlStateDisabled];
            tmpBtn.tag = (j+1)+(5*i);
            [tmpBtn addTarget:self action:@selector(tapBingoMasu:)forControlEvents:UIControlEventTouchDown];
            [maryBingoMasu addObject:tmpBtn];
            [baseView addSubview:tmpBtn];
            
        }
    }
    
    
    return baseView;
}

-(void)tapBingoMasu:(id)sender
{
    UIButton* targetBtn = sender;
    targetBtn.enabled = NO;
    [self checkBingoStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
