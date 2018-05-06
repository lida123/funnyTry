//
//  FTUIListPreViewVC.m
//  funnyTry
//
//  Created by SGQ on 2018/4/23.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "FTUIListPreViewVC.h"
#import "FTUIListCellIem.h"

@interface FTUIListPreViewVC ()

@end

@implementation FTUIListPreViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    desLabel.font = [UIFont boldSystemFontOfSize:10];
    desLabel.textColor = [UIColor whiteColor];
    desLabel.textAlignment = NSTextAlignmentCenter;
    desLabel.text = self.item.classString;
    desLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:desLabel];
}

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
    UIPreviewAction *action0 = [UIPreviewAction actionWithTitle:@"action0" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"%s, line = %d, action0 = %@, previewViewController = %@", __FUNCTION__, __LINE__, action, previewViewController);
        
    }];
    
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"action1" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"%s, line = %d, action1 = %@, previewViewController = %@", __FUNCTION__, __LINE__, action, previewViewController);
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"action2" style:UIPreviewActionStyleSelected handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"%s, line = %d, action2 = %@, previewViewController = %@", __FUNCTION__, __LINE__, action, previewViewController);
    }];
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"action3" style:UIPreviewActionStyleSelected handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"%s, line = %d, action2 = %@, previewViewController = %@", __FUNCTION__, __LINE__, action, previewViewController);
    }];
    
    //该按钮可以是一个组,点击该组时,跳到组里面的按钮.
    UIPreviewActionGroup *actionGroup = [UIPreviewActionGroup actionGroupWithTitle:@"actionGroup" style:UIPreviewActionStyleSelected actions:@[action2, action3]];
    //直接返回数组.
    return  @[action0,action1,actionGroup];
}

@end
