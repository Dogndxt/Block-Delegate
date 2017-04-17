//
//  YQLButton.h
//  Block_&_ delegate 的使用
//
//  Created by qingling_yang on 17/4/14.
//  Copyright © 2017年 qianxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YQLProtocol.h"

@protocol YQLButtonDelegate <NSObject>

- (NSString *)pushToNewPage:(NSInteger)tag;

@end

@interface YQLButton : UIButton

@property (nonatomic, assign) id<YQLButtonDelegate> delegate;

@property (nonatomic, assign) id<YQLProtocol> dataSource;

@end


