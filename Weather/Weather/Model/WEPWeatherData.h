//
//  WEPWeatherData.h
//  Weather
//
//  Created by Alexander Zakharin on 18.06.14.
//  Copyright (c) 2014 Alexander Zakharin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WEPWeatherData : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSNumber *temp;
@property (nonatomic, strong, readonly) NSNumber *humidity;
@property (nonatomic, strong, readonly) NSNumber *pressure;
@property (nonatomic, strong, readonly) NSNumber *tempMin;
@property (nonatomic, strong, readonly) NSNumber *tempMax;
@property (nonatomic, strong, readonly) NSNumber *windSpeed;
@property (nonatomic, strong, readonly) NSString *weatherMain;
@property (nonatomic, strong, readonly) NSString *weatherIcon;
@property (nonatomic, strong, readonly) NSNumber *cloudinessPercent;
@property (nonatomic, strong, readonly) NSString *keyRain;
@property (nonatomic, strong, readonly) NSNumber *valueRain;
@property (nonatomic, strong, readonly) NSString *keySnow;
@property (nonatomic, strong, readonly) NSNumber *valueSnow;

- (id)initWithData:(NSDictionary *)weatherData;

@end