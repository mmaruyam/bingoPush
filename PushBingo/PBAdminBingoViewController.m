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
    
    pbIndicator = [[PBIndicatorView alloc] init];
    [self.view addSubview:pbIndicator];
    
    
    UIButton *pullBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pullBtn.frame = CGRectMake((self.view.frame.size.width - 150)/2, 150, 150, 44);
    [pullBtn setTitle:@"番号を引く" forState:UIControlStateNormal];
    pullBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [pullBtn setTintColor:[UIColor whiteColor]];
    [pullBtn setBackgroundColor:[UIColor colorWithRed:1.0 green:0.078 blue:0.576 alpha:1.0]];
    pullBtn.layer.cornerRadius = 6;
    pullBtn.clipsToBounds = true;
    pullBtn.tag = 1;
    [pullBtn addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    [pullBtn addTarget:self action:@selector(changeGray:) forControlEvents:UIControlEventTouchDown];
    [pullBtn addTarget:self action:@selector(changeNormal:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self.view addSubview:pullBtn];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    UILabel* statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,250,300,50)];
//    NSDictionary* dicStatus = [PBURLConnection getUserStatusFromTableID:[userDef objectForKey:@"BINGO_GAME_ID"]];
    NSDictionary* dicStatus = nil;
    NSString* status = [[NSString alloc] initWithFormat:@"bingo %@",[dicStatus objectForKey:@"bingo"]];
    statusLabel.text = status;
    [self.view addSubview:statusLabel];
    
    UIButton *guestBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    guestBtn.frame = CGRectMake((self.view.frame.size.width - 150)/2, 350, 150, 30);
    [guestBtn setTitle:@"Finish BINGO" forState:UIControlStateNormal];
    guestBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [guestBtn setTintColor:[UIColor whiteColor]];
    [guestBtn setBackgroundColor:[UIColor colorWithRed:1.0 green:0.078 blue:0.576 alpha:1.0]];
    guestBtn.layer.cornerRadius = 6;
    guestBtn.clipsToBounds = true;
    guestBtn.tag = 2;
    [guestBtn addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    [guestBtn addTarget:self action:@selector(changeGray:) forControlEvents:UIControlEventTouchDown];
    [guestBtn addTarget:self action:@selector(changeNormal:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self.view addSubview:guestBtn];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self registPlayBingoNumber];
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
    
    
    NSString* strIndex = [[NSString alloc] initWithFormat:@"%d",indexNum];
    [PBURLConnection pushNumber:[ary objectAtIndex:indexNum]];
    [PBURLConnection registPushNumberIndex:strIndex];
    
    
    indexNum++;
    
    return [ary objectAtIndex:indexNum-1];
}


-(void)registPlayBingoNumber
{
    [pbIndicator startIndicator];
    
    PBURLConnection* pbUrlCon = [[PBURLConnection alloc] init];
    pbUrlCon.delegate = self;
    NSString *url = @"http://www1066uj.sakura.ne.jp/bingo/api/entry/getPingoNumber.php";
    [pbUrlCon addUrl:url];
    [pbUrlCon execute];

}

- (void)connection:(NSURLConnection *)i_connection didReceiveData:(NSData *)data
{
    [pbIndicator stopIndicator];
    
    NSLog(@"received data");
    NSLog(@"data = %@",data);
    
    NSError* error;
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:json forKey:@"ADMIN_PLAY_NUMBER"];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
