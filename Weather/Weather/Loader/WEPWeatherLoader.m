//
//  WEPWeatherLoader.m
//  Weather
//
//  Created by Alexander Zakharin on 18.06.14.
//  Copyright (c) 2014 Alexander Zakharin. All rights reserved.
//

#import "WEPWeatherLoader.h"
#import <EGOCache.h>
#import <AFNetworking.h>
#import "WEPWeatherData.h"
#import <P34Utils.h>

NSString *const WEPWEatherApiKey = @"242192403ed73477feab1416fa10813d";
NSString *const WEPServerURL = @"http://api.openweathermap.org/data/2.5/find?units=imperial&";

#define CACHE_INTERVAL 60 * 30

#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = NO

@implementation WEPWeatherLoader

- (void)loadWeatherByLocation:(CLLocation *)location andWithAction:(IdBlock)action {
   
    NSString *parameters = [NSString stringWithFormat:@"lat=%f&lon=%f", location.coordinate.latitude, location.coordinate.longitude];
    
    [self loadWithParams:parameters andWithAction:^(id obj) {
        return action(obj);
    }];
}

- (void)loadWeatherByNameCyty:(NSString *)cityNameString andWithAction:(IdBlock)action {
    
    NSString *parameters = [NSString stringWithFormat:@"q=%@", cityNameString];
    
    [self loadWithParams:parameters andWithAction:^(id obj) {
        return action(obj);
    }];
}

- (void)loadWithParams:(NSString *)params andWithAction:(IdBlock)action {
    ShowNetworkActivityIndicator();
    
    NSString *urlFull = [NSString stringWithFormat:@"%@%@", WEPServerURL, params];
    
    if ([NSURL URLWithString:urlFull]) {
        
        EGOCache *cache = [EGOCache globalCache];
        
        NSString *keyForCache = [urlFull md5Hash];
        
        if ([cache hasCacheForKey:keyForCache]) {
            NSData *myDataFromCache = [cache dataForKey:keyForCache];
            
            id objectFromCache = [NSKeyedUnarchiver unarchiveObjectWithData:myDataFromCache];
            
            WEPWeatherData *data  = [[WEPWeatherData alloc] initWithData:objectFromCache];
            
            if (action)
                HideNetworkActivityIndicator();
            action(data);
            return;
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlFull parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (responseObject) {
                NSData *myDataForCache = [NSKeyedArchiver archivedDataWithRootObject:responseObject];
                [cache setData:myDataForCache forKey:keyForCache withTimeoutInterval:CACHE_INTERVAL];
            }
            
            WEPWeatherData *data = nil;
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                data = [[WEPWeatherData alloc] initWithData:responseObject];
            }
            
            if (action)
                HideNetworkActivityIndicator();
            action(data);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            WEPWeatherData *data  = [[WEPWeatherData alloc] initWithData:nil];
            action(data);
        }];
    }
    else {
        HideNetworkActivityIndicator();
        WEPWeatherData *data  = [[WEPWeatherData alloc] initWithData:nil];
        action(data);
    }
}

@end
