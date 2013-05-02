//
//  Fact.m
//  About Me
//
//  Created by Shabbir Vijapura on 4/26/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "Fact.h"

@implementation Fact

+ (Fact *)getRandomFactWithAppId:(NSString *) appId {
    Fact *fact = [[Fact alloc] init];
    NSDictionary *factDict = [fact randomFactByAppId:appId];
    fact.factText = [factDict objectForKey:@"message"];
    fact.appId = [factDict objectForKey:@"appId"];
    return fact;
}

//Organized apps based on app id
- (NSArray *)facts {
    NSArray *facts = @[
                       @{@"appId": @"342606477", @"message": @"Has had ~1,000,000 downloads since its debut in 2010"},
                       @{@"appId": @"342606477", @"message": @"Has never left the top 300 in the US Utilities section in the last 3 years"},
                       @{@"appId": @"502939436", @"message": @"> 1,000,000 downloads in about a year and a half"},
                       @{@"appId": @"502939436", @"message": @"This app was created over a weekend"},
                       @{@"appId": @"502939436", @"message": @"Over 3 million memes created from the app. About 25,000 a day"},
                       @{@"appId": @"493848413", @"message": @"Cloudapp founders love the app and use it."},
                       @{@"appId": @"493848413", @"message": @"Was downloaded over 10,000 times during a 2 hour free Sale at WWDC 2012"},
                       @{@"appId": @"493848413", @"message": @"Utilizies unique background uploading feature"},
                       @{@"appId": @"592632455", @"message": @"Was featured on my university's newspaper"},
                       @{@"appId": @"592632455", @"message": @"Was featured on popular Redeye newspaper"},
                       @{@"appId": @"325331000", @"message": @"This app was actively used by Shaquille O'Neal on Twitter"},
                       @{@"appId": @"322677262", @"message": @"This was the first app I created in 2009"},
                       @{@"appId": @"438041955", @"message": @"Allows you to use your icon as a countdown timer"},
                       @{@"appId": @"527053764", @"message": @"Let's you upload reading material while not in the app"},
                       @{@"appId": @"379113809", @"message": @"Slide photos to your favorite services"},
                       @{@"appId": @"415162375", @"message": @"One of the first complex projects I worked on"},
                       @{@"appId": @"550384975", @"message": @"Simple utility I created for myself to keep track of Admob earnings"},
                       @{@"appId": @"606109374", @"message": @"This app was created in less than 2 days and received over 300,000 downloads"},
                       @{@"appId": @"381898055", @"message": @"Made this app when the burst of flash light apps came out. We missed being the first app by 2 days"},
                       @{@"appId": @"342693650", @"message": @"A simple utility that detects who you've talked to on Twitter and creates a list for #FF"},
                       @{@"appId": @"550762448", @"message": @"A unique application that allows you to manage screenshots as you take them"},
                       @{@"appId": @"592194025", @"message": @"The only third-party full featured Dropbox app"},
                       ];
    return facts;
}

- (NSDictionary *)randomFactByAppId:(NSString *) appId {
    NSArray *facts = [self facts];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in facts) {
        if ([[dict objectForKey:@"appId"] isEqualToString:appId])
            [array addObject:dict];
    }
    if (array.count == 0) return nil;
    NSDictionary *factDict = [array objectAtIndex:arc4random()%array.count];
    return factDict;
}

@end
