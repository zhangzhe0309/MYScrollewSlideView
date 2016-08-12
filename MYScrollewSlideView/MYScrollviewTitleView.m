//
//  MYScrollviewTitleView.m
//  testScrollerTitleView
//
//  Created by zhangzhe on 16/8/12.
//  Copyright © 2016年 zhangzhe. All rights reserved.
//

#import "MYScrollviewTitleView.h"
#import "MYTitleView.h"
#import "MYTempView.h"

@interface MYScrollviewTitleView ()<UIScrollViewDelegate>
@property (nonatomic, strong)    UIScrollView    *scrollView;
@property (nonatomic, assign)    CGFloat         topSegmentControlHeight;
@property (nonatomic, assign)    CGFloat         scrollViewY;
@property (nonatomic, assign)    CGFloat         scrollViewHeight;
@property (nonatomic, assign)    CGFloat         scrollViewWidth;
@property (nonatomic, assign)    NSInteger       currentPage;
@property (nonatomic, assign)    CGFloat         direction; //运动方向，1 <==> right, -1 <==> left
@property (nonatomic, assign)    BOOL            isDraging;
@property (nonatomic, strong)   MYTitleView     *segmentControl;
@property (nonatomic, strong) NSMutableArray    *scrollSubViewsArray;
@end

@implementation MYScrollviewTitleView

- (instancetype)initWithFrame:(CGRect)frame with:(NSArray *)arr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleArray = arr.copy;
        [self loadSubviews];
    }
    return self;
}

- (void)loadSubviews
{
    self.topSegmentControlHeight = 50;
    self.scrollViewY = self.topSegmentControlHeight + 10;
    self.scrollViewHeight = self.frame.size.height - self.scrollViewY;
    self.scrollViewWidth = self.frame.size.width;
    self.currentPage = 0;
    self.direction = 1;
    self.isDraging = false;
    [self addTopSegmentControl];
    [self addScrollView];
    
    [self setScrollSubView:0];
}

- (void)addTopSegmentControl
{
    [self addSubview: self.segmentControl];
    __weak typeof(self) weakSelf = self;
    self.segmentControl.clickBlock = ^(NSInteger page){
        [weakSelf tapButton:page];
    };
}

- (void)addScrollView
{
    [self addSubview:self.scrollView];
    [self addScrollSubView];
}

- (void)addScrollSubView
{
    for (NSInteger i = 0; i < 3; i++) {
        MYTempView *temp = [[MYTempView alloc] initWithFrame:[self getScrollSubViewFrameWithIndex:i]];
        temp.tag = i;
        temp.layer.borderColor = [UIColor brownColor].CGColor;
        temp.layer.borderWidth = 10.0f;
        [self.scrollView addSubview:temp];
        [self.scrollSubViewsArray addObject:temp];
                            
    }
}

- (void)tapButton:(NSInteger)page
{
    self.isDraging = NO;
    [self setSameSubView:page];
    if (page != _currentPage) {
        if (page > _currentPage) {
            self.direction = 1;
        }else
            self.direction = -1;
        _currentPage = page;

     [UIView animateWithDuration:0.3 animations:^{
         CGPoint contenpoint = CGPointMake(self.scrollView.contentOffset.x + (self.frame.size.width * self.direction)  - 1, 0);
         self.scrollView.contentOffset = contenpoint;
     } completion:^(BOOL finished) {
         CGPoint afterPoint = CGPointMake(self.scrollView.contentOffset.x+ 1, 0);
         self.scrollView.contentOffset = afterPoint;
     }];
        
    }
}

/**
 设置ScrollSubView上应显示的内容
 
 - parameter currentPage: 当前页数
 */
- (void)setSameSubView:(NSInteger)currentPage
{
    NSString *title = self.titleArray[[self getCurrentContentIndex:currentPage]];
    for (NSInteger i = 0; i < self.scrollSubViewsArray.count; i ++) {
        MYTempView *tem = self.scrollSubViewsArray[i];
        [tem configScrollSubView:title];
    }
}

/**
 获取当前显示图片索引
 
 - parameter currentPage: 当前页数
 
 - returns:
 */

