//
//  PBGuestInputIDViewController.m
//  PushBingo
//
//  Created by Takumi Yamamoto on 2013/10/24.
//  Copyright (c) 2013年 Takumi Yamamoto. All rights reserved.
//

#import "PBGuestInputIDViewController.h"
#import "PBGuestBingoViewController.h"
#import "PBURLConnection.h"

@interface PBGuestInputIDViewController ()

@end

@implementation PBGuestInputIDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bingoId = [[NSString alloc] init];
    }
    return self;
}

-(id)initWithUserId:(NSString *)userid
{
    self = [super init];
    if(self){
        userId = userid;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self test];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    aryJoinGameId = [[userDef objectForKey:JOIN_BINGO_GAME_ID] mutableCopy];
    
    
    BOOL isJoinedGame = NO;

    if(aryJoinGameId){
        NSLog(@"参加しているビンゴゲームIDは、%@",aryJoinGameId);
        isJoinedGame = YES;
        for(NSInteger i = 0; i < [aryJoinGameId count];i++){
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20+(i*40),80,40,40)];
            label.text = [aryJoinGameId objectAtIndex:i];
            [self.view addSubview:label];
        }
        bingoId = [aryJoinGameId objectAtIndex:[aryJoinGameId count] - 1];
        
        //とりあえずは最新のIDのみを指定できるようにしておく
        [aryJoinGameId addObject:[aryJoinGameId objectAtIndex:[aryJoinGameId count] -1]];
    }
    else{
        NSLog(@"参加しているビンゴゲームはありません");
    }
    
    tf = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250)/2, 160, 250, 30)];
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.textColor = [UIColor blueColor];
    tf.placeholder = @"ビンゴIDを入力してください";
    tf.clearButtonMode = UITextFieldViewModeAlways;
    tf.returnKeyType = UIReturnKeyGo;
    tf.delegate = self;
    // 編集終了後フォーカスが外れた時にhogeメソッドを呼び出す
//    [tf addTarget:self action:@selector(hoge:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:tf];
    
    UIButton *joinBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    joinBtn.frame = CGRectMake((self.view.frame.size.width - 100)/2, 210, 100, 40);
    [joinBtn setTitle:@"参加" forState:UIControlStateNormal];
    [joinBtn addTarget:self action:@selector(changeGray:) forControlEvents:UIControlEventTouchDown];
    [joinBtn addTarget:self action:@selector(changeNormal:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    joinBtn.tag = 1;
    joinBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [joinBtn setTintColor:[UIColor whiteColor]];
    [joinBtn setBackgroundColor:[UIColor colorWithRed:1.0 green:0.078 blue:0.576 alpha:1.0]];
    joinBtn.layer.cornerRadius = 6;
    joinBtn.clipsToBounds = true;
    [joinBtn addTarget:self action:@selector(tapDoneButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:joinBtn];
    
    if(isJoinedGame){
        UIButton *loadBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        loadBtn.frame = CGRectMake((self.view.frame.size.width - 100)/2, 280, 100, 40);
        [loadBtn setTitle:@"ロード" forState:UIControlStateNormal];
        [loadBtn addTarget:self action:@selector(changeGray:) forControlEvents:UIControlEventTouchDown];
        [loadBtn addTarget:self action:@selector(changeNormal:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        loadBtn.tag = 2;
        loadBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        [loadBtn setTintColor:[UIColor whiteColor]];
        [loadBtn setBackgroundColor:[UIColor colorWithRed:1.0 green:0.078 blue:0.576 alpha:1.0]];
        loadBtn.layer.cornerRadius = 6;
        loadBtn.clipsToBounds = true;
        [loadBtn addTarget:self action:@selector(tapLoadButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loadBtn];
    }

    
}

-(void)test
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString* fId   = [userDef objectForKey:@"FACEBOOK_ID"];
    NSString* fname = [userDef objectForKey:@"FACEBOOK_NAME"];
    
    NSLog(@"fId = %@ , fname = %@",fId,fname);
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)tapDoneButton:(id)sender
{
    NSLog(@"aiuaiua %@",tf.text);
    
    if([tf.text isEqualToString:@""]){
        UIAlertView *pushAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"IDを入力してください。"
                                                           delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil];
        [pushAlert show];
    }
    else{
        bingoId = tf.text;
        BOOL isExsit = NO;
        
        for(NSString* str in aryJoinGameId){
            if([str isEqualToString:bingoId]){
                isExsit = YES;
            }
        }
    
        if(![self checkBingoGameStatus]){
            [self errorJoined];
        }
        else{
            if(isExsit){
                UIAlertView *pushAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"参加済みです"
                                                                   delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil];
                [pushAlert show];
            }
            
            
            else{
                BOOL bJoin = [PBURLConnection joinPingo:tf.text];
                if(bJoin){
                    //参加しているビンゴID一覧に入力したIDを保存
                    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
                    NSMutableArray* maryTmp = [NSMutableArray array];
                    if(aryJoinGameId){
                        maryTmp = [aryJoinGameId mutableCopy];
                    }
                    
                    [maryTmp addObject:tf.text];
                    [userDef setObject:maryTmp forKey:JOIN_BINGO_GAME_ID];
                    NSLog(@"保存しました %@",maryTmp);
                    
                    PBGuestBingoViewController* pbGtopCon = [[PBGuestBingoViewController alloc] initWithBingoId:bingoId];
                    [pbGtopCon setTitle:@"ビンゴページ"];
                    [self.navigationController pushViewController:pbGtopCon animated:YES];
                }
                else{
                    UIAlertView *pushAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"そのIDのビンゴゲームはありません。"
                                                                       delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil];
                    [pushAlert show];
                }
            }
        }
    }
    
}

- (BOOL)checkBingoGameStatus
{
    return [PBURLConnection getBingoStatus:bingoId];
    
}

- (void) errorJoined
{
    UIAlertView *pushAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"ビンゴが始まっているため、参加できません"
                                                       delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil];
    [pushAlert show];
   
}

-(BOOL)checkJoinBingo
{
    return [PBURLConnection isJoinBingoFromUserid:userId tableId:bingoId];
    
}

-(void)tapLoadButton:(id)sender
{
    NSLog(@"bingoID は　%@",bingoId);
    
    BOOL bingoWaitStatus = [self checkBingoGameStatus];
    BOOL bingoJoin = [self checkJoinBingo];
    
    if(!bingoWaitStatus && !bingoJoin)
    {
        [self errorJoined];
    }
    else{
        
        
        PBGuestBingoViewController* pbGtopCon = [[PBGuestBingoViewController alloc] initWithBingoId:bingoId];
        [pbGtopCon setTitle:@"ビンゴページ"];
        [self.navigationController pushViewController:pbGtopCon animated:YES];
    }
}
- (void)connection:(NSURLConnection *)i_connection didReceiveData:(NSData *)data
{
    //デリゲート側に実装されている場合はダミー
    
    NSLog(@"received data");
    
    NSError* error;
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"data = %@",json);

    NSLog(@"takumi takumi takumi");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
