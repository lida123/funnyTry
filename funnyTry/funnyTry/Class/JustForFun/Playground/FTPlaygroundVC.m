//
//  FTPlaygroundVC.m
//  funnyTry
//
//  Created by SGQ on 2018/4/19.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "FTPlaygroundVC.h"
#import "Person.h"
#import "Student.h"
#import "Book.h"
#import "MJExtension.h"
#import "FTTouchView.h"
#import "FTLetterPathViewController.h"
#import "UIScrollView+Moving.h"
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIFeedbackGenerator.h>
#import "FTPlayroundTwoVC.h"
#import <YYKit.h>
#import <objc/runtime.h>
#import "MJRefresh.h"
#import "NOEELeftTitleBtn.h"
#import "NSObject+Sark.h"
#import "UIViewController+Association.h"


//父结构体
struct father
{
    int f1;
    int f2;
};

//子结构体
struct son
{
    //子结构体里定义一个父结构体变量，必须放在子结构体里的第一位
    struct father fn;
    //子结构体的扩展变量
    int s1;
    int s2;
};

#define FTA 0
#define FTB 1

#ifndef FTA
  #define FTABC 1
#elif FTB
  #define FTABC 0
#endif

int a = 6;




@interface FTPlaygroundVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) FTTouchView *redView;
@property (nonatomic, strong) FTTouchView *touchView;
@property (nonatomic, strong) UIScrollView *sr;
@property (nonatomic, strong) UIButton *button;
@end

@implementation FTPlaygroundVC

#pragma mark -Life cycle
- (void)viewDidLoad
{
    self.navigationItem.title = @"Have fun";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"nextGround" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick)];
    _redView = [[FTTouchView alloc] initWithFrame:CGRectMake(50, FTNavigationBarPlusStatusBarHeight, 200, 200)];
    _redView.backgroundColor = [UIColor grayColor];
    _redView.tintColor = [UIColor redColor];
    _redView.layoutMargins = UIEdgeInsetsMake(100, 100, 100, 100);
//    [self.view addSubview:_redView];
    
    NSDictionary *jsonDic = @{@"name":@"sgq",@"age":@"18",@"books":@[@{@"name":@"Chinese"},@{@"name":@"math"}]};
    Student *stu = [Student modelWithJSON:jsonDic];
    


    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(100, 100, 200, 200);
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor redColor].CGColor,
                       (id)[UIColor greenColor].CGColor,
                       nil];
    gradient.locations = @[@0.5,@1];
    gradient.startPoint = CGPointMake(0, 1);
    gradient.endPoint = CGPointMake(1, 0);
    [self.view.layer insertSublayer:gradient atIndex:0];

    //创建CGContextRef

    UIGraphicsBeginImageContext(self.view.bounds.size);

    CGContextRef gc = UIGraphicsGetCurrentContext();

    //创建CGMutablePathRef

    CGMutablePathRef path = CGPathCreateMutable();

    //绘制Path

    CGRect rect = CGRectInset(self.view.bounds, 1, 30);

    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));

    CGPathAddLineToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetHeight(rect));

    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect), CGRectGetHeight(rect) * 2 / 3);

    CGPathCloseSubpath(path);

    //绘制渐变

    [self drawLinearGradient:gc path:path startColor:[UIColor greenColor].CGColor endColor:[UIColor redColor].CGColor];

    //注意释放CGMutablePathRef

    CGPathRelease(path);

    //从Context中获取图像，并显示在界面上

    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];

    [self.view addSubview:imgView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"贝格尔来德" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"c"] forState:UIControlStateNormal];
    [button sizeToFit];
    button.frame = CGRectMake(0, 0, button.frame.size.width, 30);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    button.center = self.view.center;
    button.layer.cornerRadius = 2;
    button.backgroundColor = [UIColor redColor];

    button.titleLabel.font = [UIFont systemFontOfSize:18];

    [self.view addSubview:button];

    unsigned int count;
    objc_property_t * list1 = class_copyPropertyList([UIViewController class], &count);
    
    
    for (NSInteger i = 0; i < count; i++) {
        objc_property_t p = list1[i];
        NSLog(@"----%s",property_getName(p));
    }


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"one %s",__func__);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
     NSLog(@"one %s",__func__);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     NSLog(@"one %s",__func__);
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"one %s",__func__);
}

