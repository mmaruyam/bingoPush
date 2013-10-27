//
//  PBURLConnection.h
//  PushBingo
//
//  Created by Takumi Yamamoto on 2013/10/26.
//  Copyright (c) 2013年 Takumi Yamamoto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBURLConnection : NSObject

//ユーザ情報をサーバに登録します
+(void)postUserInfo:(NSString *)params;

//管理者がpushする用の番号一覧を取得します
+(NSDictionary *)getPlayBingoNumber;

@end
