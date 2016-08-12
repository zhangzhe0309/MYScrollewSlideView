//
//  MYScrollviewTitleView.h
//  testScrollerTitleView
//
//  Created by zhangzhe on 16/8/12.
//  Copyright © 2016年 zhangzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYScrollviewTitleView : UIView

@property (nonatomic, copy)     NSArray *titleArray;

- (instancetype)initWithFrame:(CGRect)frame with:(NSArray *)arr;
@end
