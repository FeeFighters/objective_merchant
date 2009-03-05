//
//  BogusGateway.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/13/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "BogusGateway.h"
#import "objCFixes.h"

@implementation BogusGateway

static NSString * _AUTHORIZATION = @"53433";
static NSString* _SUCCESS_MESSAGE = @"Bogus Gateway: Forced success";
static NSString* _FAILURE_MESSAGE = @"Bogus Gateway: Forced failure";
static NSString* _ERROR_MESSAGE = @"Bogus Gateway: Use CreditCard number 1 for success, 2 for exception and anything else for error";
static NSString* _CREDIT_ERROR_MESSAGE = @"Bogus Gateway: Use trans_id 1 for success, 2 for exception and anything else for error";
static NSString* _UNSTORE_ERROR_MESSAGE = @"Bogus Gateway: Use trans_id 1 for success, 2 for exception and anything else for error";
static NSString* _CAPTURE_ERROR_MESSAGE = @"Bogus Gateway: Use authorization number 1 for exception, 2 for error and anything else for success";


- (BillingResponse *) authorize:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)options
{
	if ([[creditcard number] isEqualToString:@"1"])
		return [[BillingResponse alloc] init:true 
									 message:_SUCCESS_MESSAGE 
									  params:[NSDictionary dictionaryWithObject:money forKey:@"authorizedAmount"]
									 options:[NSDictionary dictionaryWithObjectsAndKeys:
												MakeBool(true), @"test",
												_AUTHORIZATION, @"authorization",
												nil]
				];	
	else if ([[creditcard number] isEqualToString:@"2"])
		return [[BillingResponse alloc] init:false 
									 message:_FAILURE_MESSAGE 
									  params:[NSDictionary dictionaryWithObject:money forKey:@"authorizedAmount"]
									 options:[NSDictionary dictionaryWithObjectsAndKeys:
											  MakeBool(true), @"test", nil]
				];

	[NSException raise:@"Error"	format:_ERROR_MESSAGE];
	return nil;
}

- (BillingResponse *) purchase:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)options
{
	if ([[creditcard number] isEqualToString:@"1"])
		return [[BillingResponse alloc] init:true 
									 message:_SUCCESS_MESSAGE 
									  params:[NSDictionary dictionaryWithObject:money forKey:@"paidAmount"]
									 options:[NSDictionary dictionaryWithObjectsAndKeys:
											  MakeBool(true), @"test", nil]
				];	
	else if ([[creditcard number] isEqualToString:@"2"])
		return [[BillingResponse alloc] init:false 
									 message:_FAILURE_MESSAGE 
									  params:[NSDictionary dictionaryWithObject:money forKey:@"paidAmount"]
									 options:[NSDictionary dictionaryWithObjectsAndKeys:
											  MakeBool(true), @"test", nil]
				];
	
	[NSException raise:@"Error"	format:_ERROR_MESSAGE];
	return nil;
}

- (BillingResponse *) capture:(id)money identification:(NSString*)identification options:(NSDictionary*)options
{
	if ([identification isEqualToString:@"1"]) {
		[NSException raise:@"Error"	format:_CAPTURE_ERROR_MESSAGE];
		return nil;		
	}
	else if ([identification isEqualToString:@"2"])
		return [[BillingResponse alloc] init:false 
									 message:_FAILURE_MESSAGE 
									  params:[NSDictionary dictionaryWithObject:money forKey:@"paidAmount"]
									 options:[NSDictionary dictionaryWithObjectsAndKeys:
											  MakeBool(true), @"test", nil]
				];

	return [[BillingResponse alloc] init:true 
								 message:_SUCCESS_MESSAGE 
								  params:[NSDictionary dictionaryWithObject:money forKey:@"paidAmount"]
								 options:[NSDictionary dictionaryWithObjectsAndKeys:
										  MakeBool(true), @"test", nil]
			];	
}

