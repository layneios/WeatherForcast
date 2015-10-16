//
//  LRWeatherCell.h
//  WeatherForcast
//
//  Created by Lorin on 15/10/10.
//  Copyright © 2015年 Lighting-Vista. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherData;

@interface LRWeatherCell : UITableViewCell

///日期
@property (nonatomic, strong) UILabel *dateLabel;
///天气
@property (nonatomic ,strong) UILabel *weatherLabel;
///温度
@property (nonatomic, strong) UILabel *temperLabel;
///小图片
@property (nonatomic, strong) UIImageView *imgView;

///设置cell数据
- (void)setItem:(WeatherData *)data;

@end
