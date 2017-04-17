//
//  YQLButton.m
//  Block_&_ delegate 的使用
//
//  Created by qingling_yang on 17/4/14.
//  Copyright © 2017年 qianxx. All rights reserved.
//

#import "YQLButton.h"

@implementation YQLButton

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToNewPage:)]) {
        NSString *temp = [self.delegate pushToNewPage:self.tag];
        NSLog(@"%@", temp);
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if (self.dataSource && [self.dataSource respondsToSelector:@selector(popToNewPage:)]) {
        [self.dataSource popToNewPage:self.tag];
    }
}

@end
