//
//  Utilities.h
//  About Me
//
//  Created by Shabbir Vijapura on 4/30/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface Utilities : NSObject

+ (Utilities *)sharedUtilities;
- (void)cacheImage:(UIImage *) image withName:(NSString *) name;
- (UIImage *)getCachedImageWithName:(NSString *) name;
- (void) follow:(NSString *) username;

@end
