//
//  TestBlockOperation.m
//  OperationDemo
//
//  Created by MOMO on 2018/4/18.
//  Copyright © 2018年 Wicky. All rights reserved.
//


#define BeforeSuper \
do {\
NSLog(@"%@ before %@",self.name,NSStringFromSelector(_cmd));\
} while (0);

#define AfterSuper \
do {\
NSLog(@"%@ after %@",self.name,NSStringFromSelector(_cmd));\
} while (0);\

#import "TestBlockOperation.h"

@implementation TestBlockOperation
-(void)start {
    BeforeSuper
    [super start];
    AfterSuper
}

-(void)main {
    BeforeSuper
    [super main];
    AfterSuper
}

-(void)cancel {
    BeforeSuper
    [super cancel];
    AfterSuper
}

-(void)addDependency:(NSOperation *)op {
    BeforeSuper
    [super addDependency:op];
    AfterSuper
}
@end
