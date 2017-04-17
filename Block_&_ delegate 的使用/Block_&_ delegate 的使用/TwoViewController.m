//
//  TwoViewController.m
//  Block_&_ delegate 的使用
//
//  Created by qingling_yang on 17/4/17.
//  Copyright © 2017年 qianxx. All rights reserved.
//

#import "TwoViewController.h"
#import "YQLButton.h"


typedef int(^getAgeCount)(int, int); // 定义 block 类型

@interface TwoViewController ()<YQLButtonDelegate, YQLProtocol>

@property (weak, nonatomic) IBOutlet YQLButton *delegateBtn;
@property (weak, nonatomic) IBOutlet YQLButton *blockBtn;


@end

@implementation TwoViewController

#pragma mark - 获取此控制器
+(instancetype)shareViewController
{
    TwoViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TwoViewController"];
    return vc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // delegate
    [self delegate];

    // block
    
    int (^ageCount)(int, int) = ^int(int a, int b) {
    
        return a + b;
    };
    NSLog(@"%d", ageCount(12, 45));
    
    
    if (self.CountAge) {
        NSLog(@"%d", self.CountAge(13, 45));
    }
    
    [self blockTest:^int(int a, int b) {
        
        NSLog(@"a ---- %d", a);
        return a;
    }];
    
    
    getAgeCount a = ^int(int a, int b) {
        
        return a + b;
    };

}

/********************** block  *********************/

- (void)blockTest:(int (^)(int, int))age {

    NSLog(@"%d", age(12, 46));
}

- (void)blockTest2: (getAgeCount) temp {

    temp(1, 46);
}


/*
 
 block有如下几种使用情况，
 
 1、作为一个本地变量（local variable）
 
     returnType (^blockName)(parameterTypes) = ^returnType(parameters) {...};
 
 2、作为@property
 
     @property (nonatomic, copy) returnType (^blockName)(parameterTypes);
 
 3、作为方法的参数（method parameter）
 
     - (void)someMethodThatTakesABlock:(returnType (^)(parameterTypes))blockName;
 
 4、作为方法参数的时候被调用
 
     [someObject someMethodThatTakesABlock: ^returnType (parameters) {...}];
 
 5、使用 typedef 来定义 block 类型，可以事半功倍
 
     typedef returnType (^TypeName)(parameterTypes);
     TypeName blockName = ^returnType(parameters) {...};
 
 
 
 
 https://my.oschina.net/leejan97/blog/209762
 
 http://fuckingblocksyntax.com
 
 */




/********************** delegate  *********************/

- (void)delegate {
    self.delegateBtn.delegate = self;
    self.blockBtn.delegate = self;
    self.delegateBtn.dataSource = self;
    self.blockBtn.dataSource = self;
}

- (void)popToNewPage:(NSInteger)tag {
    
    NSLog(@"TwoViewController pop- %ld", tag);
}

- (NSString *)pushToNewPage:(NSInteger)tag {
    
    NSLog(@"TwoViewController delegate- %ld", tag);
    return @"返回值";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
