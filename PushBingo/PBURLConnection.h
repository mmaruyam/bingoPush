//
//  PBURLConnection.h
//  PushBingo
//
//  Created by Takumi Yamamoto on 2013/10/26.
//  Copyright (c) 2013年 Takumi Yamamoto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBURLConnection : NSObject
{
    NSURL* requestURL;
}

//管理者がpushする用の番号一覧を取得します
+(NSDictionary *)getPlayBingoNumber;

//pushします
+(NSDictionary *)pushNumber:(NSString *)strNum;

//ユーザ登録
+(void)registUserData;

//ビンゴゲームを生成します
+(NSString *)createBingoTable;

//ビンゴゲームに参加します
+(BOOL)joinPingo:(NSString *)pingoID;

//ひいた番号を登録します
+(BOOL)registPushNumberIndex:(NSString *)index;

//ユーザステータスを更新します
+(BOOL)updateUserStatus:(NSString *)strStatus;

//ユーザステータスを取得します
+(NSDictionary *)getUserStatusFromTableID:(NSString *)tableid;

/*
/// サーバからレスポンスが送られてきたときのデリゲート
- (void)connection:(NSURLConnection *)i_connection didReceiveResponse:(NSURLResponse *)i_response;

/// サーバからデータが送られてきたときのデリゲート
- (void)connection:(NSURLConnection *)i_connection didReceiveData:(NSData *)i_data;

/// データのロードか完了した時のデリゲート
- (void)connectionDidFinishLoading:(NSURLConnection *)i_connection;

/// サーバからエラーが返されたときのデリゲート
- (void)connection:(NSURLConnection *)i_connection didFailWithError:(NSError *)i_error;
*/

- (void) addUrl:(NSString *)strUr;
- (void) execute;

@property (strong, nonatomic) id delegate;

@end