- (void)willChangeValueForKey:(NSString *)key {
    
}

- (void)didChangeValueForKey:(NSString *)key {
    
}

void test(struct son *t)
{
    //将子结构体指针强制转换成父结构体指针
    struct father *f = (struct father *)t;
    //打印原始值
    printf("f->f1 = %d\n",f->f1);
    printf("f->f2 = %d\n",f->f2);
    //修改原始值
    f->f1 = 30;
    f->f2 = 40;
}

- (NSAttributedString *)rankStringForSHow {
    NSString * levelTitle= @"V8-一代彩神";
  
    NSArray * arr = [levelTitle componentsSeparatedByString:@"-"];
    if (arr.count != 2) {
        return nil;
    }
    
    NSString *rank = arr[0];
    NSString *desc = arr[1];
    NSString *whole = [NSString stringWithFormat:@"%@%@",rank,desc];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:whole attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    [attri setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]} range:[whole rangeOfString:rank]];
    [attri addAttribute:NSBaselineOffsetAttributeName value:@(0.36 * (16 - 12)) range:NSMakeRange(rank.length, whole.length - rank.length)];
    return attri;
    
}

- (void)drawLinearGradient:(CGContextRef)context

                      path:(CGPathRef)path

                startColor:(CGColorRef)startColor

                  endColor:(CGColorRef)endColor

{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    
    CGContextAddPath(context, path);
    
    CGContextClip(context);
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    
    CGColorSpaceRelease(colorSpace);
    
}



- (NSString *)hexString:(NSData *)data{
    NSUInteger length = data.length;
    NSMutableString *result = [NSMutableString stringWithCapacity:length * 2];
    const unsigned char *byte = data.bytes;
    for (int i = 0; i < length; i++, byte++) {
        [result appendFormat:@"%02X", *byte];
    }
    return result;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{    
    
}

#pragma mark -Private
- (void)pushToSomeVC
{

}

- (void)buttonClicked:(UIButton*)button
{
    button.backgroundColor = [UIColor redColor];
    [button performSelector:@selector(setBackgroundColor:) withObject:[UIColor greenColor] afterDelay:0.4];
}

- (void)rightBarButtonClick
{
 
    FTPlayroundTwoVC *vc = [[FTPlayroundTwoVC alloc] init];
//    vc.view.frame = CGRectMake(0, 0, 100, 100);
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -GCD
// 在并发处理耗时操作后,再回到主线程就行UI刷新,使用apply的方式要优于group,apply方式会GCD会管理并发
- (void)testGCDGroup
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"hanle data end,try to refresh UI!");
    });
    
    NSArray *nums = @[@1,@2,@3,@4];
    for (NSNumber *num in nums) {
        dispatch_group_async(group, queue, ^{
            [self handleNum:num];
        });
    }
    
    NSLog(@"add mission end!");
    
    /*
     2018-04-20 13:51:42.960902+0800 funnyTry[519:126146] add mission end!
     2018-04-20 13:51:42.960950+0800 funnyTry[519:126192] hanle num = 2
     2018-04-20 13:51:42.960984+0800 funnyTry[519:126192] hanle num = 3
     2018-04-20 13:51:42.961006+0800 funnyTry[519:126192] hanle num = 4
     2018-04-20 13:51:42.960918+0800 funnyTry[519:126195] hanle num = 1
     2018-04-20 13:51:42.973244+0800 funnyTry[519:126146] hanle data end,try to refresh UI!
     */
}

- (void)handleNum:(NSNumber *)num
{
    NSLog(@"hanle num = %zd",num.integerValue);
}

