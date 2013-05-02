//
//  Utilities.m
//  About Me
//
//  Created by Shabbir Vijapura on 4/30/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

#define TMP_DIRECTORY NSTemporaryDirectory()

+ (Utilities *)sharedUtilities
{
	static Utilities *sharedUtilities = nil;
	
	@synchronized(self)
	{
		if (sharedUtilities == nil)
		{
			sharedUtilities = [[Utilities alloc] init];
		}
	}
	
	return sharedUtilities;
}

#pragma mark Image Caching

- (void)cacheImage: (UIImage *) image withName:(NSString *) name
{
    //Put in seperate thread so theres no lag on main thread
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        // Generate a unique path to a resource representing the image you want
        NSString *filename = [name stringByAppendingString:@".png"];
        NSString *path = [TMP_DIRECTORY stringByAppendingPathComponent: filename];
        
        // Check for file existence
        if(![[NSFileManager defaultManager] fileExistsAtPath: path]) {
            // The file doesn't exist, we should save it
            [UIImageJPEGRepresentation(image, 0.9) writeToFile:path atomically: YES];
        }
    });
    
}

- (UIImage *)getCachedImageWithName:(NSString *) name {
    NSString *filename = [name stringByAppendingString:@".png"];
    NSString *path = [TMP_DIRECTORY stringByAppendingPathComponent: filename];
    // Check for a cached version
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return [UIImage imageWithContentsOfFile:path]; // this is the cached image
    }
    
    return nil;
}

#pragma mark Twitter utilities

-(void) follow:(NSString *) username {
    // Create account store, followed by a twitter account identifier
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *type = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:type options:nil completion:^(BOOL granted, NSError *error) {
        if(granted) {
            NSArray *accountsArray = [accountStore accountsWithAccountType:type];
            // Sanity check
            if ([accountsArray count] > 0)
            {
                //Create dictionary to pass to followWithAccountInfo: method
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:username forKey:@"usernameToFollow"];
                //Follow the username with your first logged in account
                ACAccount *acct = [accountsArray objectAtIndex:0];
                acct.accountType = type;
                [dict setObject:acct forKey:@"account"];
                [self performSelectorOnMainThread:@selector(followWithAccountInfo:) withObject:dict waitUntilDone:NO];
            } else {
                NSString *message = @"You have not logged into any Twitter accounts";
                [self performSelectorOnMainThread:@selector(showAlertWithMessage:) withObject:message waitUntilDone:NO];
            }
        }

    }];
}

-(void) followWithAccountInfo:(NSDictionary *) dictionary {
    ACAccount *acct = [dictionary objectForKey:@"account"];
    NSString *username = [dictionary objectForKey:@"usernameToFollow"];
    // Build a twitter request for following the username specified
    SLRequest *postRequest = [SLRequest
                              requestForServiceType:SLServiceTypeTwitter
                              requestMethod:SLRequestMethodPOST
                              URL:[NSURL URLWithString:@"http://api.twitter.com/1.1/friendships/create.json"]
                              parameters:@{@"screen_name": username, @"follow" : @"true"}];
    
    // Post the request
    [postRequest setAccount:acct];
    // Block handler to manage the response
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
     {
         NSString *message = [NSString stringWithFormat:@"You just followed @shabzcohelp with %@", acct.username];
         [self performSelectorOnMainThread:@selector(showAlertWithMessage:) withObject:message waitUntilDone:NO];

     }];
}

- (void)showAlertWithMessage:(NSString *) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success:" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
}

@end
