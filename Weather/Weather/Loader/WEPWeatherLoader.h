//
//  WEPWeatherLoader.h
//  Weather
//
//  Created by Alexander Zakharin on 18.06.14.
//  Copyright (c) 2014 Alexander Zakharin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <P34Utils.h>

@interface WEPWeatherLoader : NSObject

- (void)loadWeatherByLocation:(CLLocation *)location andWithAction:(IdBlock)action;
- (void)loadWeatherByNameCyty:(NSString *)cityNameString andWithAction:(IdBlock)action;

@end
