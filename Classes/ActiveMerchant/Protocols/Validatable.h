//
//  Validatable.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#if defined(TARGET_IPHONE_SIMULATOR) || defined(TARGET_OS_IPHONE)
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

#import "Errors.h"

@protocol Validatable

- (bool) is_valid;
- (id) init:(NSDictionary*)attributes;
- (Errors *) errors;

@end
