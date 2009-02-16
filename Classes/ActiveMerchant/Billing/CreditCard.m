//
//  CreditCard.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "CreditCard.h"
#import "CreditCardMethods.h"
#import "RegexKitLite.h"

@implementation BillingCreditCard

@synthesize number, month, year, type, firstName, lastName;
@synthesize startMonth, startYear, issueNumber;
@synthesize verificationValue;

static bool _BillingCreditCard_requireVerificationValue = true;


- (BillingExpiryDate *) expiryDate
{
	return [[BillingExpiryDate alloc] init:month year:year];
}

- (bool) is_expired
{
	return [[self expiryDate] is_expired];
}

- (bool) has_name
{
	return ([self has_firstName] && [self has_lastName]);
}
- (bool) has_firstName
{
	return ![NSString is_blank:firstName];
}
- (bool) has_lastName
{
	return ![NSString is_blank:lastName];
}
- (NSString *) name
{
	return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
}

- (bool) has_verificationValue
{
	return ![NSString is_blank:verificationValue];
}

- (NSString *) displayNumber
{
	return [BillingCreditCard mask:number];
}

- (NSString *) lastDigits
{
	return [BillingCreditCard lastDigits:number];	
}

//
// Private Methods
//
- (void) beforeValidate
{
	int count = [number replaceOccurrencesOfRegex:@"[^0-9]" withString:@""];
	if ([NSString is_blank:type]) {
		NSString* temp = [BillingCreditCard getType:number];
		if (temp==nil) temp = @"";
		type = [NSString stringWithString:temp];
	} else {
		type = [NSString stringWithString:[type lowercaseString]];
	}
}
- (void) validateCardType
{
	if ([NSString is_blank:type])
		[_errors add:@"type" error:@"is required"];

	if ([[BillingCreditCard cardCompanies] objectForKey:type]==nil)
		[_errors add:@"type" error:@"is invalid"];
}
- (void) validateCardNumber
{
	if (![BillingCreditCard is_validNumber:number])
		[_errors add:@"number" error:@"is not a valid credit card number"];	

	if (!([_errors on:@"number"] || [_errors on:@"type"]))
	{
		if (![BillingCreditCard is_matchingType:number type:type])
			[_errors add:@"type" error:@"is not the correct card type"];				
	}
}
- (void) validateEssentialAttributes
{
	if ([NSString is_blank:firstName]) [_errors add:@"firstName" error:@"cannot be empty"];
	if ([NSString is_blank:lastName]) [_errors add:@"lastName" error:@"cannot be empty"];
	if (![self is_validMonth:month]) [_errors add:@"month" error:@"is not a valid month"];
	if ([self is_expired]) [_errors add:@"card" error:@"is expired"];
	if (![self is_validExpiryYear:year]) [_errors add:@"year" error:@"is not a valid year"];	
}
- (void) validateVerificationValue
{
	if ([BillingCreditCard requiresVerificationValue] && [NSString is_blank:verificationValue])
		[_errors add:@"verificationValue" error:@"is required"];						
}
- (void) validateSwitchOrSoloAttributes
{
	if ([type isEqualToString:@"switch"] || [type isEqualToString:@"solo"])
	{
		if (! ([self is_validMonth:startMonth] && [self is_validStartYear:startYear] || [self is_validIssueNumber:issueNumber]) )
		{
			if (![self is_validMonth:startMonth]) [_errors add:@"startMonth" error:@"is invalid"];
			if (![self is_validMonth:startYear]) [_errors add:@"startYear" error:@"is invalid"];
			if (![self is_validMonth:issueNumber]) [_errors add:@"issueNumber" error:@"cannot be empty"];			
		}
	}
}


//
// Public
//
- (void) validate
{
	[self validateEssentialAttributes];
	if ([[self type] isEqualToString:@"bogus"]) return;
	[self validateCardType];
	[self validateCardNumber];
	[self validateVerificationValue];
	[self validateSwitchOrSoloAttributes];
}


+ (bool)requiresVerificationValue
{
	return [BillingCreditCard requireVerificationValue];
}
+ (bool)requireVerificationValue
{
	return _BillingCreditCard_requireVerificationValue;
}
+ (void)setRequireVerificationValue:(bool)value
{
	_BillingCreditCard_requireVerificationValue = value;
}

#include "Validatable_Implementation.h"

@end
