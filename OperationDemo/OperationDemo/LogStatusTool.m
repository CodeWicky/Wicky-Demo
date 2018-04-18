//
//  LogStatusTool.m
//  OperationDemo
//
//  Created by MOMO on 2018/4/18.
//  Copyright © 2018年 Wicky. All rights reserved.
//

#import "LogStatusTool.h"
static NSString * const logStatusKey = @"logStatusKey";
@implementation LogStatusTool
+(void)login {
    NSUserDefaults * d = [NSUserDefaults standardUserDefaults];
    [d setBool:YES forKey:logStatusKey];
    [d synchronize];
}

+(void)logout {
    NSUserDefaults * d = [NSUserDefaults standardUserDefaults];
    [d setBool:NO forKey:logStatusKey];
    [d synchronize];
}

+(BOOL)isLogin {
    NSUserDefaults * d = [NSUserDefaults standardUserDefaults];
    return [d boolForKey:logStatusKey];
}
@end
