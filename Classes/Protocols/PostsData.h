//
//  PostsData.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol PostsData

- (NSString*) sslPost:(NSString *)url data:(NSString *)data headers:(NSMutableDictionary*)headers;

//
// Class inheritable accessors
//
+ (bool) sslStrict;
+ (void) setSslStrict:(bool)val;
+ (bool) pemPassword;
+ (void) setPemPassword:(bool)val;
+ (bool) retrySafe;
+ (void) setRetrySafe:(bool)val;
+ (int) openTimeout;
+ (void) setOpenTimeout:(int)val;
+ (int) readTimeout;
+ (void) setReadTimeout:(int)val;
+ (int) maxRetries;

@end
