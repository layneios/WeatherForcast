//
//  LRWeatherHomeController.h
//  WeatherForcast
//
//  Created by Lorin on 15/10/10.
//  Copyright © 2015年 Lighting-Vista. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LRWeatherHomeController : UIViewController<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

///实时温度
@property (nonatomic, strong) UILabel *currentTemperLabel;

///风力
@property (nonatomic, strong) UILabel *windLabel;

///PM2.5
@property (nonatomic, strong) UILabel *pmLabel;

///城市
@property (nonatomic, strong) UILabel *cityLabel;

///表视图
@property (nonatomic, strong) UITableView *tableView;

///底部的toolBar
@property (nonatomic, strong) UIToolbar *toolBar;

///定位服务
@property (nonatomic, strong) CLLocationManager *locationManager;

@end
