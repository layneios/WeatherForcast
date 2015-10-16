//
//  LRWeatherCell.m
//  WeatherForcast
//
//  Created by Lorin on 15/10/10.
//  Copyright © 2015年 Lighting-Vista. All rights reserved.
//

#import "LRWeatherCell.h"
#import "UIView+ITTAdditions.h"
#import "WeatherData.h"
#import "UIImageView+AFNetworking.h"

#define kWidth(x) ((x/320.0)*self.frame.size.width)

@implementation LRWeatherCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.dateLabel = [[UILabel alloc] init];
        self.weatherLabel = [[UILabel alloc] init];
        self.temperLabel = [[UILabel alloc] init];
        self.imgView = [[UIImageView alloc] init];
        
        [self.contentView addSubview: self.dateLabel];
        [self.contentView addSubview: self.weatherLabel];
        [self.contentView addSubview: self.temperLabel];
        [self.contentView addSubview: self.imgView];
        
        self.backgroundColor = [UIColor colorWithWhite: 0 alpha: 0.2];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.dateLabel.frame = CGRectMake(10, 0, kWidth(80), self.contentView.frame.size.height);
    self.weatherLabel.frame = CGRectMake(self.dateLabel.right+5, 0, kWidth(90), self.contentView.frame.size.height);
    self.temperLabel.frame = CGRectMake(self.weatherLabel.right+5, 0, kWidth(90), self.contentView.frame.size.height);
    // 图片的尺寸为42*30
    self.imgView.frame = CGRectMake(self.temperLabel.right+5, (self.contentView.frame.size.height-15)*0.5, 21, 15);
    
    [_dateLabel setFont: [UIFont systemFontOfSize: 14.f]];
    [_weatherLabel setFont: [UIFont systemFontOfSize: 15.f]];
    [_temperLabel setFont: [UIFont systemFontOfSize: 15.f]];
    
    [_dateLabel setTextColor: [UIColor whiteColor]];
    [_weatherLabel setTextColor: [UIColor whiteColor]];
    [_temperLabel setTextColor: [UIColor whiteColor]];
}

- (void)setItem:(WeatherData *)data
{
    self.dateLabel.text = data.weatherDate;
    self.weatherLabel.text = data.weatherDes;
    self.temperLabel.text = data.weatherTemper;
    __block LRWeatherCell *blockSelf = self;
    [self.imgView setImageWithURLRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: [data picUrl]]] placeholderImage: nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, UIImage * _Nonnull image) {
        blockSelf.imgView.image = image;
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSError * _Nonnull error) {
        
    }];
}

@end
