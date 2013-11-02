//
//  PBGuestInputIDViewController.m
//  PushBingo
//
//  Created by Takumi Yamamoto on 2013/10/24.
//  Copyright (c) 2013年 Takumi Yamamoto. All rights reserved.
//

#import "PBGuestInputIDViewController.h"
#import "PBGuestTopViewController.h"
#import "PBURLConnection.h"

@interface PBGuestInputIDViewController ()

@end

@implementation PBGuestInputIDViewController

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
        BOOL bJoin = [PBURLConnection joinPingo:tf.text];
        
        if(bJoin){
            PBGuestTopViewController* pbGtopCon = [[PBGuestTopViewController alloc] init];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
