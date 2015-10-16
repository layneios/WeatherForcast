//
//  LRWeatherSearchView.h
//  WeatherForcast
//
//  Created by Lorin on 15/10/15.
//  Copyright © 2015年 Lighting-Vista. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LRWeatherSearchView;
typedef void (^SearchSureBlock)(LRWeatherSearchView *searchView, NSString *city);

@interface LRWeatherSearchView : UIView

@property (nonatomic, strong) SearchSureBlock sureButtonBlock;

///显示视图
- (void)showInView:(UIView *)view;

///关闭视图
- (void)closeView;

@end
