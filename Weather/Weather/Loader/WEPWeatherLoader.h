//
//  WEPWeatherLoader.h
//  Weather
//
//  Created by Alexander Zakharin on 18.06.14.
//  Copyright (c) 2014 Alexander Zakharin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^idBlock)(id object);

@interface WEPWeatherLoader : NSObject

- (void)loadWithParams:(NSDictionary *)params andWithAction:(idBlock)action;

@end
