//
//  BaseMacro.h
//  funnyTry
//
//  Created by SGQ on 2017/11/6.
//  Copyright © 2017年 GQ. All rights reserved.
//

#ifndef BaseMacro_h
#define BaseMacro_h

/* log */
#ifdef DEBUG
#define FTDPRINT(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define FTDPRINT(xx, ...)  ((void)0)
#endif

/* colors */
#define FT_RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define FT_RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]
#define AppDefaultBackgroundColor FT_RGBCOLOR(245,244,249)

/* lineHeight */
#define FT_LineHeight(font) (font.ascender - font.descender) + 1

/* screenBounds */
#define FTScreenBounds [UIScreen mainScreen].bounds

/* date */
#define FT_MINUTE 60
#define FT_HOUR   (60 * FT_MINUTE)
#define FT_DAY    (24 * FT_HOUR)
#define FT_5_DAYS (5  * FT_DAY)
#define FT_WEEK   (7  * FT_DAY)

/* tabbarHeight */
#define FTTabbarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83.0f:49.0f)

/* statusBarHeight */
#define FTStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

/* navigationBarHeight */
#define FTNavigationBarHeight 44.0f

/* isIPhone ? */
#define isiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

/* isIPhone X ? */
#define isiPhoneX FTScreenBounds.size.width >= 375.0f && FTScreenBounds.size.height >= 812.0f && isiPhone

/*add*/
#define ADDSelectorForButton(btn,target,selector) [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside]

/* weakSelf */
#define WS(weakSelf) __weak typeof(self) weakSelf = self;

/* one Pixel height */ 
#define FT_SINGLE_LINE_HIEGHT  ([UIScreen mainScreen].scale> 0 ? 1.0/[UIScreen mainScreen].scale : 1.0)

#endif /* BaseMacro_h */