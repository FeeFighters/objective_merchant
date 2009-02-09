//
//  CreditCardFormatting.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSStringAdditions.h"

@protocol CreditCardFormatting

- (NSString *) format:(NSString*)number option:(NSString*)option;

@end
