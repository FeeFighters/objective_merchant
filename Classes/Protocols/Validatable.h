//
//  Validatable.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Errors.h"

@protocol Validatable

- (bool) is_valid;
- (id) init:(NSDictionary*)attributes;
- (Errors *) errors;

@end
