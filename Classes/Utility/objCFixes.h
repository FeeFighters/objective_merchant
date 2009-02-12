//
//  objCFixes.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

static id nilToNull(id value) { return value ? value : [NSNull null]; }
#define MakeBool(_X_) ((_X_) ? (id)kCFBooleanTrue : (id)kCFBooleanFalse)
#define MakeInt(_X_) [NSNumber numberWithInt:_X_]
#define MakeFloat(_X_) [NSNumber numberWithFloat:_X_]
#define MakeStr(_X_) [NSString stringWithString:_X_]
