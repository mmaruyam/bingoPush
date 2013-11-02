//
//  PBURLConnection.m
//  PushBingo
//
//  Created by Takumi Yamamoto on 2013/10/26.
//  Copyright (c) 2013年 Takumi Yamamoto. All rights reserved.
//

#import "PBURLConnection.h"

@implementation PBURLConnection

-(id)init
{
    self = [super init];
    return self;
}

#pragma mark -
#pragma mark sync connection method
+(void)postUserInfo:(NSString *)params
{
    
    NSString *url = [[NSString alloc]initWithFormat:@"http://www1066uj.sakura.ne.jp/bingo/api/entry/setDeviceToken.php"];
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse* response;
    NSError* error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:urlRequest
                                           returningResponse:&response
                                                       error:&error];
    
    NSLog(@"takumi = %@ %@",result,error);
    
}

+(void)registUserData
{
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString* token = [userDef objectForKey:@"DEVICE_TOKEN"];
    NSString* fId   = [userDef objectForKey:@"FACEBOOK_ID"];
    NSString* fname = [userDef objectForKey:@"FACEBOOK_NAME"];
    
    fname = [fname stringByAddingPercentEscapesUsingEncoding:
           NSUTF8StringEncoding];
    
    NSString *url = [[NSString alloc]initWithFormat:@"http://www1066uj.sakura.ne.jp/bingo/api/entry/registUserData.php?id=%@&name=%@&token=%@",fId,fname,token];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *json_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError *error=nil;
    
    id jsonObj = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingAllowFragments error:&error];
    
    NSLog(@"登録完了　%@ , %@",jsonObj,error);
}

+(BOOL)joinPingo:(NSString *)pingoID
{
    // http://www1066uj.sakura.ne.jp/bingo/api/entry/joinPingo.php?tableid=44&userid=10
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString* fId   = [userDef objectForKey:@"FACEBOOK_ID"];
    
    NSString *url = [[NSString alloc]initWithFormat:@"http://www1066uj.sakura.ne.jp/bingo/api/entry/joinPingo.php?userid=%@&tableid=%@",fId,pingoID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *json_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError *error=nil;
    
    id jsonObj = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingAllowFragments error:&error];
    
    if(jsonObj == nil){
        return NO;
    }
    
    if(error != nil){
        return NO;
    }
    
    NSLog(@"ゲームに参加しました %@,%@",jsonObj,error);
    
    return YES;
}

+(NSString *)createBingoTable
{
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString* fId   = [userDef objectForKey:@"FACEBOOK_ID"];
    
    NSString *url = [[NSString alloc]initWithFormat:@"http://www1066uj.sakura.ne.jp/bingo/api/entry/createBingoTable.php?userid=%@",fId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *json_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError *error=nil;
    
    id jsonObj = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingAllowFragments error:&error];
    
    NSLog(@"ビンゴゲームを生成しました %@ , %@",jsonObj,error);
    
    return jsonObj;
}

+(NSDictionary *)getUserStatusFromTableID:(NSString *)tableid
{
    NSString *url = [[NSString alloc]initWithFormat:@"http://www1066uj.sakura.ne.jp/bingo/api/entry/getUserStatusCount.php?tableid=%@",tableid];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *json_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError *error=nil;
    
    id jsonObj = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingAllowFragments error:&error];
    
    return  jsonObj;
    
}

/*
+(NSDictionary *)getPlayBingoNumber
{
    NSString *url = @"http://www1066uj.sakura.ne.jp/bingo/api/entry/getPingoNumber.php";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *json_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError *error=nil;
    
    id jsonObj = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingAllowFragments error:&error];
    
    return  jsonObj;
    
}
 */

+(NSDictionary *)pushNumber:(NSString *)strNum
{
    
    NSString *url = [[NSString alloc] initWithFormat:@"http://www1066uj.sakura.ne.jp/bingo/api/entry/push.php?tableid=44&num=%@",strNum];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *json_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError *error=nil;
    
    id jsonObj = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingAllowFragments error:&error];
    
    return  jsonObj;
    
}

+(BOOL)updateUserStatus:(NSString *)strStatus
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString* fId   = [userDef objectForKey:@"FACEBOOK_ID"];
    NSString* tId   = [userDef objectForKey:@"BINGO_GAME_ID"];
    NSString *url = [[NSString alloc] initWithFormat:@"http://www1066uj.sakura.ne.jp/bingo/api/entry/updateUserStatus.php?tableid=%@&userid=%@&status=%@",tId,fId,strStatus];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *json_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError *error=nil;
    
    id jsonObj = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingAllowFragments error:&error];
    
    return  YES;
    
}


+(BOOL)registPushNumberIndex:(NSString *)index
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString* fId   = [userDef objectForKey:@"FACEBOOK_ID"];
    NSString* tId   = [userDef objectForKey:@"BINGO_GAME_ID"];
    
    NSString *url = [[NSString alloc] initWithFormat:@"http://www1066uj.sakura.ne.jp/bingo/api/entry/updatePushedNumberIndex.php?userid=%@&tableid=%@&index=%@",fId,tId,index];
    NSLog(@"ひいた　%@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *json_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError *error=nil;
    
    id jsonObj = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingAllowFragments error:&error];
    
    NSLog(@"ひいた番号を登録しました %@ , %@",jsonObj,error);
    
    return  YES;
}



/*************************************/
/*                                   */
/*           非同期通信系              */
/*                                   */
/*************************************/

#pragma mark -
#pragma mark async connection method
/// サーバからレスポンスが送られてきたときのデリゲート
- (void)connection:(NSURLConnection *)i_connection didReceiveResponse:(NSURLResponse *)i_response
{
    //デリゲート側に実装されている場合はダミー
    
    NSLog(@"received responce");
}

/// サーバからデータが送られてきたときのデリゲート
- (void)connection:(NSURLConnection *)i_connection didReceiveData:(NSData *)data
{
    //デリゲート側に実装されている場合はダミー
    
    NSLog(@"received data");
    NSLog(@"data = %@",data);
    
    NSError* error;
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
               
    
}

/// データのロードか完了した時のデリゲート
- (void)connectionDidFinishLoading:(NSURLConnection *)i_connection
{
    //デリゲート側に実装されている場合はダミー
    
    NSLog(@"load complete");
    
    NSLog(@"%@" , [self.delegate class]);
    
    [self.delegate finishExecute];
    
    
}


-(void)finishExecute
{
    //デリゲート側に実装されている場合はダミー
    NSLog(@"dummy");
}

/// サーバからエラーが返されたときのデリゲート
- (void)connection:(NSURLConnection *)i_connection didFailWithError:(NSError *)i_error
{
    NSLog(@"received error");
}

- (void) addUrl:(NSString *)strUrl
{
    requestURL = [NSURL URLWithString:strUrl];
}

- (void) execute
{
    id target;
    if(self.delegate)
    {
        target = self.delegate;
    }
    else
    {
        target = self;
    }
    
    
    NSURLRequest* request = [NSURLRequest requestWithURL:requestURL];
    [NSURLConnection connectionWithRequest:request delegate:target];
    
}

@end
