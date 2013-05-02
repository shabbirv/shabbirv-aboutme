//
//  App.h
//  About Me
//
//  Created by Shabbir Vijapura on 4/26/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface App : NSObject

@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *artworkUrl;
@property (nonatomic, strong) NSURL *screenshotUrl;

@end
