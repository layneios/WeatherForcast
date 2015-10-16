//
//  WeatherTip.m
//  WeatherForcast
//
//  Created by Lorin on 15/10/10.
//  Copyright © 2015年 Lighting-Vista. All rights reserved.
//

#import "WeatherTip.h"

@implementation WeatherTip

- (id)initWithDict:(NSDictionary *)dic
{
    self = [super init];
    if(self) {
        self.tipTitle = dic[@"title"];
        self.tipZs = dic[@"zs"];
        self.tipTipt = dic[@"tipt"];
        self.tipDes = dic[@"des"];
    }
    
    return self;
}

@end
