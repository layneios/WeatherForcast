//
//  LRWeatherHomeController.m
//  WeatherForcast
//
//  Created by Lorin on 15/10/10.
//  Copyright © 2015年 Lighting-Vista. All rights reserved.
//

#import "LRWeatherHomeController.h"
#import "UIView+ITTAdditions.h"
#import "LRWeatherCell.h"
#import "WeatherHttpTool.h"
#import "LRWeatherSearchView.h"
#import "MBProgressHUD+Add.h"

#define KLEFTMARGIN 20      // 左边距
#define KBOTTOMMARGIN 50    // 下边距

@interface LRWeatherHomeController ()
{
    UIImageView *_bgImageView;      // 底层的图片
    NSArray *_forcastData;          // 天气预报数据数组
}

@property (nonatomic, strong) LRWeatherSearchView *searchView;

@end

@implementation LRWeatherHomeController

- (void)loadView
{
    // 将背景设置为一张图片
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.frame = [UIScreen mainScreen].bounds;
    bgImageView.image = [UIImage imageNamed: @"cloud.jpg"];
    _bgImageView = bgImageView;
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.clipsToBounds = YES;
    _bgImageView.userInteractionEnabled = YES;
    self.view = _bgImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 搭建UI
    [self buildUI];
    
    // 判断是否有默认城市
    if([WeatherDataTool getCitySaved]) {
        [self freshData: [WeatherDataTool getCitySaved]];
    } else {
        [self getMyCurrentLocation];
    }
}

#pragma mark - 修改状态栏为白色
/*
 * 状态栏白色
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 搭建UI
/*
 * 界面显示控件初始化
 */
- (void)buildUI
{
    // 实时温度
    [self.view addSubview: self.currentTemperLabel];
    // 风力
    [self.view addSubview: self.windLabel];
    // PM2.5
    [self.view addSubview: self.pmLabel];
    // 城市
    [self.view addSubview: self.cityLabel];
    // 表视图
    [self.view addSubview: self.tableView];
    // 工具栏
    [self.view addSubview: self.toolBar];
}

/*
 * 实时温度
 */
- (UILabel *)currentTemperLabel
{
    if(!_currentTemperLabel) {
        _currentTemperLabel = [[UILabel alloc] init];
        // 计算高度
        NSString *temperStr = @"25°";
        CGRect temperRect = [temperStr boundingRectWithSize: CGSizeMake(self.view.width-KLEFTMARGIN*2, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName:[UIFont systemFontOfSize: 60.f]} context: nil];
        _currentTemperLabel.frame = CGRectMake(KLEFTMARGIN, KLEFTMARGIN*2, self.view.width-KLEFTMARGIN*2, temperRect.size.height);
        _currentTemperLabel.font = [UIFont systemFontOfSize: 60.f];
        _currentTemperLabel.textColor = [UIColor whiteColor];
    }
    
    return _currentTemperLabel;
}

/*
 * 风力
 */
- (UILabel *)windLabel
{
    if(!_windLabel) {
        _windLabel = [[UILabel alloc] init];
        _windLabel.frame = CGRectMake(KLEFTMARGIN, self.currentTemperLabel.bottom+KLEFTMARGIN, self.currentTemperLabel.width, 30);
        _windLabel.textColor = [UIColor whiteColor];
    }
    
    return _windLabel;
}

/*
 * PM2.5
 */
- (UILabel *)pmLabel
{
    if(!_pmLabel) {
        _pmLabel = [[UILabel alloc] init];
        _pmLabel.frame = CGRectMake(KLEFTMARGIN, self.windLabel.bottom+KLEFTMARGIN, self.windLabel.width, 30);
        _pmLabel.textColor = [UIColor whiteColor];
    }
    
    return _pmLabel;
}

/*
 * 城市
 */
- (UILabel *)cityLabel
{
    if(!_cityLabel) {
        _cityLabel = [[UILabel alloc] init];
        _cityLabel.frame = CGRectMake(KLEFTMARGIN, self.pmLabel.bottom+KLEFTMARGIN, self.pmLabel.width, 30);
        _cityLabel.font = [UIFont systemFontOfSize: 23.f];
        _cityLabel.textColor = [UIColor whiteColor];
    }
    
    return _cityLabel;
}

/*
 * 表视图
 */
