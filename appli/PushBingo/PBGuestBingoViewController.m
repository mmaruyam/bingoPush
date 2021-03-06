//
//  PBGuestBingoViewController.m
//  PushBingo
//
//  Created by Takumi Yamamoto on 2013/10/16.
//  Copyright (c) 2013年 Takumi Yamamoto. All rights reserved.
//

#import "PBGuestBingoViewController.h"
#import "PBIndicatorView.h"
#import "PBURLConnection.h"

@interface PBGuestBingoViewController ()

@end

@implementation PBGuestBingoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (id)initWithBingoId:(NSString *)bingoId
{
    self = [super init];
    if(self){
        maryBingoMasu = [NSMutableArray array];
        iBingo = 0;
        iReach = 0;
        strBingoId = bingoId;
    }
    
    NSLog(@"参加しているIDは　%@",strBingoId);
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    //ios7以上のときはナビゲーションバーの裏にビューが入り込まないようにする
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    dicMasuData = [[NSDictionary alloc] init];
    
    UIImageView* bingoFrame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_bingo"]];
    bingoFrame.frame = CGRectMake(0 , 0, bingoFrame.frame.size.width,bingoFrame.frame.size.height);
    [self.view addSubview:bingoFrame];
    
    UIView* bingoCard = [self makeBingoCard];
    [bingoFrame addSubview:bingoCard];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(30,400,220,40)];
    label.text = @"ビンゴ　0 : リーチ  1";
    label.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:label];
    
    
    
    pbIndicator = [[PBIndicatorView alloc] init];
    [self.view addSubview:pbIndicator];
    
    
}

- (void)connection:(NSURLConnection *)i_connection didReceiveData:(NSData *)data
{
    NSLog(@"ひいた番号のデータを受信しました");
    NSError* error;
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"ひいた番号は , %@",json);
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:json forKey:PULL_NUMBER];
    
    [pbIndicator stopIndicator];
    
    timerBingoChecker =
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(checkPullNumber:) userInfo:nil repeats:YES
     ];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [pbIndicator startIndicator];
    
    PBURLConnection* pbUrlCon = [[PBURLConnection alloc] init];
    pbUrlCon.delegate = self;
    NSString* url = [[NSString alloc] initWithFormat:@"http://www1066uj.sakura.ne.jp/bingo/api/entry/getPushedNumbers.php?tableid=%@",strBingoId];
    [pbUrlCon addUrl:url];
    [pbUrlCon execute];
}

