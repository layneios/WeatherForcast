//
//  WeatherHttpTool.h
//  WeatherForcast
//
//  Created by Lorin on 15/10/10.
//  Copyright © 2015年 Lighting-Vista. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "WeatherResult.h"

typedef void (^HttpSuccessBlock)(id responseObject);
typedef void (^HttpFailureBlock)(NSError *error);

@interface WeatherHttpTool : NSObject

// 直接返回JSON数据的请求
//+ (void)getRequestWithUrlStr:(NSString *)urlStr parameters:(id)parameters completionHandr:(HttpSuccessBlock)sucess error:(HttpFailureBlock)failed;

///根据城市名查询天气
+ (void)getWeatherWithCity:(NSString *)cityName completionHandr:(HttpSuccessBlock)success error:(HttpFailureBlock)failed;

///百度反Geo，根据经纬度查询位置
+ (void)getCurrentLocationCityName:(double)lontitude latitude:(double)latitude completionHandr:(HttpSuccessBlock)success failed:(HttpFailureBlock)failed;

@end


///////////////数据归档
@interface WeatherDataTool : NSObject

///保存城市名到沙盒
+ (void)saveCity:(NSString *)city;

///从沙盒里取出城市
+ (NSString *)getCitySaved;

@end