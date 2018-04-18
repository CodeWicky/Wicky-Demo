//
//  ViewController.m
//  OperationDemo
//
//  Created by MOMO on 2018/4/18.
//  Copyright © 2018年 Wicky. All rights reserved.
//

#import "ViewController.h"
#import "TestBlockOperation.h"
#import "LogStatusTool.h"
#import "LoginOperation.h"
#import "NormalOperation.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self testGCDGroup];
//    [self testOperationProperty];
//    [self testOperationCancel];
//    [self testOperationQueue];
//    [self testOperationQueueCancel];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshLogStatus];
}
- (IBAction)logAction:(id)sender {
    if ([sender isEqual:self.loginBtn]) {
        [LogStatusTool login];
    } else {
        [LogStatusTool logout];
    }
    [self refreshLogStatus];
}
- (IBAction)jumpAction:(id)sender {
    LoginOperation * logOp = [[LoginOperation alloc] initWithOriVC:self];
    NormalOperation * norOp = [[NormalOperation alloc] initWithOriVC:self];
    [norOp addDependency:logOp];
    NSOperationQueue * q = [NSOperationQueue new];
    [q addOperation:logOp];
    [q addOperation:norOp];
}


-(void)refreshLogStatus {
    if ([LogStatusTool isLogin]) {
        self.statusLb.text = @"登录状态：登录";
    } else {
        self.statusLb.text = @"登录状态：未登录";
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///GCD Group 同步测试
-(void)testGCDGroup {
    dispatch_group_t g = dispatch_group_create();
    dispatch_queue_t q = dispatch_queue_create("com.test.queue", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"Will enter task1");
    dispatch_group_enter(g);
    dispatch_group_async(g, q, ^{
        [self task1];
        dispatch_group_leave(g);
    });
    NSLog(@"Will enter task2");
    dispatch_group_enter(g);
    dispatch_group_async(g, q, ^{
        [self task2];
        dispatch_group_leave(g);
    });
    
    NSLog(@"Come to notify");
    dispatch_group_notify(g, q, ^{
        NSLog(@"Enter notify");
        [self taskComplete];
    });
    NSLog(@"Pass notify");
}

///Operation 各属性状态值变化测试
-(void)testOperationProperty {
    TestBlockOperation * bp1 = [TestBlockOperation blockOperationWithBlock:^{
        NSLog(@"enter bp1");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"leave bp1");
    }];
    bp1.name = @"bp1";
    NSArray * keyPathes = @[@"isReady",@"isCancelled",@"isExecuting",@"isFinished"];
    [self logOp:bp1 keyPathes:keyPathes];
    [self addObserverForOp:bp1 keyPathes:keyPathes];
    bp1.completionBlock = ^{
        [self taskComplete];
    };
    [bp1 start];
    [bp1 cancel];
}

///Operation start前cancel各属性状态值变化测试
-(void)testOperationCancel {
    TestBlockOperation * bp2 = [TestBlockOperation blockOperationWithBlock:^{
        NSLog(@"enter bp2");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"leave bp2");
    }];
    bp2.name = @"bp2";
    NSArray * keyPathes = @[@"isReady",@"isCancelled",@"isExecuting",@"isFinished"];
    [self addObserverForOp:bp2 keyPathes:keyPathes];
    [bp2 cancel];
    [bp2 start];
}

///Operation 添加至OperationQueue中各属性状态值变化测试
-(void)testOperationQueue {
    TestBlockOperation * bp1 = [TestBlockOperation blockOperationWithBlock:^{
        NSLog(@"enter bp1");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"leave bp1");
    }];
    bp1.name = @"bp1";
    bp1.completionBlock = ^{
        NSLog(@"bp1 complete");
    };
    
    TestBlockOperation * bp2 = [TestBlockOperation blockOperationWithBlock:^{
        NSLog(@"enter bp2");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"leave bp2");
    }];
    bp2.name = @"bp2";
    bp2.completionBlock = ^{
        NSLog(@"bp2 complete");
    };
    
    NSArray * keyPathes = @[@"isReady",@"isCancelled",@"isExecuting",@"isFinished"];
    
    [self addObserverForOp:bp1 keyPathes:keyPathes];
    [self addObserverForOp:bp2 keyPathes:keyPathes];
    
    NSOperationQueue * q = [NSOperationQueue new];
    [bp1 addDependency:bp2];
    [q addOperation:bp1];
    [q addOperation:bp2];
}

///Operation 添加至Queue之前被取消后依赖行为
-(void)testOperationQueueCancel {
    TestBlockOperation * bp1 = [TestBlockOperation blockOperationWithBlock:^{
        NSLog(@"enter bp1");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"leave bp1");
    }];
    bp1.name = @"bp1";
    bp1.completionBlock = ^{
//        NSLog(@"bp1 complete");
    };
    
    
    
    TestBlockOperation * bp2 = [TestBlockOperation blockOperationWithBlock:^{
        NSLog(@"enter bp2");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"leave bp2");
    }];
    bp2.name = @"bp2";
    bp2.completionBlock = ^{
        NSLog(@"bp2 complete");
    };
    NSArray * keyPathes = @[@"isReady",@"isCancelled",@"isExecuting",@"isFinished"];
    
    [self addObserverForOp:bp1 keyPathes:keyPathes];
    [self addObserverForOp:bp2 keyPathes:keyPathes];
    
    NSOperationQueue * q = [NSOperationQueue new];
    [bp1 addDependency:bp2];
    [bp2 cancel];
    [q addOperation:bp1];
    [q addOperation:bp2];
}

#pragma mark --- observer ---
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isKindOfClass:[NSOperation class]]) {
        NSLog(@"%@---%@---%@",[object name],keyPath,change);
    }
}

#pragma mark --- task ---
-(void)task1 {
    NSLog(@"Enter sleep 10.");
    [NSThread sleepForTimeInterval:10];
    NSLog(@"Leave sleep 10.");
}

-(void)task2 {
    NSLog(@"Enter sleep 5.");
    [NSThread sleepForTimeInterval:5];
    NSLog(@"Leave sleep 5.");
}

-(void)taskComplete {
    NSLog(@"All task finished.");
}

#pragma mark --- tool method ---
-(void)logOp:(NSOperation *)op keyPathes:(NSArray *)keyPathes {
    [keyPathes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@ %@ = %@",op.name,obj,[[op valueForKey:obj] boolValue]?@"true":@"false");
    }];
}

-(void)addObserverForOp:(id)op keyPathes:(NSArray *)keyPathes {
    [keyPathes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [op addObserver:self forKeyPath:obj options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:NULL];
    }];
}

@end
