//
//  WeatherTip.h
//  WeatherForcast
//
//  Created by Lorin on 15/10/10.
//  Copyright © 2015年 Lighting-Vista. All rights reserved.
//  天气建议

#import <Foundation/Foundation.h>

@interface WeatherTip : NSObject

///标题，包括穿衣，旅游，感冒等
@property (nonatomic, copy) NSString *tipTitle;
///程度，如适宜
@property (nonatomic, copy) NSString *tipZs;
///描述
@property (nonatomic, copy) NSString *tipTipt;
///详细
@property (nonatomic, copy) NSString *tipDes;

///初始化方法
- (id)initWithDict:(NSDictionary *)dic;

@end

/*
 *
 {
    "title": "旅游",
    "zs": "适宜",
    "tipt": "旅游指数",
    "des": "天气较好，但丝毫不会影响您出行的心情。温度适宜又有微风相伴，适宜旅游。"
 }
 *
 */