- (void)testGCDApply // 较优选择,GCD 会管理并发
{
    dispatch_queue_t queue = dispatch_queue_create("1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        
        dispatch_apply(10, queue, ^(size_t num) {
            NSLog(@"%zd %@",num,[NSThread currentThread]);
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"refresh UI");
        });
        
    });
    /*
     2018-04-20 14:56:49.531868+0800 funnyTry[601:141159] 0 <NSThread: 0x17006c180>{number = 3, name = (null)}
     2018-04-20 14:56:49.531962+0800 funnyTry[601:141159] 1 <NSThread: 0x17006c180>{number = 3, name = (null)}
     2018-04-20 14:56:49.531995+0800 funnyTry[601:141159] 2 <NSThread: 0x17006c180>{number = 3, name = (null)}
     2018-04-20 14:56:49.532025+0800 funnyTry[601:141159] 3 <NSThread: 0x17006c180>{number = 3, name = (null)}
     2018-04-20 14:56:49.532054+0800 funnyTry[601:141159] 4 <NSThread: 0x17006c180>{number = 3, name = (null)}
     2018-04-20 14:56:49.532083+0800 funnyTry[601:141159] 5 <NSThread: 0x17006c180>{number = 3, name = (null)}
     2018-04-20 14:56:49.532172+0800 funnyTry[601:141159] 6 <NSThread: 0x17006c180>{number = 3, name = (null)}
     2018-04-20 14:56:49.532202+0800 funnyTry[601:141159] 7 <NSThread: 0x17006c180>{number = 3, name = (null)}
     2018-04-20 14:56:49.532230+0800 funnyTry[601:141159] 8 <NSThread: 0x17006c180>{number = 3, name = (null)}
     2018-04-20 14:56:49.532271+0800 funnyTry[601:141159] 9 <NSThread: 0x17006c180>{number = 3, name = (null)}
     2018-04-20 14:56:49.538788+0800 funnyTry[601:141136] refresh UI
     */
}

- (void)testGCDSource
{
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_main_queue());
    dispatch_queue_t queue = dispatch_queue_create("label", DISPATCH_QUEUE_CONCURRENT);
    dispatch_source_set_event_handler(source, ^{
        NSLog(@"%zd",dispatch_source_get_data(source));
    });
    dispatch_resume(source);
    
    dispatch_apply(10, queue, ^(size_t t) {
        dispatch_source_merge_data(source, 1);
    });
    
}

- (void)testGCDSemaphore
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    dispatch_queue_t queue =  dispatch_queue_create("label", DISPATCH_QUEUE_CONCURRENT);
    
    for (NSInteger i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"%zd ing",i);
            sleep(2);
            NSLog(@"%zd end",i);
            dispatch_semaphore_signal(semaphore);
        });
    }
}

- (void)testBarrier
{
    dispatch_queue_t queue = dispatch_queue_create("lbale", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"one");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"two");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"three");
    });
    
    dispatch_barrier_async(queue, ^{
        sleep(2.0);
        NSLog(@"barrier");
    });
    
    NSLog(@"after barrier");
    
    dispatch_async(queue, ^{
        NSLog(@"four");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"five");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"six");
    });
    
    /*
     2018-04-23 09:27:48.185908+0800 funnyTry[805:300491] after barrier
     2018-04-23 09:27:48.185995+0800 funnyTry[805:300517] one
     2018-04-23 09:27:48.186020+0800 funnyTry[805:300517] two
     2018-04-23 09:27:48.186034+0800 funnyTry[805:300517] three
     2018-04-23 09:27:50.191364+0800 funnyTry[805:300517] barrier
     2018-04-23 09:27:50.191807+0800 funnyTry[805:300517] four
     2018-04-23 09:27:50.192011+0800 funnyTry[805:300517] five
     2018-04-23 09:27:50.192069+0800 funnyTry[805:300517] six
     */
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    scrollView.isMoving = NO;
    NSLog(@"%s",__func__);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
     scrollView.isMoving = NO;
    NSLog(@"%s",__func__);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
         scrollView.isMoving = NO;
          NSLog(@"%s",__func__);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
     scrollView.isMoving = YES;
    
//    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
}

@end
