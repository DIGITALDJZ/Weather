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

NSString *const WEPWEatherApiKey = @"242192403ed73477feab1416fa10813d";
NSString *const WEPServerURL = @"http://api.openweathermap.org/data/2.5/weather?";

#define CACHE_INTERVAL 60 * 30

#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = NO

@implementation WEPWeatherLoader

- (id)init {
    
  	if((self = [super init])) {

	}
	
	return self;
}

- (void)loadWithParams:(NSDictionary *)params andWithAction:(idBlock)action {
    ShowNetworkActivityIndicator();
    
    EGOCache *cache = [EGOCache globalCache];
    
    NSString *keyForCache = nil;//[self cacheKeyForParams:params];
    
    if ([cache hasCacheForKey:keyForCache]) {
        NSData *myDataFromCache = [cache dataForKey:keyForCache];
        
        id objectFromCache = [NSKeyedUnarchiver unarchiveObjectWithData:myDataFromCache];
        
        if (action)
            HideNetworkActivityIndicator();
        action(objectFromCache);
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://api.openweathermap.org/data/2.5/find?lat=55.7522200&lon=37.6155600&units=imperial" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        WEPWeatherData *data = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            data = [[WEPWeatherData alloc] initWithData:responseObject];
        }
        
        action(data);
        
        //&APPID=1111111111
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        action(error);
        
        NSLog(@"Error: %@", error);
    }];
}

@end
