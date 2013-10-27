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

+(NSDictionary *)getPlayBingoNumber
{
    NSString *url = @"http://www1066uj.sakura.ne.jp/bingo/api/entry/getPingoNumber.php";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *json_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError *error=nil;
    
    id jsonObj = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingAllowFragments error:&error];
    
    return  jsonObj;
    
}

@end
