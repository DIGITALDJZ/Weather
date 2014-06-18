//
//  WEPWeatherTableViewController.m
//  Weather
//
//  Created by Alexander Zakharin on 18.06.14.
//  Copyright (c) 2014 Alexander Zakharin. All rights reserved.
//

#import "WEPWeatherTableViewController.h"
#import "WEPLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <P34Utils.h>
#import "WEPWeatherLoader.h"
#import "WEPWeatherData.h"

@interface WEPWeatherTableViewController ()

@property (nonatomic, strong) WEPWeatherData *weatherData;

@end

@implementation WEPWeatherTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WEPWeatherLoader *loader = [[WEPWeatherLoader alloc] init];
    
    [loader loadWithParams:nil andWithAction:^(id object) {
        self.weatherData = object;
    }];
    
//    WEPLocationManager *lm = [WEPLocationManager sharedSingleton];
    
    
    
//    doAfter(15, ^{
//        self.title = [NSString stringWithFormat:@"%f", lm.currentLocation.coordinate.latitude];
//
//    });
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Place";
            cell.detailTextLabel.text = self.weatherData.namePlace;
            break;
        case 1:
            cell.textLabel.text = @"Temperature";
            cell.detailTextLabel.text = [self.weatherData.temp stringValue];
            break;
        case 2:
            cell.textLabel.text = @"Maximum Temperature";
            cell.detailTextLabel.text = [self.weatherData.tempMax stringValue];
            break;
        case 3:
            cell.textLabel.text = @"Manimum Temperature";
            cell.detailTextLabel.text = [self.weatherData.tempMin stringValue];
            break;
        case 4:
            cell.textLabel.text = @"Manimum Temperature";
            cell.detailTextLabel.text = [self.weatherData.tempMin stringValue];
            break;
        case 5:
            cell.textLabel.text = @"Humidity in %";
            cell.detailTextLabel.text = [self.weatherData.humidity stringValue];
            break;
        case 6:
            cell.textLabel.text = @"Atmospheric pressure in hPa";
            cell.detailTextLabel.text = [self.weatherData.pressure stringValue];
            break;
        case 7:
            cell.textLabel.text = @"Wind speed in mps";
            cell.detailTextLabel.text = [self.weatherData.windSpeed stringValue];
            break;
        case 8:
            cell.textLabel.text = @"Cloudiness in %";
            cell.detailTextLabel.text = [self.weatherData.cloudinessPercent stringValue];
            break;
        case 9: {
            cell.textLabel.text = @"Rain";
            
            NSString *rainString = nil;
            
            if (self.weatherData.keyRain) {
                rainString = [NSString stringWithFormat:@"%@ %@%%", self.weatherData.keyRain, self.weatherData.valueRain];
            } else {
                rainString = @"Not information";
            }
            cell.detailTextLabel.text = rainString;
        }
            break;
        case 10: {
            cell.textLabel.text = @"Snow";
            
            NSString *snowString = nil;
            
            if (self.weatherData.keySnow) {
                snowString = [NSString stringWithFormat:@"%@ %@%%", self.weatherData.keySnow, self.weatherData.keySnow];
            } else {
                snowString = @"Not information";
            }
            
            cell.detailTextLabel.text = snowString;
        }
            break;
            
        default:
            break;
    }

    return cell;
}

@end
