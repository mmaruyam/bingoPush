//
//  PBGuestBingoViewController.m
//  PushBingo
//
//  Created by Takumi Yamamoto on 2013/10/16.
//  Copyright (c) 2013年 Takumi Yamamoto. All rights reserved.
//

#import "PBGuestBingoViewController.h"
#import "PBURLConnection.h"

@interface PBGuestBingoViewController ()

@end

@implementation PBGuestBingoViewController

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

    dicMasuData = [[NSDictionary alloc] init];

    UIImageView *bView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"b"]];
    UIImageView *iView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"i"]];
    UIImageView *nView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"n"]];
    UIImageView *gView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"g"]];
    UIImageView *oView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"o"]];
    
    CGSize bingoSize = [UIImage imageNamed:@"b"].size;
    CGFloat offSetX = 10.0f;
    CGFloat offSetY = 70.0f;
    
    bView.frame = CGRectMake(offSetX,offSetY,bingoSize.width,bingoSize.height);
    offSetX += bingoSize.width;
    iView.frame = CGRectMake(offSetX,offSetY,bingoSize.width,bingoSize.height);
    offSetX += bingoSize.width;
    nView.frame = CGRectMake(offSetX,offSetY,bingoSize.width,bingoSize.height);
    offSetX += bingoSize.width;
    gView.frame = CGRectMake(offSetX,offSetY,bingoSize.width,bingoSize.height);
    offSetX += bingoSize.width;
    oView.frame = CGRectMake(offSetX,offSetY,bingoSize.width,bingoSize.height);
    
    [self.view addSubview:bView];
    [self.view addSubview:iView];
    [self.view addSubview:nView];
    [self.view addSubview:gView];
    [self.view addSubview:oView];
    
    offSetX = 10.0f;
    offSetY += bingoSize.height;
    
    UIImageView* bingoFrame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame"]];
    bingoFrame.frame = CGRectMake(0 , offSetY -10.0f, bingoFrame.frame.size.width,bingoFrame.frame.size.height);
    
    
    UIView* bingoCard = [self makeBingoCard];
    bingoCard.frame = CGRectMake(offSetX,offSetY,bingoCard.frame.size.width,bingoCard.frame.size.height);
    [self.view addSubview:bingoCard];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(30,400,220,40)];
    label.text = @"ビンゴ　0 : リーチ  1";
    label.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:label];
    
    [self.view addSubview:bingoFrame];
    
    NSTimer *tm =
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(checkPullNumber:) userInfo:nil repeats:YES
     ];
    
}

-(void)checkPullNumber:(NSTimer *)timer
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSArray* aryPullNumber = [userDef objectForKey:@"PULL_NUMBER"];
    
    
    for(NSString* pull in aryPullNumber){
        NSInteger index = 0;
        for(NSString* strindex in dicMasuData){
            for(NSString* data in [dicMasuData objectForKey:strindex]){
                NSString* hoge = [[NSString alloc] initWithFormat:@"%@",data];
                NSString* fuga = [[NSString alloc] initWithFormat:@"%@",pull];
                if([hoge isEqualToString:fuga]){
                    UIButton* hogeBtn = [maryBingoMasu objectAtIndex:index];
                    hogeBtn.enabled = NO;
                }
                index++;
            }
            
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

- (void)checkBingoStatus
{
    iBingo = 0;
    iReach = 0;
    [self checkVerticalLine];
    [self checkHorizonalLine];
    [self checkDiagonalLine];
    
    NSLog(@"bingo = %d, reach = %d",iBingo,iReach);
    
    if(0< iBingo){
        [PBURLConnection updateUserStatus:@"bingo"];
    }
    else if(0<iReach){
        [PBURLConnection updateUserStatus:@"reach"];
    }
    
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
    dicMasuData = [self getBingoMasuData];
    
    UIImage* imageMasu = [UIImage imageNamed:@"1"];
    
    UIView* baseView = [[UIView alloc] initWithFrame:CGRectMake(0,0,imageMasu.size.width*5,imageMasu.size.height*5)];
    baseView.backgroundColor = [UIColor lightGrayColor];
    
    for(int i = 0; i < 5; i++){
        for(int j = 0; j< 5; j++){
            
            UIButton* tmpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            if(i == 2 && j == 2){
                [tmpBtn setBackgroundImage:[UIImage imageNamed:@"free"] forState:UIControlStateDisabled];
                tmpBtn.frame = CGRectMake(i*(imageMasu.size.width), j*(imageMasu.size.height), imageMasu.size.width, imageMasu.size.height);
                tmpBtn.enabled = NO;
                tmpBtn.tag = (j+1)+(5*i);
            }
            else{
                NSString* strI = [[NSString alloc] initWithFormat:@"%d",i];
                NSString* masuData = [[dicMasuData objectForKey:strI] objectAtIndex:j];
                UIImage* imageMasu = [UIImage imageNamed:@"1"];
                NSString* hoge = [[NSString alloc] initWithFormat:@"%@",masuData];
                
                [tmpBtn setImage:[UIImage imageNamed:hoge] forState:UIControlStateNormal];
                tmpBtn.frame = CGRectMake(i*(imageMasu.size.width), j*(imageMasu.size.height), imageMasu.size.width, imageMasu.size.height);
                tmpBtn.enabled = YES;
                tmpBtn.tag = (j+1)+(5*i);
                [tmpBtn addTarget:self action:@selector(tapBingoMasu:)forControlEvents:UIControlEventTouchDown];
                
                
            }
            [maryBingoMasu addObject:tmpBtn];
            [baseView addSubview:tmpBtn];
        }
    }
    
    
    return baseView;
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
    
    UIButton* button = [maryBingoMasu objectAtIndex:10];
    button.enabled = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
