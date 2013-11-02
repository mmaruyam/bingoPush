//
//  PBURLConnection.m
//  PushBingo
//
//  Created by Takumi Yamamoto on 2013/10/26.
//  Copyright (c) 2013年 Takumi Yamamoto. All rights reserved.
//

#import "PBURLConnection.h"

@implementation PBURLConnection

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

+(NSDictionary *)getPlayBingoNumber
{
    NSString *url = @"http://www1066uj.sakura.ne.jp/bingo/api/entry/getPingoNumber.php";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *json_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError *error=nil;
    
    id jsonObj = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingAllowFragments error:&error];
    
    return  jsonObj;
    
}

+(NSDictionary *)pushNumber:(NSString *)strNum
{
    NSString *url = [[NSString alloc] initWithFormat:@"http://www1066uj.sakura.ne.jp/bingo/api/entry/push.php?num=%@",strNum];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *json_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError *error=nil;
    
    id jsonObj = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingAllowFragments error:&error];
    
    return  jsonObj;
    
}

@end
