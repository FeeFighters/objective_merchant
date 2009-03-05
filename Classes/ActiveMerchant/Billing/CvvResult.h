//
//  CvvResult.h
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


@interface BillingCvvResult : NSObject {

@protected
	NSString *code;
	NSString *message;
}

@property(readonly) NSString *code;
@property(readonly) NSString *message;

- (id) init:(NSString *)code;
- (NSDictionary *) toDictionary;

+ (NSDictionary *) messages;

@end
