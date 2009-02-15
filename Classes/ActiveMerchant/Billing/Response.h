//
//  Response.h
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



@interface BillingResponse : NSObject {

@protected
	NSDictionary *params;
	NSString *message;
	bool test;
	NSString *authorization;
	NSDictionary *avsResult;
	NSDictionary *cvvResult;
@private
	bool fraudReview;
	bool success;
}

@property(readonly) NSDictionary *params;
@property(readonly) NSString *message;
@property(readonly) bool test;
@property(readonly) NSString *authorization;
@property(readonly) NSDictionary *avsResult;
@property(readonly) NSDictionary *cvvResult;

- (id) init:(bool)success message:(NSString *)message params:(NSDictionary*)params options:(NSDictionary*)options;
- (bool) is_success;
- (bool) is_test;
- (bool) is_fraudReview;


@end
