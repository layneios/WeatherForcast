//
//  WeatherHttpTool.m
//  WeatherForcast
//
//  Created by Lorin on 15/10/10.
//  Copyright © 2015年 Lighting-Vista. All rights reserved.
//

#import "WeatherHttpTool.h"
#import "WeatherConstant.h"

@implementation WeatherHttpTool

+ (void)getRequestWithUrlStr:(NSString *)urlStr parameters:(id)parameters completionHandr:(HttpSuccessBlock)sucess error:(HttpFailureBlock)failed
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest: [[AFJSONRequestSerializer serializer] requestWithMethod: @"GET" URLString: urlStr parameters: parameters error: nil] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            failed(error);
        } else {
            sucess(responseObject);
        }
    }];
    
    [dataTask resume];
}

+ (void)getWeatherWithCity:(NSString *)cityName completionHandr:(HttpSuccessBlock)success error:(HttpFailureBlock)failed
{
    [self getRequestWithUrlStr: kGetWeather_URL([cityName stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet whitespaceAndNewlineCharacterSet]]) parameters: nil completionHandr:^(id responseObject) {
        // 数据处理
        if([responseObject[@"status"] isEqualToString: @"success"]) {
            // 成功
            WeatherResult *result = [[WeatherResult alloc] initWithDict: responseObject[@"results"][0]];
            success(result);
        } else {
            // 失败
            // 发送失败信息
            NSError *error = [NSError errorWithDomain: responseObject[@"status"] code: [responseObject[@"error"] integerValue] userInfo: nil];
            failed(error);
        }
    } error:^(NSError *error) {
        if(error) {
            failed(error);
        }
    }];
}

+ (void)getCurrentLocationCityName:(double)lontitude latitude:(double)latitude completionHandr:(HttpSuccessBlock)success failed:(HttpFailureBlock)failed
{
    [self getRequestWithUrlStr: kGetCityNameByPositionUrl(lontitude, latitude) parameters: nil completionHandr:^(id responseObject) {
        // 成功
        NSString *city = responseObject[@"city"];
        success(city);
    } error:^(NSError *error) {
        if(error) {
            failed(error);
        }
    }];
}

@end



///////////////数据归档
@implementation WeatherDataTool

// 保存城市名到沙盒
+ (void)saveCity:(NSString *)city
{
    //保存城市名
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    if(!docDir) {
        NSLog(@"Documents 目录未找到");
    }
    NSArray *array = [[NSArray alloc] initWithObjects: city,nil];
    NSString *filePath = [docDir stringByAppendingPathComponent: @"city.plist"];
    [array writeToFile:filePath atomically:YES];
}

// 从沙盒里取出城市
+ (NSString *)getCitySaved
{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:@"city.plist"];
    NSArray *array = [[NSArray alloc]initWithContentsOfFile:filePath];
    
    if(array[0]) {
        NSString *cityName = [NSString stringWithFormat: @"%@", array[0]];
        return cityName;
    } else {
        return nil;
    }
}

@end
