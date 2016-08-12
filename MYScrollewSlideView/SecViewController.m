//
//  SecViewController.m
//  testScrollerTitleView
//
//  Created by zhangzhe on 16/8/12.
//  Copyright © 2016年 zhangzhe. All rights reserved.
//

#import "SecViewController.h"
#import "MYScrollviewTitleView.h"

@implementation SecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    CGRect frmak = CGRectMake(10, 60, 350, 465);
    NSArray * a = @[@"AAA",@"BBB",@"CCC",@"dddd"];
    MYScrollviewTitleView *scrollre = [[MYScrollviewTitleView alloc] initWithFrame:frmak with:a];
    [self.view addSubview:scrollre];
}

@end
