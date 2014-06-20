//
//  WEPLocationManager.h
//  Weather
//
//  Created by Alexander Zakharin on 18.06.14.
//  Copyright (c) 2014 Alexander Zakharin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define WEPNotificationCoordinatesDidUpdate @"WEPNotificationCoordinatesDidUpdate"

@interface WEPLocationManager : NSObject

@property (nonatomic, strong, readonly) CLLocation* currentLocation;
@property (nonatomic, strong, readonly) NSError* error;

+ (WEPLocationManager*)sharedSingleton;
- (void)getCurrentLocation;

@end
