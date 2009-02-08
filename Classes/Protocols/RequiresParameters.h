//
//  RequiresParameters.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "VarArgsHelper.h"
#import "NSArrayAdditions.h"


@protocol RequiresParameters

- (void) requires:(NSDictionary*)hash, ...;

@end
