//
//  AVSResult.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "AvsResult.h"
#import "objCFixes.h"

//# Implements the Address Verification System
//# https:// www.wellsfargo.com/downloads/pdf/biz/merchant/visa_avs.pdf
//# http:// en.wikipedia.org/wiki/Address_Verification_System
//# http:// apps.cybersource.com/library/documentation/dev_guides/CC_Svcs_IG/html/app_avs_cvn_codes.htm#app_AVS_CVN_codes_7891_48375
//# http:// imgserver.skipjack.com/imgServer/5293710/AVS%20and%20CVV2.pdf
//# http:// www.emsecommerce.net/avs_cvv2_response_codes.htm
@implementation BillingAvsResult

static NSDictionary* _BillingAvsResult_messages = nil;
static NSDictionary* _BillingAvsResult_postalMatchCodes = nil;
static NSDictionary* _BillingAvsResult_streetMatchCodes = nil;

@synthesize code, message, streetMatch, postalMatch;

- (id) initWithCode:(NSString*)a_code streetMatch:(NSString*)a_streetMatch postalMatch:(NSString*)a_postalMatch
{
	if (a_code!=nil && [a_code length]>0) { 
		code = [a_code uppercaseString]; 		
		message = [[BillingAvsResult messages] objectForKey:code];
	}
	if (a_streetMatch!=nil && [a_streetMatch length]>0) { 
		streetMatch = [a_streetMatch uppercaseString];
	} else {
		streetMatch = [[BillingAvsResult streetMatchCodes] objectForKey:code];
	}
	if (a_postalMatch!=nil && [a_postalMatch length]>0) { 
		postalMatch = [a_postalMatch uppercaseString];
	} else {
		postalMatch = [[BillingAvsResult postalMatchCodes] objectForKey:code];
	}
	return self;
}
- (id) initWithCode:(NSString*)a_code streetMatch:(NSString*)a_streetMatch
{
	return [self initWithCode:a_code streetMatch:a_streetMatch postalMatch:nil];
}
- (id) initWithCode:(NSString*)a_code
{
	return [self initWithCode:a_code streetMatch:nil postalMatch:nil];
}
- (id) init:(NSDictionary*)_attrs
{
	return [self initWithCode:[_attrs objectForKey:@"code"] streetMatch:[_attrs objectForKey:@"streetMatch"] postalMatch:[_attrs objectForKey:@"postalMatch"]];
}

+ (NSDictionary*)messages
{
	if (_BillingAvsResult_messages==nil)
	{
		_BillingAvsResult_messages = [NSDictionary dictionaryWithObjectsAndKeys:
						@"Street address matches, but 5-digit and 9-digit postal code do not match.", @"A", 
						@"Street address matches, but postal code not verified.", @"B", 
						@"Street address and postal code do not match.", @"C", 
						@"Street address and postal code match.", @"D", 
						@"AVS data is invalid or AVS is not allowed for this card type.", @"E", 
						@"Card member’s name does not match, but billing postal code matches.", @"F", 
						@"Non-U.S. issuing bank does not support AVS.", @"G", 
						@"Card member’s name does not match. Street address and postal code match.", @"H", 
						@"Address not verified.", @"I", 
						@"Card member’s name, billing address, and postal code match. Shipping information verified and chargeback protection guaranteed through the Fraud Protection Program.", @"J", 
						@"Card member’s name matches but billing address and billing postal code do not match.", @"K", 
						@"Card member’s name and billing postal code match, but billing address does not match.", @"L", 
						@"Street address and postal code match.", @"M", 
						@"Street address and postal code do not match.", @"N", 
						@"Card member’s name and billing address match, but billing postal code does not match.", @"O", 
						@"Postal code matches, but street address not verified.", @"P", 
						@"Card member’s name, billing address, and postal code match. Shipping information verified but chargeback protection not guaranteed.", @"Q", 
						@"System unavailable.", @"R", 
						@"U.S.-issuing bank does not support AVS.", @"S", 
						@"Card member’s name does not match, but street address matches.", @"T", 
						@"Address information unavailable.", @"U", 
						@"Card member’s name, billing address, and billing postal code match.", @"V", 
						@"Street address does not match, but 9-digit postal code matches.", @"W", 
						@"Street address and 9-digit postal code match.", @"X", 
						@"Street address and 5-digit postal code match.", @"Y", 
						@"Street address does not match, but 5-digit postal code matches.", @"Z", 
						nil];			
	}
	return _BillingAvsResult_messages;
}

