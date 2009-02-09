//
//  Gateway.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "Gateway.h"
#import "Base.h"
#import "NSStringAdditions.h"

@implementation BillingGateway

@synthesize options;

//
// Private
//

- (NSString*) name
{
	return [[self class] className];
}

- (NSString *)amount:(id)money
{
	if (money==nil) return nil;

	id cents = money;
	if ([money respondsToSelector:@selector(cents)])
		cents = [money performSelector:@selector(cents)];
	
	if ([[[self class] moneyFormat] isEqualToString:@"cents"])
		return [NSString stringWithFormat:@"%d", [cents intValue]];
	
	return [NSString stringWithFormat:@"%.2f", [cents floatValue]/100.0];
}

- (NSString *) currency:(id)money
{
	if ([money respondsToSelector:@selector(currency)])
		return [money performSelector:@selector(currency)];
	
	return [[self class] defaultCurrency];
}

- (bool) requiresStartDateOrIssueNumber:(NSString *)creditCard
{
	if ([NSString is_blank:[self cardBrand:creditCard]])
		return false;
	
	NSArray *debitCardTypes = [NSArray arrayWithObjects:@"switch", @"solo"];
	NSString *curCardType;
	NSEnumerator *enumerator = [debitCardTypes objectEnumerator];
	while (curCardType = [enumerator nextObject]) {
		if ([[self cardBrand:creditCard] isEqualToString:curCardType])
			return true;
	}
	return false;
}


//
// Public
//

- (id) init:(NSDictionary *)options
{
	return self;
}

- (NSString *) cardBrand:(id)source
{
	return [BillingGateway cardBrand:source];
}
		
- (bool) is_test
{
	return ([BillingBase gatewayMode] == TEST);
}


//
// Class Inheritable Accessors
//
static NSString* _BillingGateway_moneyFormat = @"dollars";
static NSString* _BillingGateway_defaultCurrency = nil;
static NSArray* _BillingGateway_supportedCountries = nil;
static NSArray* _BillingGateway_supportedCardtypes = nil;
static NSString* _BillingGateway_homepageUrl = nil;
static NSString* _BillingGateway_displayName = nil;
static NSString* _BillingGateway_applicationId = @"ActiveMerchant";

+ (NSString *) moneyFormat
{
	return _BillingGateway_moneyFormat;
}
+ (void) setMoneyFormat:(NSString *)format
{
	_BillingGateway_moneyFormat = format;
}
+ (NSString *) defaultCurrency
{
	return _BillingGateway_defaultCurrency;
}
+ (void) setDefaultCurrency:(NSString *)currency
{
	_BillingGateway_defaultCurrency = currency;
}
+ (NSArray *) supportedCountries
{
	if (_BillingGateway_supportedCountries==nil) {
		_BillingGateway_supportedCountries = [[NSArray alloc] init];
	}
	return _BillingGateway_supportedCountries;
}
+ (void) setSupportedCountries:(NSArray *)countries
{
	if (_BillingGateway_supportedCountries!=nil)
		[_BillingGateway_supportedCountries release];
	_BillingGateway_supportedCountries = countries;
}
+ (NSArray *) supportedCardtypes
{
	if (_BillingGateway_supportedCardtypes==nil) {
		_BillingGateway_supportedCardtypes = [[NSArray alloc] init];
	}
	return _BillingGateway_supportedCardtypes;
}
+ (void) setSupportedCardtypes:(NSArray *)cardtypes
{
	if (_BillingGateway_supportedCardtypes!=nil)
		[_BillingGateway_supportedCardtypes release];
	_BillingGateway_supportedCardtypes = cardtypes;
}
+ (NSString *) homepageUrl
{
	return _BillingGateway_homepageUrl;
}
+ (void) setHomepageUrl:(NSString *)url
{
	_BillingGateway_homepageUrl = url;	
}
+ (NSString *) displayName
{
	return _BillingGateway_displayName;
}
+ (void) setDisplayName:(NSString *)dname
{
	_BillingGateway_displayName = dname;	
}
+ (NSString *) applicationId
{
	return _BillingGateway_applicationId;
}
+ (void) setApplicationId:(NSString *)appid
{
	_BillingGateway_applicationId = appid;	
}



+ (bool) has_support_for:(NSString*)cardType
{
	NSString *curCardType;
	NSEnumerator *enumerator = [[self supportedCardtypes] objectEnumerator];
	while (curCardType = [enumerator nextObject]) {
		if ([curCardType isEqualToString:cardType])
			return true;
	}
	return false;
}
		
+ (NSString *) cardBrand:(id)source
{
	NSString *result;
	if ([source respondsToSelector:@selector(brand)]) { 
		result = [source performSelector:@selector(brand)]; 
	}
		else { 
		result = [source type];
	}
		
	return [NSString stringWithString:[result lowercaseString]];
}

#include "RequiresParameters_Implementation.h"
#include "CreditCardFormatting_Implementation.h"
#include "PostsData_Implementation.h"
#include "Utils_Implementation.h"

@end
