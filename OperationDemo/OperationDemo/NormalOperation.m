//
//  NormalOperation.m
//  OperationDemo
//
//  Created by MOMO on 2018/4/18.
//  Copyright © 2018年 Wicky. All rights reserved.
//

#import "NormalOperation.h"
#import "LogStatusTool.h"
#import "NormalViewController.h"

@implementation NormalOperation
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
                if ([LogStatusTool isLogin]) {
                    __strong typeof(weakSelf)strongSelf = weakSelf;
                    NormalViewController * norVC = [NormalViewController new];
                    if (strongSelf.oriVC.navigationController) {
                        [strongSelf.oriVC.navigationController pushViewController:norVC animated:YES];
                    } else {
                        [strongSelf.oriVC presentViewController:norVC animated:YES completion:nil];
                    }
                    [op finishOperation];
                } else {
                    NSLog(@"You need login first!");
                }
            });
        }];
    }
    return self;
}
@end
