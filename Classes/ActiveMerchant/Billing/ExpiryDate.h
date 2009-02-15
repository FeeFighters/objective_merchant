//
//  ExpiryDate.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#if defined(TARGET_IPHONE_SIMULATOR) || defined(TARGET_OS_IPHONE)
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif



@interface BillingExpiryDate : NSObject {

@protected
	NSNumber* month;
	NSNumber* year;
}

@property(nonatomic, retain) NSNumber* month;
@property(nonatomic, retain) NSNumber* year;

- (id) init:(NSNumber*)month year:(NSNumber*)year;
- (bool) is_expired;
- (NSDate *) expiration;


@end
