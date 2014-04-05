//
//  WebController.h
//  Tweem
//
//  Created by Sadruddin Junejo on 21/03/2014.
//  Copyright (c) 2014 SJunejo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>

@interface WebController : NSObject

+(WebController *) sharedInstance;
-(void) sendWebRequestWithURL: (NSString*) string;

@end
