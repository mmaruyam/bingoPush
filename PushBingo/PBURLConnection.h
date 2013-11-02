//
//  PBURLConnection.h
//  PushBingo
//
//  Created by Takumi Yamamoto on 2013/10/26.
//  Copyright (c) 2013年 Takumi Yamamoto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBURLConnection : NSObject

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

@end
