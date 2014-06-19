//
//  WEPWeatherTableViewController.m
//  Weather
//
//  Created by Alexander Zakharin on 18.06.14.
//  Copyright (c) 2014 Alexander Zakharin. All rights reserved.
//

#import "WEPWeatherViewController.h"
#import "WEPLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <P34Utils.h>
#import "WEPWeatherLoader.h"
#import "WEPWeatherData.h"
#import <ProgressHUD.h>
#import <BlocksKit+UIKit.h>
#import <EGOCache.h>

#define CACHE_INTERVAL 60 * 60


@interface WEPWeatherViewController () <UISearchBarDelegate>

@property (nonatomic, strong) WEPWeatherData *weatherData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end

@implementation WEPWeatherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.alpha = 0;
    
    [ProgressHUD show:@"Loading" Interaction:YES];
    
    UITapGestureRecognizer *hedeSearchBarKeyboadrGesture = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboardForSearchBar)];
    [self.view addGestureRecognizer:hedeSearchBarKeyboadrGesture];
    
    WEPLocationManager *locationManager = [WEPLocationManager sharedSingleton];
    [locationManager getCurrentLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationWasUpdated:)
                                                 name:WEPNotificationCoordinatesDidUpdate
                                               object:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.weatherData.isError) {
        return 0;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Cell";
    
    if(indexPath.row == 1){
        identifier = @"ImageCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Place";
            cell.detailTextLabel.text = self.weatherData.namePlace;
            break;
        case 1:  {
            cell.textLabel.text = self.weatherData.weatherMain;
            cell.imageView.image = [UIImage imageNamed:@"placeholder.png"];
            
            NSString *urlImage = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png", self.weatherData.weatherIcon];
            
            EGOCache *cache = [EGOCache globalCache];
            
            NSString *keyForCache = [urlImage md5Hash];
            
            if ([cache hasCacheForKey:keyForCache]) {
            
                NSData *myDataFromCache = [cache dataForKey:keyForCache];
                UIImage *objectFromCache = [NSKeyedUnarchiver unarchiveObjectWithData:myDataFromCache];
                cell.imageView.image = objectFromCache;
                break;
            } else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage *myImage = [UIImage imageWithData:
                                        [NSData dataWithContentsOfURL:
                                         [NSURL URLWithString:urlImage]]];
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        NSData *myDataForCache = [NSKeyedArchiver archivedDataWithRootObject:myImage];
                        [cache setData:myDataForCache forKey:keyForCache withTimeoutInterval:CACHE_INTERVAL];
                        
                        [UIView animateWithDuration:0.1 animations:^{
                            cell.imageView.alpha = 0;
                        } completion:^(BOOL finished) {
                            cell.imageView.image = myImage;
                            [UIView animateWithDuration:0.1 animations:^{
                                cell.imageView.alpha = 1;
                            }];
                        }];
                    });
                });
            }

            
        }
            break;
        case 2:
            cell.textLabel.text = @"Temperature";
            cell.detailTextLabel.text = [self.weatherData.temp stringValue];
            break;
        case 3:
            cell.textLabel.text = @"Maximum Temperature";
            cell.detailTextLabel.text = [self.weatherData.tempMax stringValue];
            break;
        case 4:
            cell.textLabel.text = @"Manimum Temperature";
            cell.detailTextLabel.text = [self.weatherData.tempMin stringValue];
            break;
        case 5:
            cell.textLabel.text = @"Manimum Temperature";
            cell.detailTextLabel.text = [self.weatherData.tempMin stringValue];
            break;
        case 6:
            cell.textLabel.text = @"Humidity in %";
            cell.detailTextLabel.text = [self.weatherData.humidity stringValue];
            break;
        case 7:
            cell.textLabel.text = @"Atmospheric pressure in hPa";
            cell.detailTextLabel.text = [self.weatherData.pressure stringValue];
            break;
        case 8:
            cell.textLabel.text = @"Wind speed in mps";
            cell.detailTextLabel.text = [self.weatherData.windSpeed stringValue];
            break;
        case 9:
            cell.textLabel.text = @"Cloudiness in %";
            cell.detailTextLabel.text = [self.weatherData.cloudinessPercent stringValue];
            break;
        case 10: {
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
        case 11: {
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self loadWeatherWithObject:searchBar.text];
}

- (void)dismissKeyboardForSearchBar {
    [self.searchBar resignFirstResponder];
}

- (void)locationWasUpdated:(NSNotification*)notification {
    
    if ([[WEPLocationManager sharedSingleton] error]) {
        NSLog(@"%@", [notification object]);
        
        [ProgressHUD dismiss];
        

        NSError *error = [[WEPLocationManager sharedSingleton] error];
        
        switch([error code])
        {
            case kCLErrorNetwork:
            {
                self.errorLabel.text = @"Сheck your network connection";
            }
                break;
            case kCLErrorDenied:{
                self.errorLabel.text = @"Сheck your settings and allowing applications to use location";
            }
                break;
            default:
            {
                self.errorLabel.text = @"Сheck your settings and allowing applications to use location";
            }
                break;
        }
        
        self.errorLabel.hidden = NO;
        
    } else {
        [self loadWeatherWithObject:[WEPLocationManager sharedSingleton].currentLocation];
       
    }
}

- (void)loadWeatherWithObject:(id)object {
    
    WEPWeatherLoader *loader = [[WEPWeatherLoader alloc] init];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.alpha = 0;
        self.errorLabel.hidden = YES;
    }];
    
    
    [ProgressHUD show:@"Loading" Interaction:YES];
    
    if ([object isKindOfClass:[CLLocation class]]) {
        [loader loadWeatherByLocation:object andWithAction:^(id obj) {
            
            WEPWeatherData *data = obj;
            if (!data.isError) {
                self.weatherData = obj;
                self.title = @"Current location";
                [self showTableView];
            } else {
                [ProgressHUD dismiss];

                self.errorLabel.text = @"Сheck your network connection";
                self.errorLabel.hidden = NO;
            }
        }];
    }
    
    if ([object isKindOfClass:[NSString class]]) {
        [loader loadWeatherByNameCyty:object andWithAction:^(id obj) {
            WEPWeatherData *data = obj;
            
            UIBarButtonItem *currentWether = [[UIBarButtonItem alloc]
                                           initWithTitle:@"For location"
                                           style:UIBarButtonItemStyleBordered
                                           target:self
                                           action:@selector(getWeatherForLocation)];
            self.navigationItem.leftBarButtonItem = currentWether;
            
            if (!data.isError) {
                self.weatherData = obj;
                self.title = self.weatherData.namePlace;
                [self showTableView];
            } else {
                [ProgressHUD dismiss];

                self.errorLabel.text = @"Сheck name city and try again";
                self.errorLabel.hidden = NO;
            }
        }];
    }
}

- (void)showTableView {
    [ProgressHUD dismiss];
    self.errorLabel.hidden = YES;
    [self.tableView reloadData];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.alpha = 1;
    }];
}

- (void)getWeatherForLocation {
    self.navigationItem.leftBarButtonItem = nil;
    
    [self loadWeatherWithObject:[WEPLocationManager sharedSingleton].currentLocation];
}

@end
