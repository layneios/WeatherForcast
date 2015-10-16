//
//  WeatherConstant.h
//  WeatherForcast
//
//  Created by Lorin on 15/10/10.
//  Copyright © 2015年 Lighting-Vista. All rights reserved.
//

#ifndef WeatherConstant_h
#define WeatherConstant_h

/*
 * 百度天气key
 */
#define kBDWeather_KEY @"17IvzuqmKrK1cGwNL6VQebF9"

/*
 * 获取天气
 */
#define kGetWeather_URL(city) ([NSString stringWithFormat: @"http://api.map.baidu.com/telematics/v3/weather?location=%@&output=json&ak=%@", city, kBDWeather_KEY])

/*
 * 反Geocoding
 */
#define kGetCityNameByPositionUrl(lontitude,latitude) ([NSString stringWithFormat: @"http://api.map.baidu.com/telematics/v3/reverseGeocoding?location=%f,%f&output=json&coord_type=gcj02&ak=%@", lontitude, latitude, kBDWeather_KEY])

#endif /* WeatherConstant_h */
