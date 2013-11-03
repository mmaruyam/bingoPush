//
//  PBAboutThisAppViewController.m
//  PushBingo
//
//  Created by Takumi Yamamoto on 2013/10/28.
//  Copyright (c) 2013年 Takumi Yamamoto. All rights reserved.
//

#import "PBAboutThisAppViewController.h"

@interface PBAboutThisAppViewController ()

@end

@implementation PBAboutThisAppViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init{
    self = [super init];
    if(self){
        UIBarButtonItem *btn =
        [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonSystemItemStop
         target:self  // デリゲートのターゲットを指定
         action:@selector(closeModalView:)  // ボタンが押されたときに呼ばれるメソッドを指定
         ];
        self.navigationItem.rightBarButtonItem = btn;
    }
    return self;
}

-(void)closeModalView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel* kiyaku = [[UILabel alloc] initWithFrame:CGRectMake(5,80,self.view.frame.size.width - 5 ,400)];
    kiyaku.text = @"djfasdhfouaewoifajp98we8faふぁpshふぁううぇふぁいおsどいあおsdふぉあsぢおふあいうえいfうえいういういあういうあいうあいうあいういあうあい";
    kiyaku.textAlignment = NSTextAlignmentLeft;
    kiyaku.numberOfLines = 0;
    [self.view addSubview:kiyaku];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
