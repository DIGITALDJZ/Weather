//
//  WEPLocationManager.m
//  Weather
//
//  Created by Alexander Zakharin on 18.06.14.
//  Copyright (c) 2014 Alexander Zakharin. All rights reserved.
//

#import "WEPLocationManager.h"

NSString *const WEPNotificationCoordinatesDidUpdate = @"WEPNotificationCoordinatesDidUpdate";

@interface WEPLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation* currentLocation;
@property (nonatomic, strong) NSError* error;

@end

@implementation WEPLocationManager

- (id)init
{
    self = [super init];
    if(self) {
        self.locationManager = [CLLocationManager new];
        [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
        [self.locationManager setHeadingFilter:kCLHeadingFilterNone];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
    }
    return self;
}

+ (WEPLocationManager*)sharedSingleton
{
    static WEPLocationManager* sharedSingleton;
    if(!sharedSingleton) {
        @synchronized(sharedSingleton) {
            sharedSingleton = [WEPLocationManager new];
        }
    }
    return sharedSingleton;
}

- (void)getCurrentLocation
{
    self.error = nil;
    self.currentLocation = nil;
    [self.locationManager setDelegate:self];
    [self.locationManager startUpdatingLocation];
}

- (void)stopGettingCurrentLocation {
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if (![newLocation.timestamp timeIntervalSinceNow] > -600.0) {// check recent coordinates or coordinates of the cache
        [self stopGettingCurrentLocation];
        self.currentLocation = newLocation;
        [self sendNotificationCoordinatesDidUpdate];
    }
}

- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error {
    
    [self stopGettingCurrentLocation];
    self.error = error;
    [self sendNotificationCoordinatesDidUpdate];
    
//    switch([error code])
//    {
//        case kCLErrorNetwork:
//        {
////            [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_LOCATION_ERROR object:ERROR_NETWORK];
//        }
//            break;
//        case kCLErrorDenied:{
////            [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_LOCATION_ERROR object:ERROR_ACCESS];
//        }
//            break;
//        default:
//        {
////            [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_LOCATION_ERROR object:ERROR_NETWORK];
//        }
//            break;
//    }
}

- (void)sendNotificationCoordinatesDidUpdate {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WEPNotificationCoordinatesDidUpdate object:self.error? self.error : nil];
}

@end
