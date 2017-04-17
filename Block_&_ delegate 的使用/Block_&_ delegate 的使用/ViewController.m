//
//  ViewController.m
//  Block_&_ delegate 的使用
//
//  Created by qingling_yang on 17/4/14.
//  Copyright © 2017年 qianxx. All rights reserved.
//

#import "ViewController.h"
#import "YQLButton.h"

#import "TwoViewController.h"

@interface ViewController ()<YQLButtonDelegate, YQLProtocol>

@property (weak, nonatomic) IBOutlet YQLButton *delegateBtn;
@property (weak, nonatomic) IBOutlet YQLButton *blockBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.delegateBtn.delegate = self;
    self.blockBtn.delegate = self;
    
    self.delegateBtn.dataSource = self;
    self.blockBtn.dataSource = self;
    
    
}


- (void)popToNewPage:(NSInteger)tag {
    
    NSLog(@"pop- %ld", tag);
}

- (NSString *)pushToNewPage:(NSInteger)tag {

    NSLog(@"delegate- %ld", tag);
    return @"返回值";
}


- (IBAction)pushToTwoVC:(id)sender {
    TwoViewController *two = [TwoViewController shareViewController];
    
    [two setCountAge:^int(int a, int b) {
        NSLog(@"setCountAge: %d, %d", a, b);
        return a + b;
    }];
    
    [self.navigationController pushViewController:two animated:YES];
}



/*
 
 ＃＃＃ 代理delegate就是委托另一个对象来帮忙完成一件事情
 
 代理设计模式对于iOS开发的人来说肯定很熟悉了，代理delegate就是委托另一个对象来帮忙完成一件事情，为什么要委托别人来做呢，这其实是MVC设计模式中的模块分工问题，例如View对象它只负责显示界面，而不需要进行数据的管理，数据的管理和逻辑是Controller的责任，所以此时View就应该将这个功能委托给Controller去实现，当然你作为码农强行让View处理数据逻辑的任务，也不是不行，只是这就违背了MVC设计模式，项目小还好，随着功能的扩展，我们就会发现越写越难写；还有一种情况，就是这件事情做不到，只能委托给其他对象来做了，下面的例子中我会说明这种情况。
 
 下面的代码我想实现一个简单的功能，场景描述如下：TableView上面有多个CustomTableViewCell，cell上面显示的是文字信息和一个详情Button，点击button以后push到一个新的页面。为什么说这个场景用到了代理delegate？因为button是在自定义的CustomTableViewCell上面，而cell没有能力实现push的功能，因为push到新页面的代码是这样的，
 
 [self.navigationController pushViewController...];
 
 所以这时候CustomTableViewCell就要委托它所在的Controller去做这件事情了。
 
 按照我的编码习惯，我喜欢把委托的协议写在提出委托申请的类的头文件里面，现在的场景中是CustomTableViewCell提出了委托申请，下面是简单的代码，
 
 @protocol CustomCellDelegate <NSObject>
 
 - (void)pushToNewPage;
 
 @end
 
 
 
 @interface CustomTableViewCell : UITableViewCell
 
 @property(nonatomic, assign) id<CustomCellDelegate> delegate;
 
 
 @property (nonatomic, strong) UILabel *text1Label;
 
 @property(nonatomic,strong) UIButton *detailBtn;
 
 @end
 
 上面的代码在CustomTableViewCell.h中定义了一个协议CustomCellDelegate，它有一个需要实现的pushToNewPage方法，然后还要写一个属性修饰符为assign、名为delegate的property，之所以使用assign是因为这涉及到内存管理的东西，以后的博客中我会专门说明原因。
 
 接下来在CustomTableViewCell.m中编写Button点击代码，
 
 
 [self.detailBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
 
 对应的btnClicked方法如下，
 
 - (void)btnClicked:(UIButton *)btn
 
 {
 
 if (self.delegate && [self.delegaterespondsToSelector:@selector(pushToNewPage)]) {
 
 [self.delegate pushToNewPage];
 
 }
 
 }
 
 上面代码中的判断条件最好是写上，因为这是判断self.delegate是否为空，以及实现CustomCellDelegate协议的Controller是否也实现了其中的pushToNewPage方法。
 
 接下来就是受到委托申请的类，这里是对应CustomTableViewCell所在的ViewController，它首先要实现CustomCellDelegate协议，然后要实现其中的pushToNewPage方法，还有一点不能忘记的就是要设置CustomTableViewCell对象cell的delegate等于self，很多情况下可能忘了写cell.delegate = self;导致遇到问题不知云里雾里。下面的关键代码都是在ViewController.m中，
 
 首先是服从CumtomCellDelegate协议，这个大家肯定都知道，就像很多系统的协议，例如UIAlertViewDelegate、UITextFieldDelegate、UITableViewDelegate、UITableViewDatasource一样。
 
 @interface ViewController ()<CustomCellDelegate>
 
 @property (nonatomic, strong) NSArray *textArray;
 
 
 
 @end
 
 然后是实现CustomCellDelegate协议中的pushToNewPage方法，
 
 - (void)pushToNewPage
 
 {
 
 DetailViewController*detailVC = [[DetailViewController alloc] init];
 
 [self.navigationController pushViewController:detailVC animated:YES];
 
 }
 
 还有一个步骤最容易被忘记，就是设置CumtomTableViewCell对象cell的delegate，如下代码，
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 
 {
 
 static NSString *simpleIdentify = @"CustomCellIdentify";
 
 CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleIdentify];
 
 if (cell == nil) {
 
 cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleIdentify];
 
 }
 
 //下面代码很关键
 
 cell.delegate = self;
 
 cell.text1Label.text = [self.textArray objectAtIndex:indexPath.row];
 
 return cell;
 
 }
 
 通过cell.delegate = self;确保了CustomTableViewCell.m的判断语句if(self.delegate && ...){}中得self.delegate不为空，此时的self.delegate其实就是ViewController，cell对象委托了ViewController实现pushToNewPage方法。这个简单的场景描述了使用代理的一种情况，就是CustomTableViewCell没有能力实现pushViewController的功能，所以委托ViewController来实现。
 
 
 */


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
