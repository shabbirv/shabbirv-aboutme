//
//  AboutMeEngine.m
//  About Me
//
//  Created by Shabbir Vijapura on 4/26/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "AboutMeEngine.h"

@implementation AboutMeEngine

+ (AboutMeEngine *) engineWithDelegate:(id) delegate {
    static AboutMeEngine *sharedEngine = nil;
	
	@synchronized(self)
	{
		if (sharedEngine == nil)
		{
			sharedEngine = [[AboutMeEngine alloc] init];
		}
	}
    sharedEngine.delegate = delegate;
	return sharedEngine;
}

//Gets app ids from local json file
- (void) getMyAppids {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"apps" ofType:@"json"];
    NSString *jsonText = [NSString stringWithContentsOfFile:filePath encoding:NSStringEncodingConversionAllowLossy error:nil];
    NSData *data = [jsonText dataUsingEncoding:NSStringEncodingConversionAllowLossy];
    NSArray *appIds = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    if ([_delegate respondsToSelector:@selector(engineDidLoadAppIds:)])
        [_delegate engineDidLoadAppIds:appIds];
}

//Uses iTunes API to get information about the App Id
- (void)loadInfoAboutAppId:(NSString *) appId {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", appId]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error) {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
             [alert show];
         } else {
             NSDictionary *appInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             App *app = [[App alloc] init];
             NSString *artworkUrl = [[[appInfo objectForKey:@"results"] lastObject] objectForKey:@"artworkUrl512"];
             NSString *name = [[[appInfo objectForKey:@"results"] lastObject] objectForKey:@"trackName"];
             app.name = name;
             app.appId = appId;
             app.artworkUrl = [NSURL URLWithString:artworkUrl];
             if ([_delegate respondsToSelector:@selector(engineDidLoadAppInfo:)])
                 [_delegate engineDidLoadAppInfo:app];
         }
         
     }];
}

@end
