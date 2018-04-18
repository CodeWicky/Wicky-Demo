//
//  LoginOperation.h
//  OperationDemo
//
//  Created by MOMO on 2018/4/18.
//  Copyright © 2018年 Wicky. All rights reserved.
//

#import "DWManualOperation.h"
#import <UIKit/UIKit.h>

@interface LoginOperation : DWManualOperation
@property (nonatomic ,weak) UIViewController * oriVC;
-(instancetype)initWithOriVC:(UIViewController *)oriVC;
@end