+ (NSDictionary*)postalMatchCodes
{
	if (_BillingAvsResult_postalMatchCodes==nil)
	{
		//'Y' => %w( D H F H J L M P Q V W X Y Z ),
		//'N' => %w( A C K N O ),
		//'X' => %w( G S ),
		//nil => %w( B E I R T U )
		NSArray *_y_codes = [NSArray arrayWithObjects: @"D",@"H",@"F",@"H",@"J",@"L",@"M",@"P",@"Q",@"V",@"W",@"X",@"Y",@"Z", nil];
		NSArray *_n_codes = [NSArray arrayWithObjects: @"A",@"C",@"K",@"N",@"O", nil];
		NSArray *_x_codes = [NSArray arrayWithObjects: @"G",@"S", nil];		
		NSArray *_nil_codes = [NSArray arrayWithObjects: @"B",@"E",@"I",@"R",@"T",@"U", nil];

		_BillingAvsResult_postalMatchCodes = [[NSMutableDictionary alloc] init];
		
		id currentCode;
		NSEnumerator *enumerator;
		enumerator = [_y_codes objectEnumerator];
		while (currentCode = [enumerator nextObject]) {
			[(NSMutableDictionary*)_BillingAvsResult_postalMatchCodes setObject:@"Y" forKey:currentCode];
		}
		enumerator = [_n_codes objectEnumerator];
		while (currentCode = [enumerator nextObject]) {
			[(NSMutableDictionary*)_BillingAvsResult_postalMatchCodes setObject:@"N" forKey:currentCode];
		}
		enumerator = [_x_codes objectEnumerator];
		while (currentCode = [enumerator nextObject]) {
			[(NSMutableDictionary*)_BillingAvsResult_postalMatchCodes setObject:@"X" forKey:currentCode];
		}
		enumerator = [_nil_codes objectEnumerator];
		while (currentCode = [enumerator nextObject]) {
			[(NSMutableDictionary*)_BillingAvsResult_postalMatchCodes setObject:nilToNull(nil) forKey:currentCode];
		}
	}
	return _BillingAvsResult_postalMatchCodes;
}

+ (NSDictionary*)streetMatchCodes
{
	if (_BillingAvsResult_streetMatchCodes==nil)
	{
		//'Y' => %w( A B D H J M O Q T V X Y ),
		//'N' => %w( C K L N P W Z ),
		//'X' => %w( G S ),
		//nil => %w( E F I R U )
		NSArray *_y_codes = [NSArray arrayWithObjects: @"A",@"B",@"D",@"H",@"J",@"M",@"O",@"Q",@"T",@"V",@"X",@"Y", nil];
		NSArray *_n_codes = [NSArray arrayWithObjects: @"C",@"K",@"L",@"N",@"P",@"W",@"Z", nil];
		NSArray *_x_codes = [NSArray arrayWithObjects: @"G",@"S", nil];		
		NSArray *_nil_codes = [NSArray arrayWithObjects: @"E",@"F",@"I",@"R",@"U", nil];
		
		_BillingAvsResult_streetMatchCodes = [[NSMutableDictionary alloc] init];
		
		id currentCode;
		NSEnumerator *enumerator;		
		enumerator = [_y_codes objectEnumerator];
		while (currentCode = [enumerator nextObject]) {
			[(NSMutableDictionary*)_BillingAvsResult_streetMatchCodes setObject:@"Y" forKey:currentCode];
		}
		enumerator = [_n_codes objectEnumerator];
		while (currentCode = [enumerator nextObject]) {
			[(NSMutableDictionary*)_BillingAvsResult_streetMatchCodes setObject:@"N" forKey:currentCode];
		}
		enumerator = [_x_codes objectEnumerator];
		while (currentCode = [enumerator nextObject]) {
			[(NSMutableDictionary*)_BillingAvsResult_streetMatchCodes setObject:@"X" forKey:currentCode];
		}
		enumerator = [_nil_codes objectEnumerator];
		while (currentCode = [enumerator nextObject]) {
			[(NSMutableDictionary*)_BillingAvsResult_streetMatchCodes setObject:nilToNull(nil) forKey:currentCode];
		}
	}
	return _BillingAvsResult_streetMatchCodes;
}

- (NSDictionary*)toDictionary
{
	return [NSDictionary dictionaryWithObjectsAndKeys:	
			code, @"code", 
			message, @"message", 
			streetMatch, @"streetMatch", 
			postalMatch, @"postalMatch", 
			nil];			
}

@end
