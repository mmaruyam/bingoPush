//
//  PBAdminBingoListViewController.m
//  PushBingo
//
//  Created by 丸山 三喜也 on 11/3/13.
//  Copyright (c) 2013 Takumi Yamamoto. All rights reserved.
//

#import "PBAdminBingoListViewController.h"
#import "PBAdminBingoViewController.h"
#import "PBURLConnection.h"
#import "PBIndicatorView.h"

@interface PBAdminBingoListViewController ()
{
    NSArray *aryBingoListData;
    NSString *strUserID;
}

@end

@implementation PBAdminBingoListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        // initialize
        aryBingoListData = [[NSArray alloc] init];
        
        // userid 取得
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        strUserID = [NSString stringWithString:[userDef objectForKey:@"FACEBOOK_ID"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    // data
    aryBingoListData = [PBURLConnection getBingoDataFromUserId:strUserID];
//    NSLog(@"aryBingoListData: %@", aryBingoListData);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Original Method
+ (CGFloat)calcCellHeight
{
    CGFloat cfHeight = CELL_HEIGHT_DEFAULT;
    return cfHeight;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [aryBingoListData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSDictionary *dicPingoData = [aryBingoListData objectAtIndex:indexPath.row];
    UIImage *imgStatusWait = [UIImage imageNamed:@"wait"];

    NSString *strID = [dicPingoData objectForKey:@"id"];
    NSString *strTitle = [dicPingoData objectForKey:@"table_name"];
    NSString *strCreateDate = [dicPingoData objectForKey:@"create"];
    NSString *strUpdateDate = [dicPingoData objectForKey:@"update"];
    NSString *strStatus = [dicPingoData objectForKey:@"status"];
    
    NSString *strDisplayTitle = [NSString stringWithFormat:@"%@. %@", strID, strTitle];
    NSString *strDisplaySubTitle = [NSString stringWithFormat:@"作成日: %@", strCreateDate];

    cell.imageView.image = imgStatusWait;
    cell.textLabel.text = strDisplayTitle;
    cell.detailTextLabel.text = strDisplaySubTitle;
    cell.detailTextLabel.numberOfLines = 0;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"testtt");
    
    // update status from wait to start
    NSString *status = @"start";
    NSString *strBingoID = [[aryBingoListData objectAtIndex:indexPath.row] objectForKey:@"id"];
    NSString *url = [[NSString alloc]initWithFormat:@"http://www1066uj.sakura.ne.jp/bingo/api/entry/updateTableStatus.php?tableid=%@&status=%@", strBingoID, status];
    NSLog(@"updateTableStatus url: %@",url);
    
    PBURLConnection* pbUrlCon = [[PBURLConnection alloc] init];
    [pbUrlCon addUrl:url];
    [pbUrlCon execute];
    
    // start bingo game
    PBAdminBingoViewController *adminBingoCnt = [[PBAdminBingoViewController alloc] initWithBingoID:strBingoID];
    [self.navigationController pushViewController:adminBingoCnt animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