//引いた番号をチェックします
-(void)checkPullNumber:(NSTimer *)timer
{
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    aryPullNumber = [userDef objectForKey:PULL_NUMBER];
    
    NSLog(@"ひいた番号（timer) %@",aryPullNumber);
    
    //debug
    //aryPullNumber = @[@"8" , @"25" , @"34" , @"58" , @"64"];
    
    
    for(NSString* pull in aryPullNumber){
        NSInteger index = 0;
        NSInteger j = 0;
        NSString* strPullNum = [[NSString alloc] initWithFormat:@"%@",pull];
        
        for(int i = 0; i<5;i++){
            NSString* strIndex = [[NSString alloc] initWithFormat:@"%d",j];
            for(NSString* data in [dicMasuData objectForKey:strIndex]){
                NSString* strMasuData = [[NSString alloc] initWithFormat:@"%@",data];
                
                
                if([strMasuData isEqualToString:strPullNum]){
                    
                    UIButton* targetBtn = [maryBingoMasu objectAtIndex:index];
                    targetBtn.titleLabel.textColor = [UIColor whiteColor];
                    targetBtn.enabled = NO;
                }
                index++;
            }
            j++;
        }
        
    }
    
    [self checkBingoStatus];
    
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

-(void)viewWillDisappear:(BOOL)animated
{
    [timerBingoChecker invalidate];
}

- (void)checkBingoStatus
{
    int iPrevReach = iReach;
    iReach = 0;
    iBingo = 0;

    [self checkVerticalLine];
    [self checkHorizonalLine];
    [self checkDiagonalLine];
    
    NSLog(@"bingo = %d, reach = %d",iBingo,iReach);
    
    if(0< iBingo){
        [PBURLConnection updateUserStatus:@"bingo" bingoID:strBingoId];
        UIAlertView *pushAlert = [[UIAlertView alloc] initWithTitle:@"info" message:@"ビンゴ！"
                                                           delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil];
        pushAlert.tag = 1;
        [pushAlert show];
        [timerBingoChecker invalidate];
    }
    else if(0<iReach && iReach != iPrevReach){
        [PBURLConnection updateUserStatus:@"reach" bingoID:strBingoId];
        UIAlertView *pushAlert = [[UIAlertView alloc] initWithTitle:@"info" message:@"リーチ"
                                                           delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil];
        pushAlert.tag = 2;
        [pushAlert show];
    }
    
    NSString* str = [[NSString alloc] initWithFormat:@"ビンゴ　%d : リーチ %d" , iBingo , iReach];
    label.text = str;
}

-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (alertView.tag) {
        case 1:
            //１番目のボタンが押されたときの処理を記述する
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        case 2:
            //２番目のボタンが押されたときの処理を記述する
            break;
    }
    
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
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if(self.isLoad){
        dicMasuData = [userDef objectForKey:BINGO_CARD_DATA];
    }
    if(dicMasuData && self.isLoad){
        NSLog(@"ビンゴカードのデータがありました");
    }
    else{
        NSLog(@"ビンゴカードのデータがありませんでした");
        dicMasuData = [self getBingoMasuData];
        [userDef setObject:dicMasuData forKey:BINGO_CARD_DATA];
    }
    
    
    
    UIImage* imageMasu = [UIImage imageNamed:@"1"];
    
    UIView* baseView = [[UIView alloc] initWithFrame:CGRectMake(0,55,self.view.frame.size.width,self.view.frame.size.height)];
    baseView.backgroundColor = [UIColor clearColor];
    
    for(int i = 0; i < 5; i++){
        for(int j = 0; j< 5; j++){
            
            UIButton* tmpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            if(i == 2 && j == 2){
//                [tmpBtn setBackgroundImage:[UIImage imageNamed:@"free"] forState:UIControlStateDisabled];
//                tmpBtn.frame = CGRectMake(i*(imageMasu.size.width), j*(imageMasu.size.height), imageMasu.size.width, imageMasu.size.height);
//                tmpBtn.enabled = NO;
//                tmpBtn.tag = (j+1)+(5*i);
            }
            else{
                NSString* strI = [[NSString alloc] initWithFormat:@"%d",i];
                NSString* masuData = [[NSString alloc] initWithFormat:@"%@" , [[dicMasuData objectForKey:strI] objectAtIndex:j]];
                UIImage* imageMasu = [UIImage imageNamed:@"bg_num_off"];
//                NSString* hoge = [[NSString alloc] initWithFormat:@"%@",masuData];
                
                
                [tmpBtn setTitle:masuData forState:UIControlStateNormal];
                [tmpBtn setBackgroundImage:[UIImage imageNamed:@"bg_num_off"] forState:UIControlStateNormal];
                [tmpBtn setBackgroundImage:[self judgeNumberBgImage:i] forState:UIControlStateDisabled];
                [tmpBtn setFrame:CGRectMake(i*(imageMasu.size.width) + 5.0f*i, j*(imageMasu.size.height) + 5.0f*j, imageMasu.size.width, imageMasu.size.height)];
                tmpBtn.titleLabel.font = [UIFont systemFontOfSize:28.0f];
                tmpBtn.titleLabel.textColor = [UIColor redColor];
                tmpBtn.enabled = YES;
                tmpBtn.tag = (j+1)+(5*i);
                [tmpBtn addTarget:self action:@selector(tapBingoMasu:)forControlEvents:UIControlEventTouchDown];
//                tmpBtn.enabled = NO;
                
            }
            [maryBingoMasu addObject:tmpBtn];
            [baseView addSubview:tmpBtn];
        }
    }
    
    
    return baseView;
}

-(UIImage *)judgeNumberBgImage:(NSInteger)num
{
    UIImage* image;
    switch (num) {
        case 0:
            image = [UIImage imageNamed:@"bg_num01_on"];
            break;
        case 1:
            image = [UIImage imageNamed:@"bg_num02_on"];
            break;
        case 2:
            image = [UIImage imageNamed:@"bg_num03_on"];
            break;
        case 3:
            image = [UIImage imageNamed:@"bg_num04_on"];
            break;
        case 4:
            image = [UIImage imageNamed:@"bg_num05_on"];
            break;
        default:
            break;
    }
    
    return image;
}

-(void)tapBingoMasu:(id)sender
{
    /*
    NSLog(@"hogehogehoge");
    
    UIButton* targetBtn = sender;
    targetBtn.enabled = NO;
    
    
    NSString* strI = [[NSString alloc] initWithFormat:@"%d",(NSInteger)(targetBtn.tag -1 )/5];
    NSString* hogew = [[dicMasuData objectForKey:strI] objectAtIndex:(NSInteger)(targetBtn.tag-1)%5];
    NSString* hoge = [[NSString alloc] initWithFormat:@"%@_off",hogew];
    NSLog(@"aiuaiu = %@",hoge);
    [targetBtn setImage:[UIImage imageNamed:hoge] forState:UIControlStateDisabled];
    
    [self checkBingoStatus];
     */
    
    /*
    UIButton* button = [maryBingoMasu objectAtIndex:10];
    button.enabled = NO;
     */
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
