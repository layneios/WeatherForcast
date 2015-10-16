//
//  WeatherResult.h
//  WeatherForcast
//
//  Created by Lorin on 15/10/12.
//  Copyright © 2015年 Lighting-Vista. All rights reserved.
//  天气结果

#import <Foundation/Foundation.h>
#import "WeatherTip.h"
#import "WeatherData.h"

@interface WeatherResult : NSObject

///城市名
@property (nonatomic, copy) NSString *cityName;
///pm2.5
@property (nonatomic, copy) NSString *pm25;
///天气建议
@property (nonatomic, readonly) NSMutableArray *weatherTips;
///未来天气预报
@property (nonatomic, readonly) NSMutableArray *weatherDatas;

///初始化方法
- (id)initWithDict:(NSDictionary *)dic;

@end
