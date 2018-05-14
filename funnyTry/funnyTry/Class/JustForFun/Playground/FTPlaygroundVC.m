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
#import "MJRefresh.h"

@interface FTPlaygroundVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) FTTouchView *redView;
@property (nonatomic, strong) FTTouchView *touchView;
@property (nonatomic, strong) UIScrollView *sr;
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
    [self.view addSubview:_redView];
    
    NSDictionary *jsonDic = @{@"name":@"sgq",@"age":@"18",@"books":@[@{@"name":@"Chinese"},@{@"name":@"math"}]};
    Student *stu = [Student modelWithJSON:jsonDic];
    
//    NSLog(@"%@",stu);
//
//    NSString *url=@"http://unmi.cc?p1=%+&sd &p2=中文";
//    NSString *encodedValue = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"%@",encodedValue);
    
    
    NSString *param = @"%+&sd f";
//    param = @"https://t2015.9188.com/?lotteryflag=1#/lsjWanFa";
    
    NSLog(@"%@",[param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    
    
    NSString * urlString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)param, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL,kCFStringEncodingUTF8));
    NSLog(@"%@",urlString);
    
    NSString *encodedValue2 = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,                                    (CFStringRef)param, nil,                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
     NSLog(@"%@",encodedValue2);
    
    

    
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _sr.isMoving = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    char * a =  @encode(id);

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
