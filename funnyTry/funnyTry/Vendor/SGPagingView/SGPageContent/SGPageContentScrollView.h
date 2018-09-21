





#import <UIKit/UIKit.h>

@class SGPageContentScrollView;

@protocol SGPageContentScrollViewDelegate <NSObject>
@optional
/**
 *  联动 SGPageTitleView 的方法
 *
 *  @param pageContentScrollView      SGPageContentScrollView
 *  @param progress                   SGPageContentScrollView 内部视图滚动时的偏移量
 *  @param originalIndex              原始视图所在下标
 *  @param targetIndex                目标视图所在下标
 */
- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView didScrollToChangedProgress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;
/**
 *  获取 SGPageContentScrollView 当前子控制器的下标值
 *
 *  @param pageContentScrollView     SGPageContentScrollView
 *  @param currentIndex                     SGPageContentScrollView 当前子控制器的下标值
 *  @param previousIndex                    SGPageContentScrollView 上一个控制器的下标值
 */
- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView didScrollToIndex:(NSInteger)currentIndex previousIndex:(NSInteger)previousIndex;

/** SGPageContentScrollView 内容开始拖拽方法 */
- (void)pageContentScrollViewWillBeginDragging;

/** SGPageContentScrollView 内容结束拖拽方法 */
- (void)pageContentScrollViewDidEndDecelerating;

@end


@interface SGPageContentScrollView : UIView

/** SGPageContentScrollViewDelegate */
@property (nonatomic, weak) id<SGPageContentScrollViewDelegate> pageContentScrollViewDelegate;

/** 是否需要滚动 SGPageContentScrollView 默认为 YES；设为 NO 时，不必设置 SGPageContentScrollView 的代理及代理方法 */
@property (nonatomic, assign) BOOL isScrollEnabled;

/** 点击标题触发动画切换滚动内容，默认为 NO */
@property (nonatomic, assign) BOOL isAnimated;


/**
 *  对象方法创建 SGPageContentScrollView
 *
 *  @param frame        frame
 *  @param parentVC     当前控制器
 *  @param childVCs     子控制器个数
 */
- (instancetype)initWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs;

/**
 *  类方法创建 SGPageContentScrollView
 *
 *  @param frame        frame
 *  @param parentVC     当前控制器
 *  @param childVCs     子控制器个数
 */
+ (instancetype)pageContentScrollViewWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs;

/** 给外界提供的方法，根据 SGPageTitleView 标题选中时的下标并显示相应的子控制器 */
- (void)setPageContentScrollViewCurrentIndex:(NSInteger)currentIndex;

// #warning send me the notice: `didMoveToParentViewController:`
- (void)parentControllerdidMoveToParentViewController:(UIViewController*)parent;
@end
