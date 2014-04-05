//
//  WebController.m
//  Tweem
//
//  Created by Sadruddin Junejo on 21/03/2014.
//  Copyright (c) 2014 SJunejo. All rights reserved.
//

#import "WebController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface WebController()

@property (nonatomic) ACAccountStore *accountStore;

@end

@implementation WebController

static NSString const *BaseURLString = @"ohmygodthisisastring";
static NSInteger const STATUS_SUCCESS = 200;
static NSInteger const STATUS_REDIRECTION = 300;


#pragma mark singleton methods

+(WebController *) sharedInstance {
    //  Static local predicate must be initialized to 0
    static WebController *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WebController alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (id) init {
    if (self = [super init]) {
        _accountStore = [[ACAccountStore alloc] init];
        NSLog(@"Init method called");
    }
    return self;
}


// Check that the user has local twitter accounts
- (BOOL) userHasAccessToTwitter {
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

#pragma mark private methods
// Static method a good idea?
- (void) sendWebRequestWithURL: (NSString*) string {
    
    if ([self userHasAccessToTwitter]){
         ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [self.accountStore requestAccessToAccountsWithType:twitterAccountType options:NULL completion:^(BOOL granted, NSError *error) {
            if (granted){
                
                NSLog(@"Granted!");
                // Must get a list of twitter accounts derp
                NSArray *twitterAccounts =
                [self.accountStore accountsWithAccountType:twitterAccountType];
                
                for (id object in twitterAccounts){
                    NSLog(@"%@", object);
                }
                
                
                NSString *urlString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSLog(@"%@", urlString);
                
                NSURL *url = [[NSURL alloc] initWithString:urlString];
                NSDictionary *params = @{@"count" : @"20",
                                         @"q": @"#nowplaying"};
                
                
                
                SLRequest *request =
                [SLRequest requestForServiceType:SLServiceTypeTwitter
                                   requestMethod:SLRequestMethodGET
                                             URL:url
                                      parameters:params];
                
                //  Attach an account to the request
                [request setAccount:[twitterAccounts objectAtIndex:0]];
                
                //  Step 3:  Execute the request
                [request performRequestWithHandler:
                 ^(NSData *responseData,
                   NSHTTPURLResponse *urlResponse,
                   NSError *error) {
                     
                     if (responseData) {
                         if (urlResponse.statusCode >= STATUS_SUCCESS &&
                             urlResponse.statusCode < STATUS_REDIRECTION) {
                             
                             NSError *jsonError;
                             NSDictionary *timelineData =
                             [NSJSONSerialization
                              JSONObjectWithData:responseData
                              options:NSJSONReadingAllowFragments error:&jsonError];
                             if (timelineData) {
                                 NSLog(@"Timeline Response: %@\n", timelineData);
                             }
                             else {
                                 // Our JSON deserialization went awry
                                 NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                             }
                         }
                         else {
                             // The server did not respond ... were we rate-limited?
                             NSLog(@"The response status code is %d",
                                   urlResponse.statusCode);
                             NSLog(@"%@", urlResponse.description);
                         }
                     }
                 }];
            }
            else {
                // Access was not granted, or an error occurred
                NSLog(@"An error occurred!");
                NSLog(@"%@", [error localizedDescription]);
            }
        }];
        
        
    } else {
        NSLog(@"No Twitter");
    }
    
}

@end
