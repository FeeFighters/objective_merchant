//
//  CvvResult.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface BillingCvvResult : NSObject {

@protected
	NSString *code;
	NSString *message;
}

@property(readonly) NSString *code;
@property(readonly) NSString *message;

- (id) init:(NSString *)code;
- (NSDictionary *) to_dictionary;

+ (NSDictionary *) messages;

@end
