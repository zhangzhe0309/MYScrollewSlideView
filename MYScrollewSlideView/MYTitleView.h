//
//  MYTitleView.h
//  testScrollerTitleView
//
//  Created by zhangzhe on 16/8/12.
//  Copyright © 2016年 zhangzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^titeClickBlock) (NSInteger index);

@interface MYTitleView : UIView

@property (nonatomic, strong) NSMutableArray    *titleArr;
@property (nonatomic, copy)   titeClickBlock clickBlock;

- (instancetype)initWithFrame:(CGRect)frame with:(NSArray *)arr;
- (void)changeMaskX:(CGFloat)x;
@end
