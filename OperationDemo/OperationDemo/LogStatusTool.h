//
//  LogStatusTool.h
//  OperationDemo
//
//  Created by MOMO on 2018/4/18.
//  Copyright © 2018年 Wicky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogStatusTool : NSUserDefaults
+(void)login;
+(void)logout;
+(BOOL)isLogin;
@end
