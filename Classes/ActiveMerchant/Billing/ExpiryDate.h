//
//  ExpiryDate.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ExpiryDate : NSObject {

@protected
	NSString *month;
	NSString *year;
}

@property(nonatomic, retain) NSString *month;
@property(nonatomic, retain) NSString *year;

- (id) init:(NSString *)month year:(NSString *)year;
- (bool) is_expired;
- (NSDate *) expiration;


@end
