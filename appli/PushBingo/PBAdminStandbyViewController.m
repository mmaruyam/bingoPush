//
//  PBAdminStandbyViewController.m
//  PushBingo
//
//  Created by 丸山 三喜也 on 11/3/13.
//  Copyright (c) 2013 Takumi Yamamoto. All rights reserved.
//

#import "PBAdminStandbyViewController.h"
#import "PBAdminBingoViewController.h"
#import "PBIndicatorView.h"
#import "PBURLConnection.h"

@interface PBAdminStandbyViewController()
{
    NSString *_strBingoID;
}
@end

@implementation PBAdminStandbyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithBingoID:(NSString *) bingoID
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        _strBingoID = [[NSString alloc] init];
        _strBingoID = bingoID;
//        NSLog(@"%@", _strBingoID);
    }
    return self;
}

- (void)viewDidLoad
{
    // 発行されたID 表示
    float lbWidth = 300.0f;
    float lbHeight = 50.0f;
    UILabel *lbBingpId = [[UILabel alloc] init];
    lbBingpId.frame = CGRectMake((self.view.frame.size.width - lbWidth) / 2.0f, 100.0f, lbWidth, lbHeight);
    lbBingpId.text = [NSString stringWithFormat:@"%@", _strBingoID];
    lbBingpId.font = [UIFont boldSystemFontOfSize:40.0f];
    lbBingpId.textColor = [UIColor blackColor];
    lbBingpId.textAlignment = UITextAlignmentCenter;
    lbBingpId.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lbBingpId];
    
    // start button 設置
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startBtn.frame = CGRectMake((self.view.frame.size.width - 150)/2, 260, 150, 44);
    [startBtn setTitle:@"Start BINGO" forState:UIControlStateNormal];
    [startBtn setBackgroundColor:[UIColor colorWithRed:0.0 green:0.749 blue:1.0 alpha:1.0]];
    startBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [startBtn setTintColor:[UIColor whiteColor]];
    startBtn.layer.cornerRadius = 6;
    startBtn.clipsToBounds = true;
    startBtn.tag = 2;
    [startBtn addTarget:self action:@selector(startBingoGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
}

- (void) startBingoGame
{
    // update status from wait to start
    NSString *status = @"start";
    NSString *url = [[NSString alloc]initWithFormat:@"http://www1066uj.sakura.ne.jp/bingo/api/entry/updateTableStatus.php?tableid=%@&status=%@", _strBingoID, status];
    NSLog(@"updateTableStatus url: %@",url);
    PBURLConnection* pbUrlCon = [[PBURLConnection alloc] init];
    [pbUrlCon addUrl:url];
    [pbUrlCon execute];
    
    // start bingo game
    PBAdminBingoViewController *adminBingoCnt = [[PBAdminBingoViewController alloc] init];
    [self.navigationController pushViewController:adminBingoCnt animated:YES];
}

@end
