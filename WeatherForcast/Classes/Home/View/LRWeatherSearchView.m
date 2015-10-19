//
//  LRWeatherSearchView.m
//  WeatherForcast
//
//  Created by Lorin on 15/10/15.
//  Copyright © 2015年 Lighting-Vista. All rights reserved.
//

#import "LRWeatherSearchView.h"
#import "UIView+ITTAdditions.h"

@implementation LRWeatherSearchView
{
    UIView *controlView;  // 放控件的视图
    
    UITextField *txtInputView;
    UIButton *sureBtn;
}

- (instancetype)init
{
    self = [super init];
    if(self) {
        self.backgroundColor = [UIColor colorWithWhite: 0 alpha: 0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        tap.numberOfTapsRequired = 1;
        [tap addTarget: self action: @selector(closeView)];
        [self addGestureRecognizer: tap];
        
        controlView = [[UIView alloc] init];
        controlView.backgroundColor = [UIColor lightGrayColor];
        
        [self addSubview: controlView];
        
        // 输入框
        txtInputView = [[UITextField alloc] init];
        txtInputView.backgroundColor = [UIColor whiteColor];
        // 设置键盘确认键
        txtInputView.returnKeyType = UIReturnKeyDone;
        txtInputView.delegate = self;
        [controlView addSubview: txtInputView];
        
        // 搜索按钮
        sureBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        sureBtn.layer.cornerRadius = 5;
        sureBtn.layer.masksToBounds = YES;
        [sureBtn setTitle: @"确定" forState: UIControlStateNormal];
        [sureBtn addTarget: self action: @selector(sureButtonAction) forControlEvents: UIControlEventTouchUpInside];
        sureBtn.backgroundColor = [UIColor grayColor];
        [controlView addSubview: sureBtn];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    controlView.frame = CGRectMake(0, 0, frame.size.width, 100);
    txtInputView.frame = CGRectMake(15, 20+15, controlView.frame.size.width-100-30, 44);
    sureBtn.frame = CGRectMake(controlView.frame.size.width-15-80, 20+15, 80, 44);
}

///显示
- (void)showInView:(UIView *)view
{
    // 蒙版渐出
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromBottom;
    [controlView.layer addAnimation: animation forKey: nil];
    [view addSubview: self];
    controlView.hidden = NO;
    
    // 出现的时候，清空文字
    txtInputView.text = @"";
    [txtInputView becomeFirstResponder];
}

///隐藏
- (void)closeView
{
    [txtInputView resignFirstResponder];
    controlView.hidden = YES;
    [self removeFromSuperview];
}

///确认键点击事件
- (void)sureButtonAction
{
    if(self.sureButtonBlock) {
        self.sureButtonBlock(self, txtInputView.text);
    }
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(self.sureButtonBlock) {
        self.sureButtonBlock(self, txtInputView.text);
    }
    return YES;
}

@end
