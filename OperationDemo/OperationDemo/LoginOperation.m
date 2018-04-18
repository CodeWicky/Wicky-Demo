//
//  LoginOperation.m
//  OperationDemo
//
//  Created by MOMO on 2018/4/18.
//  Copyright © 2018年 Wicky. All rights reserved.
//

#import "LoginOperation.h"
#import "LoginViewController.h"
#import "LogStatusTool.h"

@implementation LoginOperation
-(instancetype)initWithOriVC:(UIViewController *)oriVC {
    if (!oriVC) {
        return nil;
    }
    if (self = [super init]) {
        self.oriVC = oriVC;
        self.concurrentHandler = NO;
        __weak typeof(self)weakSelf = self;
        [self addExecutionHandler:^(DWManualOperation *op) {
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf)strongSelf = weakSelf;
                LoginViewController * logVC = [LoginViewController new];
                logVC.logOp = weakSelf;
                if (strongSelf.oriVC.navigationController) {
                    [strongSelf.oriVC.navigationController pushViewController:logVC animated:YES];
                } else {
                    [strongSelf.oriVC presentViewController:logVC animated:YES completion:nil];
                }
            });
        }];
        if ([LogStatusTool isLogin]) {
            [self cancel];
        }
    }
    return self;
}
@end