- (UITableView *)tableView
{
    if(!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0, self.view.height-44*4-KBOTTOMMARGIN, self.view.width, 44*4);
        _tableView.allowsSelection = NO;
        _tableView.scrollEnabled = NO;
        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

/*
 * toolBar
 */
- (UIToolbar *)toolBar
{
    if(!_toolBar) {
        _toolBar = [[UIToolbar alloc] init];
        _toolBar.frame = CGRectMake(0, self.view.height-KBOTTOMMARGIN, self.view.width, KBOTTOMMARGIN);
        // 设置toolBar的内容
        UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithTitle: @"定位" style: UIBarButtonItemStylePlain target: self action: @selector(toolBarItemAction:)];
        item0.tag = 0;
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle: @"切换城市" style: UIBarButtonItemStylePlain target: self action: @selector(toolBarItemAction:)];
        item1.tag = 1;
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle: @"设为默认城市" style: UIBarButtonItemStylePlain target: self action: @selector(toolBarItemAction:)];
        item2.tag = 2;
        UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle: @"刷新" style: UIBarButtonItemStylePlain target: self action: @selector(toolBarItemAction:)];
        item3.tag = 3;
        
        [_toolBar setItems: @[item0, item1, item2, item3] animated: YES];
    }
    
    return _toolBar;
}

/*
 * searchView
 */
- (LRWeatherSearchView *)searchView
{
    if(!_searchView) {
        _searchView = [[LRWeatherSearchView alloc] init];
        _searchView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        
        // 确认按钮点击后，搜索
        __block LRWeatherHomeController *blockSelf = self;
        _searchView.sureButtonBlock = ^(LRWeatherSearchView *searchView, NSString *city) {
            [blockSelf freshData: city];
            [searchView closeView];
        };
    }
    
    return _searchView;
}

#pragma mark - 底部按钮点击事件
- (void)toolBarItemAction:(UIBarButtonItem *)barItem
{
    switch (barItem.tag) {
        case 0:
        {
            // 定位
            [self getMyCurrentLocation];
        }
            break;
            
        case 1:
        {
            // 切换城市
            [self.searchView showInView: self.view];
        }
            break;
            
        case 2:
        {
            // 设为默认城市
            [WeatherDataTool saveCity: self.cityLabel.text];
            [MBProgressHUD showText: @"设置成功" toView: self.view];

        }
            break;
            
        case 3:
        {
            // 刷新
            [self freshData: self.cityLabel.text];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 数据填充
- (void)freshData:(NSString *)city
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [WeatherHttpTool getWeatherWithCity: city completionHandr:^(id responseObject) {
        WeatherResult *result = responseObject;
        // 停止定位
        [_locationManager stopUpdatingLocation];
        // 界面显示更新
        [self updateInfoWithData:(result)];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } error:^(NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [MBProgressHUD showText: @"请求失败" toView: self.view];
        [_locationManager stopUpdatingLocation];
    }];
}

/*
 * 有数据之后，界面显示更新
 */
- (void)updateInfoWithData:(WeatherResult *)result
{
    // 城市名
    self.cityLabel.text = result.cityName;
    // pm2.5
    self.pmLabel.text = result.pm25;
    // 实时温度
    WeatherData *todayData = result.weatherDatas[0];
    self.currentTemperLabel.text = todayData.weatherCurrentTemper;
    // 风力
    self.windLabel.text = todayData.weatherWind;
    // 表格里面的天气预报
    _forcastData = result.weatherDatas;
    // 背景变
    WeatherData *weather = _forcastData[0];
    if([weather.weatherDes rangeOfString: @"雨"].location != NSNotFound) {
        _bgImageView.image = [UIImage imageNamed: @"rain.jpg"];
    } else if([weather.weatherDes rangeOfString: @"阴"].location != NSNotFound) {
        _bgImageView.image = [UIImage imageNamed: @"cloud.jpg"];
    } else if([weather.weatherDes rangeOfString: @"云"].location != NSNotFound) {
        _bgImageView.image = [UIImage imageNamed: @"cloud.jpg"];
    } else if([weather.weatherDes rangeOfString: @"晴"].location != NSNotFound) {
        _bgImageView.image = [UIImage imageNamed: @"sun.jpg"];
    } else {
        _bgImageView.image = [UIImage imageNamed: @"cloud.jpg"];
    }
    // 刷新表格
    [self.tableView reloadData];
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _forcastData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    LRWeatherCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if(cell == nil) {
        cell = [[LRWeatherCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    
    [cell setItem: _forcastData[indexPath.row]];
    
    return cell;
}

#pragma mark - 定位功能
- (void)getMyCurrentLocation
{
    [self.locationManager startUpdatingLocation];
}

- (CLLocationManager *)locationManager
{
    if(!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    }
    
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations firstObject];
    // 停止定位
    //[_locationManager stopUpdatingLocation];
    
    // 查询位置
    [WeatherHttpTool getCurrentLocationCityName: location.coordinate.longitude latitude: location.coordinate.latitude completionHandr:^(id responseObject) {
        // 获取天气
        [self freshData: responseObject];
    } failed:^(NSError *error) {
        [MBProgressHUD showText: @"定位失败" toView: self.view];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