- (NSInteger)getBeforeContentIndex:(NSInteger)currentpage
{
    if (self.titleArray.count > 0) {
        NSInteger beforeNumber = [self getCurrentContentIndex:currentpage] - 1;
        return beforeNumber < 0 ? self.titleArray.count - 1 : beforeNumber ;
    }
    return  0;
}
/**
 获取当前显示图片索引
 
 - parameter currentPage: 当前页数
 
 - returns:
*/
- (NSInteger)getCurrentContentIndex:(NSInteger)currentpage
{
    if (self.titleArray.count) {
        NSInteger tempCurrentPage = currentpage % self.titleArray.count;
        
        return (tempCurrentPage < 0 ? self.titleArray.count - 1 : tempCurrentPage);
    }
    return 0;
}
/**
 获取当前图片显示的下一张图片的索引
 
 - parameter currentPage:
 
 - returns:
 */

- (NSInteger)getLastContentIndex:(NSInteger)currentPage
{
    NSInteger lastNumber = [self getCurrentContentIndex:currentPage] + 1;
    return lastNumber >= self.titleArray.count ? 0 : lastNumber;
}

- (CGRect)getScrollSubViewFrameWithIndex:(NSInteger)index
{
    return CGRectMake([@(index) floatValue] * self.scrollViewWidth, 0, self.scrollViewWidth, self.scrollViewHeight);
}

/**
 设置ScrollSubView上应显示的内容
 
 - parameter currentPage: 当前页数
 */
- (void)setScrollSubView:(NSInteger)page
{
    NSArray * titleIndexArray = [NSArray arrayWithObjects:@([self getBeforeContentIndex:self.currentPage]),
                                 @([self getCurrentContentIndex:self.currentPage]),
                                 @([self getLastContentIndex:self.currentPage]), nil];
    for (NSInteger i = 0; i < self.scrollSubViewsArray.count; i++) {
        MYTempView *tem = self.scrollSubViewsArray[i];
        NSString *title = self.titleArray[[titleIndexArray[i] integerValue]];
        [tem configScrollSubView:title];
    }
}
#pragma mark -- scrollview  -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.titleArray.count) {
        CGFloat contentOffsetX = scrollView.contentOffset.x + (self.currentPage - 1) * self.frame.size.width;
        [self.segmentControl changeMaskX:(contentOffsetX*(1/(@(_titleArray.count).floatValue)))];
    }
    [self moveImageView:self.scrollView.contentOffset.x];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isDraging = YES;
}

/**
 移动Button到合适的位置
 
 - parameter offsetX:
 */

- (void)moveImageView:(CGFloat)offsetX
{
    CGFloat temp = offsetX / self.frame.size.width;
    if (temp == 0 || temp == 1 || temp == 2) {
        if (self.isDraging) {
            NSInteger position = temp -1;
            self.currentPage = [self getCurrentContentIndex:self.currentPage + position];
        }
        CGPoint contenpoint = CGPointMake(self.frame.size.width, 0);
        self.scrollView.contentOffset = contenpoint;
        [self setScrollSubView:self.currentPage];
    }
}

#pragma mark -- getter -
- (MYTitleView *)segmentControl
{
    if (!_segmentControl) {
        _segmentControl = [[MYTitleView  alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.topSegmentControlHeight) with:self.titleArray];
    }
    return _segmentControl;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.scrollViewY, self.scrollViewWidth, self.scrollViewHeight)];
        _scrollView.bounces = false;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.backgroundColor = [UIColor grayColor];
        _scrollView.contentSize = CGSizeMake(3 * self.self.scrollViewWidth, self.scrollViewHeight);
        _scrollView.pagingEnabled = true;
        
        CGPoint sconten = CGPointMake(self.scrollViewWidth, 0);
        _scrollView.contentOffset = sconten;
        
    }
    return _scrollView;
}

- (NSMutableArray *)scrollSubViewsArray
{
    if (!_scrollSubViewsArray) {
        _scrollSubViewsArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _scrollSubViewsArray;
}

@end
