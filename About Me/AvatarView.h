//
//  AvatarView.h
//  About Me
//
//  Created by Shabbir Vijapura on 4/26/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "App.h"
#import "ViewController.h"
#import "Utilities.h"

@interface AvatarView : UIButton <AboutMeEngineDelegate>  {
    UIActivityIndicatorView *spinner;
    AboutMeEngine *engine;
}

@property (strong, nonatomic) UIImage *image;
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) App *app;

@end