- (BillingResponse *) credit:(id)money identification:(NSString*)identification options:(NSDictionary*)options
{
	if ([identification isEqualToString:@"1"]) {
		[NSException raise:@"Error"	format:_CREDIT_ERROR_MESSAGE];
		return nil;		
	}
	else if ([identification isEqualToString:@"2"])
		return [[BillingResponse alloc] init:false 
									 message:_FAILURE_MESSAGE 
									  params:[NSDictionary dictionaryWithObject:money forKey:@"paidAmount"]
									 options:[NSDictionary dictionaryWithObjectsAndKeys:
											  MakeBool(true), @"test", nil]
				];
	
	return [[BillingResponse alloc] init:true 
								 message:_SUCCESS_MESSAGE 
								  params:[NSDictionary dictionaryWithObject:money forKey:@"paidAmount"]
								 options:[NSDictionary dictionaryWithObjectsAndKeys:
										  MakeBool(true), @"test", nil]
			];	
}

- (BillingResponse *) store:(BillingCreditCard*)creditcard options:(NSDictionary*)options
{
	if ([[creditcard number] isEqualToString:@"1"])
		return [[BillingResponse alloc] init:true 
									 message:_SUCCESS_MESSAGE 
									  params:[NSDictionary dictionaryWithObject:@"1" forKey:@"billingId"]
									 options:[NSDictionary dictionaryWithObjectsAndKeys:
											  MakeBool(true), @"test",
											  _AUTHORIZATION, @"authorization",
											  nil]
				];	
	else if ([[creditcard number] isEqualToString:@"2"])
		return [[BillingResponse alloc] init:false 
									 message:_FAILURE_MESSAGE 
									  params:[NSDictionary dictionaryWithObjectsAndKeys:
											  nilToNull(nil), @"billingId",
											  _FAILURE_MESSAGE, @"error",
											  nil]
									 options:[NSDictionary dictionaryWithObjectsAndKeys:
											  MakeBool(true), @"test", nil]
				];
	
	[NSException raise:@"Error"	format:_ERROR_MESSAGE];
	return nil;	
}

- (BillingResponse *) unstore:(NSString*)identification options:(NSDictionary*)options
{
	if ([identification isEqualToString:@"1"])
		return [[BillingResponse alloc] init:true 
									 message:_SUCCESS_MESSAGE 
									  params:[[NSDictionary alloc] init]
									 options:[NSDictionary dictionaryWithObjectsAndKeys:
											  MakeBool(true), @"test", nil]
				];	
	else if ([identification isEqualToString:@"2"])
		return [[BillingResponse alloc] init:false 
									 message:_FAILURE_MESSAGE 
									  params:[NSDictionary dictionaryWithObjectsAndKeys:
											  _FAILURE_MESSAGE, @"error", nil]
									 options:[NSDictionary dictionaryWithObjectsAndKeys:
											  MakeBool(true), @"test", nil]
				];
	
	[NSException raise:@"Error"	format:_UNSTORE_ERROR_MESSAGE];
	return nil;		
}



static NSArray* _BogusGateway_supportedCountries = nil;
static NSArray* _BogusGateway_supportedCardtypes = nil;
static NSString* _BogusGateway_homepageUrl = nil;
static NSString* _BogusGateway_displayName = nil;

+ (NSArray *) supportedCountries
{
	if (_BogusGateway_supportedCountries==nil) {
		_BogusGateway_supportedCountries = [[[NSArray alloc] init] retain];
	}
	return _BogusGateway_supportedCountries;
}
+ (void) setSupportedCountries:(NSArray *)countries
{
	if (_BogusGateway_supportedCountries!=nil)
		[_BogusGateway_supportedCountries release];
	_BogusGateway_supportedCountries = countries;
}
+ (NSArray *) supportedCardtypes
{
	if (_BogusGateway_supportedCardtypes==nil) {
		_BogusGateway_supportedCardtypes = [[[NSArray alloc] init] retain];
	}
	return _BogusGateway_supportedCardtypes;
}
+ (void) setSupportedCardtypes:(NSArray *)cardtypes
{
	if (_BogusGateway_supportedCardtypes!=nil)
		[_BogusGateway_supportedCardtypes release];
	_BogusGateway_supportedCardtypes = cardtypes;
}
+ (NSString *) homepageUrl
{
	return _BogusGateway_homepageUrl;
}
+ (void) setHomepageUrl:(NSString *)url
{
	_BogusGateway_homepageUrl = url;	
}
+ (NSString *) displayName
{
	return _BogusGateway_displayName;
}
+ (void) setDisplayName:(NSString *)dname
{
	_BogusGateway_displayName = dname;	
}


@end
