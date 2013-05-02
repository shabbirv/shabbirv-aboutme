//
//  Fact.h
//  About Me
//
//  Created by Shabbir Vijapura on 4/26/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fact : NSObject

+ (Fact *)getRandomFactWithAppId:(NSString *) appId;

@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *factText;

- (NSArray *)facts;

@end
