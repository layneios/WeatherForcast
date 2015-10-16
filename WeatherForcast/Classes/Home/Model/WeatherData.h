//
//  WeatherData.h
//  WeatherForcast
//
//  Created by Lorin on 15/10/10.
//  Copyright © 2015年 Lighting-Vista. All rights reserved.
//  天气状况

#import <Foundation/Foundation.h>

@interface WeatherData : NSObject

///日期
@property (nonatomic, copy) NSString *weatherDate;
///白天的天气图片
@property (nonatomic, copy) NSString *weatherDayPic;
///晚上的天气图片
@property (nonatomic, copy) NSString *weatherNightPic;
///天气状况
@property (nonatomic, copy) NSString *weatherDes;
///风力
@property (nonatomic, copy) NSString *weatherWind;
///温度
@property (nonatomic, copy) NSString *weatherTemper;
///实时温度
@property (nonatomic, copy) NSString *weatherCurrentTemper;

///初始化方法
- (id)initWithDict:(NSDictionary *)dic;

///根据时间获取图片地址（白天和晚上不同）
- (NSString *)picUrl;

@end

/*
 *
 {
    "date": "周六 10月10日 (实时：19℃)",
    "dayPictureUrl": "http://api.map.baidu.com/images/weather/day/duoyun.png",
    "nightPictureUrl": "http://api.map.baidu.com/images/weather/night/duoyun.png",
    "weather": "多云",
    "wind": "微风",
    "temperature": "24 ~ 11℃"
 }
 *
*/