//
//  RequiresParameters.h
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

#import "VarArgsHelper.h"
#import "NSArrayAdditions.h"


@protocol RequiresParameters

- (void) requires:(NSDictionary*)hash, ...;

@end
