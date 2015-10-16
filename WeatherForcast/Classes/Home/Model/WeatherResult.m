//
//  WeatherResult.m
//  WeatherForcast
//
//  Created by Lorin on 15/10/12.
//  Copyright © 2015年 Lighting-Vista. All rights reserved.
//

#import "WeatherResult.h"

@implementation WeatherResult

- (id)initWithDict:(NSDictionary *)dic
{
    self = [super init];
    if(self) {
        // 城市名
        self.cityName = dic[@"currentCity"];
        // 计算pm2.5
        if([dic[@"pm25"] integerValue] <= 50) {
            self.pm25 = @"空气质量：优";
        } else if([dic[@"pm25"] integerValue] <= 100) {
            self.pm25 = @"空气质量：良";
        } else if([dic[@"pm25"] integerValue] <= 150) {
            self.pm25 = @"空气质量：轻度污染";
        } else if([dic[@"pm25"] integerValue] <= 200) {
            self.pm25 = @"空气质量：中度污染";
        } else if([dic[@"pm25"] integerValue] <= 300) {
            self.pm25 = @"空气质量：重度污染";
        } else {
            self.pm25 = @"空气质量：严重污染";
        }
        
        // 取出天气建议
        _weatherTips = [NSMutableArray array];
        for(int i=0;i<[dic[@"index"] count];i++) {
            WeatherTip *tip = [[WeatherTip alloc] initWithDict: dic[@"index"][i]];
            [_weatherTips addObject: tip];
        }
        
        // 取出未来天气预报
        _weatherDatas = [NSMutableArray array];
        for(int i=0;i<[dic[@"weather_data"] count];i++) {
            WeatherData *data = [[WeatherData alloc] initWithDict: dic[@"weather_data"][i]];
            [_weatherDatas addObject: data];
        }
    }
    
    return self;
}

@end
