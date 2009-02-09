//
//  ExpiryDate.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface BillingExpiryDate : NSObject {

@protected
	NSInteger month;
	NSInteger year;
}

@property(assign) NSInteger month;
@property(assign) NSInteger year;

- (id) init:(NSInteger)month year:(NSInteger)year;
- (bool) is_expired;
- (NSDate *) expiration;


@end
