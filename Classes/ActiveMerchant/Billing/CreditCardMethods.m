//
//  CreditCardMethods.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "CreditCard.h"
#import "CreditCardMethods.h"
#import "RegexKitLite.h"
#import "Base.h"

@implementation BillingCreditCard (Methods)

- (bool) is_validMonth:(NSNumber*)_month
{
	return ([_month intValue] >= 1 && [_month intValue] <= 12);
}
- (bool) is_validExpiryYear:(NSNumber*)_year
{
	NSDate *today = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dateComponents = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:today];
	int todayYear = [dateComponents year];
	return ([_year intValue] >= todayYear && [_year intValue] <= (todayYear + 20));
}
- (bool) is_validStartYear:(NSNumber*)_year
{
	return ([[NSString stringWithFormat:@"%d", [_year intValue]] isMatchedByRegex:@"^\\d{4}$"] && ([_year intValue] > 1987));
}
- (bool) is_validIssueNumber:(NSNumber*)_number
{
	return [[NSString stringWithFormat:@"%d", [_number intValue]] isMatchedByRegex:@"^\\d{1,2}$"];
}



static NSDictionary* _BillingCreditCard_cardCompanies = nil;

//
// Private
//
+ (bool) is_validCardNumberLength:(NSString *)number
{
	return ([number length] >= 12);
}

+ (bool) is_validTestModeCardNumber:(NSString *)number
{
	if ([BillingBase is_test_mode]) 
	{
		if ([number isEqualToString:@"1"]) return true;
		if ([number isEqualToString:@"2"]) return true;
		if ([number isEqualToString:@"3"]) return true;
		if ([number isEqualToString:@"success"]) return true;
		if ([number isEqualToString:@"failure"]) return true;
		if ([number isEqualToString:@"error"]) return true;		
	}
	return false;	
}

//# Checks the validity of a card number by use of the the Luhn Algorithm. 
//# Please see http:// en.wikipedia.org/wiki/Luhn_algorithm for details.
+ (bool) is_validChecksum:(NSString *)number
{
	int sum = 0;
	for (int i=0; i < [number length]; i++)
	{
		int weight = [[number substringWithRange:NSMakeRange([number length]-1*(i+2), 1)] intValue] * (2 - (i % 2));
		sum += (weight < 10) ? weight : weight - 9;
	}
	return ( [[number substringWithRange:NSMakeRange([number length]-1, 1)] intValue] == ((10 - sum % 10) % 10) );
}


//
// Public 
//
+ (bool) is_validNumber:(NSString *)number
{
	return [BillingCreditCard is_validTestModeCardNumber:number] || 
			[BillingCreditCard is_validCardNumberLength:number] &&
			[BillingCreditCard is_validChecksum:number];
}

+ (NSDictionary *)cardCompanies
{
	if (_BillingCreditCard_cardCompanies==nil)
	{
	_BillingCreditCard_cardCompanies = [NSDictionary dictionaryWithObjectsAndKeys:	
										@"^4\\d{12}(\\d{3})?$", @"visa", 
										@"^(5[1-5]\\d{4}|677189)\\d{10}$", @"master", 
										@"^(6011|65\\d{2})\\d{12}$", @"discover", 
										@"^3[47]\\d{13}$", @"american_express", 
										@"^3(0[0-5]|[68]\\d)\\d{11}$", @"diners_club", 
										@"^3528\\d{12}$", @"jcb", 
										@"^6759\\d{12}(\\d{2,3})?$", @"switch", 
										@"^6767\\d{12}(\\d{2,3})?$", @"solo", 
										@"^5019\\d{12}$", @"dankort", 
										@"^(5[06-8]|6\\d)\\d{10,17}$", @"maestro", 
										@"^600722\\d{10}$", @"forbrugsforeningen", 
										@"^(6304[89]\\d{11}(\\d{2,3})?|670695\\d{13})$", @"laser", 
										nil];
		[_BillingCreditCard_cardCompanies retain];
	}
	return _BillingCreditCard_cardCompanies;
}

+ (NSString *)getType:(NSString *)number
{
	if ([BillingCreditCard is_validTestModeCardNumber:number])
		return @"bogus";
	
	NSDictionary *companies = [BillingCreditCard cardCompanies];
	NSString *company;
	NSEnumerator *enumerator = [companies keyEnumerator];
	while (company = [enumerator nextObject]) {
		if (![company isEqualToString:@"maestro"])
		{
			if ([number isMatchedByRegex:[companies objectForKey:company]])
				return [NSString stringWithString:company];
		}
	}
	
	if ([number isMatchedByRegex:[companies objectForKey:@"maestro"]])
		return @"maestro";
	
	return nil;
}

+ (NSString *)getTypeWithPartialNumber:(NSString *)partialNumber
{
	NSString *fullNumber15 = [partialNumber  stringByPaddingToLength:15 withString:@"0" startingAtIndex:0];
	assert([fullNumber15 length] == 15);
	
	NSString *fullNumber16 = [partialNumber  stringByPaddingToLength:16 withString:@"0" startingAtIndex:0];
	assert([fullNumber16 length] == 16);
	
	// First we try 16-number matches
	NSString *match = [BillingCreditCard getType:fullNumber16];
	if (match!=nil)
		return match;

	// Then we try 15-number matches
	return [BillingCreditCard getType:fullNumber15];
}

+ (NSString *)lastDigits:(NSString *)number
{
	if ([number length] <= 4) {
		return number;
	}
	return [number substringWithRange:NSMakeRange([number length] - 5, 4)];
}

+ (NSString *)mask:(NSString *)number
{
	return [NSString stringWithFormat:@"XXXX-XXXX-XXXX-%@", [BillingCreditCard lastDigits:number]];
}

+ (bool) is_matchingType:(NSString *)number type:(NSString *)type
{
	return [[BillingCreditCard getType:number] isEqualToString:type];
}


@end
