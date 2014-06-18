//
//  WEPWeatherData.m
//  Weather
//
//  Created by Alexander Zakharin on 18.06.14.
//  Copyright (c) 2014 Alexander Zakharin. All rights reserved.
//

#import "WEPWeatherData.h"

@interface WEPWeatherData ()

@property (nonatomic, strong) NSString *namePlace;
@property (nonatomic, strong) NSNumber *temp;
@property (nonatomic, strong) NSNumber *humidity;
@property (nonatomic, strong) NSNumber *pressure;
@property (nonatomic, strong) NSNumber *tempMin;
@property (nonatomic, strong) NSNumber *tempMax;
@property (nonatomic, strong) NSNumber *windSpeed;
@property (nonatomic, strong) NSString *weatherMain;
@property (nonatomic, strong) NSString *weatherIcon;
@property (nonatomic, strong) NSNumber *cloudinessPercent;
@property (nonatomic, strong) NSString *keyRain;
@property (nonatomic, strong) NSNumber *valueRain;
@property (nonatomic, strong) NSString *keySnow;
@property (nonatomic, strong) NSNumber *valueSnow;

@end

@implementation WEPWeatherData

- (id)initWithData:(NSDictionary *)weatherData {
    
  	if((self = [super init])) {
        [self parseWithData:weatherData];
	}
	
	return self;
}

- (void)parseWithData:(NSDictionary *)weatherData {
    
    NSArray *listData = [weatherData valueForKey:@"list"];
    NSDictionary *data = listData.firstObject;
    
    self.namePlace = [data valueForKey:@"name"];
    
    NSDictionary *main = [data valueForKey:@"main"];
    if (main) {
        self.temp =  [NSNumber numberWithFloat:[[main valueForKey:@"temp"] floatValue]];
        self.humidity = [NSNumber numberWithFloat:[[main valueForKey:@"humidity"] floatValue]];
        self.pressure = [NSNumber numberWithFloat:[[main valueForKey:@"pressure"] floatValue]];
        self.tempMax = [NSNumber numberWithFloat:[[main valueForKey:@"temp_max"] floatValue]];
        self.tempMin = [NSNumber numberWithFloat:[[main valueForKey:@"temp_min"] floatValue]];
    }
    
    NSDictionary *wind = [data valueForKey:@"wind"];
    if (wind) {
        self.windSpeed = [NSNumber numberWithFloat:[[wind valueForKey:@"speed"] floatValue]];
    }

    NSArray *weatherArray = [data valueForKey:@"weather"];
    if (weatherArray.count > 0) {
        if ([weatherArray.firstObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *weather = (NSDictionary *)weatherArray.firstObject;
            if (weather) {
                self.weatherIcon = [weather valueForKey:@"icon"];
                self.weatherMain = [weather valueForKey:@"main"];
            }
        }
    }
    
    NSDictionary *clouds = [data valueForKey:@"clouds"];
    if (clouds) {
        self.cloudinessPercent = [NSNumber numberWithFloat:[[clouds valueForKey:@"all"] floatValue]];
    }
    
    NSDictionary *rain = [data valueForKey:@"rain"];
    if (rain) {
        NSArray *keyInRainArray = rain.allKeys;
        self.keyRain = keyInRainArray.firstObject;
        self.valueRain = [rain valueForKey:self.keyRain];
    }
    
    NSDictionary *snow = [data valueForKey:@"snow"];
    if (snow) {
        NSArray *keyInSnowArray = snow.allKeys;
        self.keySnow = keyInSnowArray.firstObject;
        self.valueSnow = [snow valueForKey:self.keySnow];
    }
}

@end
