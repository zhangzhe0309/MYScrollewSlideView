//
//  MYTempView.m
//  testScrollerTitleView
//
//  Created by zhangzhe on 16/8/12.
//  Copyright © 2016年 zhangzhe. All rights reserved.
//

#import "MYTempView.h"

@interface MYTempView ()

@property (nonatomic, strong) UILabel   *textLabel;
@end

@implementation MYTempView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self loadSubviews];
    }
    return self;
}

- (void)loadSubviews
{
    [self addSubview:self.textLabel];
}

- (void)configScrollSubView:(NSString *)string
{
    self.textLabel.text = string;
}


#pragma mark -- getter --

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _textLabel.font = [UIFont systemFontOfSize:40];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor lightGrayColor];
        _textLabel.textColor = [UIColor darkGrayColor];
    }
    return _textLabel;
}

@end
