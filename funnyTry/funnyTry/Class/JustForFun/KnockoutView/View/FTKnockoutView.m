//
//  FTKnockoutView.m
//  funnyTry
//
//  Created by SGQ on 2018/3/8.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "FTKnockoutView.h"

@interface FTKnockoutView ()
@property (nonatomic, strong) UIColor *promotedColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) CGFloat promotedLineWidth;
@property (nonatomic, assign) CGFloat normalLineWidth;
@end

@implementation FTKnockoutView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _promotedColor = [UIColor whiteColor];
        _normalColor = [UIColor grayColor];
        _backgroundColor = FT_RGBCOLOR(38, 38, 38);
        
        _promotedLineWidth = 3;
        _normalLineWidth = 1;
    }
    return self;
}

- (void)setResults:(NSArray *)results {
    _results = results;
    if (_results.count != 16) {
        return;
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (!self.results.count || self.results.count%2!=0 || self.results.count <=4) {
        return;
    }
    
    // draw background
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_backgroundColor set];
    CGContextFillRect(context, rect);
    
    // draw ceter image
    UIImage *image = [UIImage imageNamed:@"finnalWiner"];
    CGFloat imageX = (rect.size.width  - image.size.width) / 2.0;
    CGFloat imageY = (rect.size.height - image.size.height)/2.0;
    CGRect imageRect = CGRectMake(imageX, imageY, image.size.width, image.size.height);
    [image drawInRect:imageRect];
    
    // draw team name
    CGFloat teamWidth = 40;
    CGFloat teamHeight = 25;
    NSUInteger teamCount = self.results.count;
    UIEdgeInsets drawEdgeInsets = {8,20,8,20};
    CGFloat teamMargin = (rect.size.height - drawEdgeInsets.top - drawEdgeInsets.bottom - teamCount/2 * teamHeight)/(teamCount/2.0 - 1);
    
    NSMutableArray *temaNames = [NSMutableArray array];
    for (NSInteger i = 0; i < teamCount; i++) {
        [temaNames addObject:[@(i) stringValue]];
    }
    
    // 1 left
    CGFloat leftTeamNameX = drawEdgeInsets.left;
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByTruncatingTail];
    UIFont *nameFont = [UIFont systemFontOfSize:13];
    for (NSInteger i = 0; i < teamCount/2; i++) {
        // 1.1 name bg
        CGFloat leftTeamNameY = drawEdgeInsets.top + (teamHeight + teamMargin) * i;
        NSString *name = temaNames[i];
        CGRect namebgRect = CGRectMake(leftTeamNameX, leftTeamNameY, teamWidth, teamHeight);
        [[UIColor whiteColor] set];
        CGContextFillRect(context, namebgRect);
        
        // 1.2 name text
        CGSize textSize = [name boundingRectWithSize:namebgRect.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:nameFont} context:nil].size;
        textSize.width = MIN(textSize.width, namebgRect.size.width);
        [name drawInRect:CGRectMake(leftTeamNameX, leftTeamNameY + (namebgRect.size.height- textSize.height)/2.0, teamWidth, teamHeight) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:nameFont,NSForegroundColorAttributeName:self.normalColor}];
    }
    
    // 2 right
    CGFloat rightTeamNameX =  rect.size.width - drawEdgeInsets.right - teamWidth;
    for (NSInteger i = teamCount/2; i < teamCount; i++) {
        // 2.1 name bg
        CGFloat rightTeamNameY = drawEdgeInsets.top + (teamHeight + teamMargin) * (i- teamCount/2);
        NSString *name = temaNames[i];
        CGRect namebgRect = CGRectMake(rightTeamNameX, rightTeamNameY, teamWidth, teamHeight);
        [[UIColor whiteColor] set];
        CGContextFillRect(context, namebgRect);
        
        // 2.2 name text
        CGSize textSize = [name boundingRectWithSize:namebgRect.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:nameFont} context:nil].size;
        textSize.width = MIN(textSize.width, namebgRect.size.width);
        [name drawInRect:CGRectMake(rightTeamNameX, rightTeamNameY + (namebgRect.size.height- textSize.height)/2.0, teamWidth, teamHeight) withAttributes:@{NSParagraphStyleAttributeName:style,NSFontAttributeName:nameFont,NSForegroundColorAttributeName:self.normalColor}];
    }
    
    
}

@end
