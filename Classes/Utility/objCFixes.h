//
//  objCFixes.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/9/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#if defined(TARGET_IPHONE_SIMULATOR) || defined(TARGET_OS_IPHONE)
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif


static id nilToNull(id value) { return value ? value : [NSNull null]; }
static id nilToEmptyStr(NSString* value) { return (value==nil || [value length]<1) ? @"" : value; }
#define MakeBool(_X_) ((_X_) ? (id)kCFBooleanTrue : (id)kCFBooleanFalse)
#define MakeInt(_X_) [NSNumber numberWithInt:_X_]
#define MakeFloat(_X_) [NSNumber numberWithFloat:_X_]
#define MakeStr(_X_) [NSString stringWithString:_X_]
