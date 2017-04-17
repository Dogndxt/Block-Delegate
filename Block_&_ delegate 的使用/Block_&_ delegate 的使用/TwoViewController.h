//
//  TwoViewController.h
//  Block_&_ delegate 的使用
//
//  Created by qingling_yang on 17/4/17.
//  Copyright © 2017年 qianxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoViewController : UIViewController

@property (nonatomic, assign) int (^CountAge)(int, int);


+ (instancetype) shareViewController;

@end
