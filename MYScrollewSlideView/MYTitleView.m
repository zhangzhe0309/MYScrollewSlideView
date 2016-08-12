//
//  MYTitleView.m
//  testScrollerTitleView
//
//  Created by zhangzhe on 16/8/12.
//  Copyright © 2016年 zhangzhe. All rights reserved.
//

#import "MYTitleView.h"

typedef NS_ENUM(NSInteger) {
    BackgroundLabel   =0,
    BeforeLabel
    
} LabelTypecolor;

@interface MYTitleView ()
@property (nonatomic, strong) UIView    *beforeView;
@property (nonatomic, strong) UIView    *backroundView;
@property (nonatomic, strong) CALayer   *maskLayer;

@end

@implementation MYTitleView

- (instancetype)initWithFrame:(CGRect)frame with:(NSArray *)arr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleArr = arr.copy;
        [self loadViews];
    }
    return self;
}

- (void)loadViews
{
    [self addBackgoundView];
    [self addBeforView];
    [self addMaskForBeforeView];
    [self addTopButtons];
}

- (void)addBackgoundView
{
    [self addSubview:self.backroundView];
    [self addLabel:BackgroundLabel];
}

- (void)addBeforView
{
    [self addSubview:self.beforeView];
    [self addLabel:BeforeLabel];
}

- (void)addMaskForBeforeView
{
    self.maskLayer = [[CALayer alloc] init];
    self.maskLayer.frame = [self getSubViewFrame:0];
    self.maskLayer.cornerRadius = 25;
    self.maskLayer.backgroundColor = [UIColor redColor].CGColor;
    self.beforeView.layer.mask = self.maskLayer;
}

- (void)addTopButtons
{
    for (NSInteger i = 0; i < self.titleArr.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button .tag = i;
        button.frame = [self getSubViewFrame:i];
        [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (CGRect )getSubViewFrame:(NSInteger)index
{
    CGFloat subWidth = self.bounds.size.width / [@(self.titleArr.count) floatValue];
    return CGRectMake(index * subWidth , 0, subWidth, self.bounds.size.height);
}

- (void)addLabel:(LabelTypecolor)type
{
    UIView  *superview;
    UIColor *textColor;
    switch (type) {
        case BackgroundLabel:{
            textColor = [UIColor blackColor];
            superview = self.backroundView;
        }
            break;
        case BeforeLabel:{
            textColor  = [UIColor whiteColor];
            superview = self.beforeView;
        }
            break;
        default:
            break;
    }
    
    
    for (NSInteger i =0 ; i < self.titleArr.count ; i ++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:[self getSubViewFrame:i]];
        lab.text = self.titleArr[i];
        lab.font = [UIFont systemFontOfSize:18.0];
        lab.textAlignment = NSTextAlignmentCenter;
        [superview addSubview:lab];
    }
    
}

- (void)tapButton:(UIButton *)button
{
    if (self.clickBlock) {
        self.clickBlock(button.tag);
    }
    self.maskLayer.frame = [self getSubViewFrame:button.tag];
}

- (void)changeMaskX:(CGFloat)x
{
    CGFloat subWidth = self.bounds.size.width / [@(self.titleArr.count) floatValue];
    if (x >= 0 && x <= self.frame.size.width - subWidth) {
        CGRect frmame = self.maskLayer.frame;
        frmame.origin.x = x;
        self.maskLayer.frame = frmame;
    }
}

#pragma mark -- getter --

- (UIView *)beforeView
{
    if (!_beforeView) {
        _beforeView = [[UIView alloc] initWithFrame:self.bounds];
        _beforeView.backgroundColor = [UIColor redColor];
    }
    return _beforeView;
}

- (UIView *)backroundView
{
    if (!_backroundView) {
        _backroundView =[[UIView alloc] initWithFrame:self.bounds];
    }
    return _backroundView;
}

@end
