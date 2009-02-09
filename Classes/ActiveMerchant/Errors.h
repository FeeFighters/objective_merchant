//
//  Errors.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Errors : NSMutableDictionary {

@private
	id base;
}

- (id) init:(id)base;
- (NSString*) on:(NSString *)field;
- (void) add:(NSString *)field error:(NSString*)error;
- (void) addToBase:(NSString*)error;
- (NSArray*) fullMessages;

@end
