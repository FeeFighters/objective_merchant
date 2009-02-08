//
//  Check.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Validatable.h"

//# The Check object is a plain old Ruby object, similar to CreditCard. It supports validation
//# of necessary attributes such as checkholder's name, routing and account numbers, but it is
//# not backed by any database.
//# 
//# You may use Check in place of CreditCard with any gateway that supports it. Currently, only
//# +BrainTreeGateway+ supports the Check object.
@interface BillingCheck : NSObject <Validatable> {

@protected
	NSString* firstName;
	NSString* lastName;	
	NSString* routingNumber;	
	NSString* accountNumber;	
	NSString* accountHolderType;
	NSString* accountType;
	NSString* number;	
	NSString* institutionNumber;
	NSString* transitNumber;	     

@private
	NSString* _name;
	
#include "Validatable_Definitions.h"
}

@property(nonatomic, retain) NSString *firstName;
@property(nonatomic, retain) NSString *lastName;
@property(nonatomic, retain) NSString *routingNumber;
@property(nonatomic, retain) NSString *accountNumber;
@property(nonatomic, retain) NSString *accountHolderType;
@property(nonatomic, retain) NSString *accountType;
@property(nonatomic, retain) NSString *number;
- (NSString *) name;
- (void) setName:(NSString *)name;

// Used for Canadian bank accounts
@property(nonatomic, retain) NSString *institutionNumber;
@property(nonatomic, retain) NSString *transitNumber;

- (void) validate;
- (NSString *) type;
- (bool) is_validRoutingNumber;

@end
