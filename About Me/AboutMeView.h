//
//  AboutMeScrollView.h
//  About Me
//
//  Created by Shabbir Vijapura on 4/27/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"
#import "AccessoryTableCell.h"
#import "WebViewController.h"

@interface AboutMeView : UIView <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet MKMapView *mapView;
    IBOutlet UIScrollView *scroll;
    IBOutlet UITableView *theTableView;
    NSArray *infoArray;
    NSDictionary *aboutMeDictionary;
    int currentPage;
}

@property (nonatomic, weak) IBOutlet id delegate;

@end
