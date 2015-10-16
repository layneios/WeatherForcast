//
//  WeatherData.m
//  WeatherForcast
//
//  Created by Lorin on 15/10/10.
//  Copyright © 2015年 Lighting-Vista. All rights reserved.
//

#import "WeatherData.h"

@implementation WeatherData

- (id)initWithDict:(NSDictionary *)dic
{
    self = [super init];
    if(self) {
        NSString *date = dic[@"date"];
        if(date.length >= 16) {
            // 今天，有实时温度
            // 取出日期
            self.weatherDate = [[date substringToIndex: 2] stringByAppendingString: @"  今天"];
            // 取出实时温度
            self.weatherCurrentTemper = [[date substringWithRange: NSMakeRange(14, 2)] stringByAppendingString: @"°"];
        } else {
            self.weatherDate = date;
            self.weatherCurrentTemper = nil;
        }
        self.weatherDayPic = dic[@"dayPictureUrl"];
        self.weatherNightPic = dic[@"nightPictureUrl"];
        self.weatherDes = dic[@"weather"];
        self.weatherWind = dic[@"wind"];
        self.weatherTemper = dic[@"temperature"];
        
        /*
         * [self setValuesForKeysWithDictionary: dic];可以直接将键值与字典里的对应，无需写上面的代码
         */
    }
    
    return self;
}

/**
 * @brief 判断当前时间是否在fromHour和toHour之间。如，fromHour=8，toHour=23时，即为判断当前时间是否在8:00-23:00之间
 */
- (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour
{
    NSDate *dateFrom = [self getCustomDateWithHour:fromHour];
    NSDate *dateTo = [self getCustomDateWithHour:toHour];
    
    NSDate *currentDate = [NSDate date];
    
    if ([currentDate compare: dateFrom]==NSOrderedDescending && [currentDate compare:dateTo]==NSOrderedAscending)
    {
        return YES;
    }
    return NO;
}

/**
 * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 * @param hour 如hour为“8”，就是上午8:00（本地时间）
 */
- (NSDate *)getCustomDateWithHour:(NSInteger)hour
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:[currentComps hour]];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}

- (NSString *)picUrl
{
    // 判断是否在6点到18点之间
    if([self isBetweenFromHour: 6 toHour: 18]) {
        // 获取的时间是UTC，所以倒转过来
        return self.weatherNightPic;
    } else {
        return self.weatherDayPic;
    }
}

@end
