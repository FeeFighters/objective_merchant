//
//  objCFixes.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

static id nilToNull(id value) { return value ? value : [NSNull null]; }
#define NSBool(_X_) ((_X_) ? (id)kCFBooleanTrue : (id)kCFBooleanFalse)