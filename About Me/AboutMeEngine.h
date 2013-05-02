//
//  AboutMeEngine.h
//  About Me
//
//  Created by Shabbir Vijapura on 4/26/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App.h"

@protocol AboutMeEngineDelegate <NSObject>
@optional
- (void)engineDidLoadAppIds:(NSArray *) appIds;
- (void)engineDidLoadAppInfo:(App *) app;
@end

@interface AboutMeEngine : NSObject

@property (nonatomic, weak) id <AboutMeEngineDelegate> delegate;

//Singleton that asks for delegate
+ (AboutMeEngine *) engineWithDelegate:(id) delegate;

//Gets all Apple app ids for my apps
- (void)getMyAppids;

//Load information about a certain appId
- (void)loadInfoAboutAppId:(NSString *) appId;

@end
