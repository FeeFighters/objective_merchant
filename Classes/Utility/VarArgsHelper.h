//
//  VarArgsHelper.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#ifndef __VAR_ARGS_HELPER_H__
#define __VAR_ARGS_HELPER_H__

NSArray* _utility_VarArgsToArray(va_list ap);

#define VarArgs(_last_) ({ \
	va_list ap; \
	va_start(ap, _last_); \
	NSArray* __args = _utility_VarArgsToArray(ap); \
	va_end(ap); \
	if (([__args count] == 1) && ([[__args objectAtIndex:0] isKindOfClass:[NSArray class]])) { \
	__args = [__args objectAtIndex:0]; \
	} \
	__args; })

#endif