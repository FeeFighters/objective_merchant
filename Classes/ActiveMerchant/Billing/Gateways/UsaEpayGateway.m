//
//  AuthorizeNetGateway.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "UsaEpayGateway.h"
#import "RegexKitLite.h"
#import "objCFixes.h"
#import "CvvResult.h"
#import "AvsResult.h"

@interface UsaEpayGateway (Private)
- (void) addAmount:(NSMutableDictionary *)post money:(id)money;
- (NSString *) expdate:(BillingCreditCard *)creditcard;
- (void) addCustomerData:(NSMutableDictionary *)post options:(NSDictionary *)_options;
- (void) addAddress:(NSMutableDictionary *)post creditcard:(BillingCreditCard *)creditcard options:(NSDictionary *)_options;
- (void) addAddressForType:(NSString*)type
                      post:(NSMutableDictionary*)post
                creditcard:(BillingCreditCard*)creditcard
                   address:(NSDictionary*)address;
- (NSString *) addressKeyPrefix:(NSString *)type;
- (NSString *) addressPrefix:(NSString *)prefix key:(NSString *)key;
- (void) addInvoice:(NSMutableDictionary *)post options:(NSDictionary *)_options;
- (void) addCreditCard:(NSMutableDictionary *)post creditcard:(BillingCreditCard *)creditcard;
- (NSDictionary *) parse:(NSString *)body;
- (BillingResponse *) commit:(NSString*)action parameters:(NSMutableDictionary*)parameters;
- (NSString *) messageFrom:(NSDictionary*)response;
- (NSString *) postData:(NSString *)action parameters:(NSMutableDictionary*)parameters;
@end


@implementation UsaEpayGateway

//
// Public
//

- (id) init:(NSMutableDictionary *)_options
{
	[self requires:_options, @"login", nil];
	options = _options;
	return [super init:_options];
}

- (NSString *) GatewayUrl
{
	if ([self isTest])
		return [UsaEpayGateway SandboxUrl];

	return [UsaEpayGateway Url];
}


- (BillingResponse *) authorize:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)_options
{
	NSMutableDictionary *post = [[NSMutableDictionary alloc] init];
	[self addAmount:post money:money];
	[self addInvoice:post options:_options];
	[self addCreditCard:post creditcard:creditcard];
	[self addAddress:post creditcard:creditcard options:_options];
	[self addCustomerData:post options:_options];

	return [self commit:@"authorization" parameters:post];
}

- (BillingResponse *) purchase:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)_options
{
	NSMutableDictionary *post = [[NSMutableDictionary alloc] init];
	[self addAmount:post money:money];
	[self addInvoice:post options:_options];
	[self addCreditCard:post creditcard:creditcard];
	[self addAddress:post creditcard:creditcard options:_options];
	[self addCustomerData:post options:_options];

	return [self commit:@"purchase" parameters:post];
}

- (BillingResponse *) capture:(id)money authorization:(NSString*)authorization options:(NSDictionary*)_options
{
	NSMutableDictionary *post = [[NSMutableDictionary alloc] init];
	[post setObject:nilToNull(authorization) forKey:@"refNum"];

	[self addAmount:post money:money];

	return [self commit:@"capture" parameters:post];
}

//
// Private
//

- (void) addAmount:(NSMutableDictionary *)post money:(id)money
{
	[post setObject:nilToNull([self amount:money]) forKey:@"amount"];
}

- (NSString *) expdate:(BillingCreditCard *)creditcard
{
	NSString *year = [self format:[creditcard year] option:@"twoDigits"];
	NSString *month = [self format:[creditcard month] option:@"twoDigits"];
	return [NSString stringWithFormat:@"%@%@", month, year, nil];
}

- (void) addCustomerData:(NSMutableDictionary *)post options:(NSDictionary *)_options
{
	NSDictionary *address;
	if (![NSNull isNull:[_options objectForKey:@"billingAddress"]]) {
		address = [_options objectForKey:@"billingAddress"];
	}
	else if (![NSNull isNull:[_options objectForKey:@"address"]]) {
		address = [_options objectForKey:@"address"];
	}
	else {
		address = [[NSDictionary alloc] init];
	}

	if (![NSString isBlank:[address objectForKey:@"address1"]])
		[post setObject:nilToNull([address objectForKey:@"address1"]) forKey:@"street"];
	if (![NSString isBlank:[address objectForKey:@"zip"]])
		[post setObject:nilToNull([address objectForKey:@"zip"]) forKey:@"zip"];

	if (![NSNull isNull:[_options objectForKey:@"email"]]) {
		[post setObject:nilToNull([_options objectForKey:@"email"]) forKey:@"custemail"];
		[post setObject:nilToNull(@"No") forKey:@"custreceipt"];
	}

	if (![NSNull isNull:[_options objectForKey:@"customer"]]) {
		[post setObject:nilToNull([_options objectForKey:@"customer"]) forKey:@"custid"];
	}

	if (![NSNull isNull:[_options objectForKey:@"ip"]]) {
		[post setObject:nilToNull([_options objectForKey:@"ip"]) forKey:@"ip"];
	}
}

- (void) addAddress:(NSMutableDictionary *)post creditcard:(BillingCreditCard *)creditcard options:(NSDictionary *)_options
{
	NSDictionary *billingAddress = [_options objectForKey:@"billingAddress"];
	if (!billingAddress) {
		billingAddress = [_options objectForKey:@"address"];
	}

	if (billingAddress) {
		[self addAddressForType:@"billing" post:post creditcard:creditcard address:billingAddress];
	}
	if (![NSNull isNull:[_options objectForKey:@"shippingAddress"]]) {
		[self addAddressForType:@"shipping" post:post creditcard:creditcard address:[_options objectForKey:@"shippingAddress"]];
	}
}

- (void) addAddressForType:(NSString*)type
                      post:(NSMutableDictionary*)post
                creditcard:(BillingCreditCard*)creditcard
                   address:(NSDictionary*)address
{
	NSString *prefix = [self addressKeyPrefix:type];

	[post setObject:nilToNull([creditcard firstName]) forKey:[self addressPrefix:prefix key:@"fname"]];
	[post setObject:nilToNull([creditcard lastName]) forKey:[self addressPrefix:prefix key:@"lname"]];
	if (![NSString isBlank:[address objectForKey:@"company"]]) {
		[post setObject:nilToNull([address objectForKey:@"company"]) forKey:[self addressPrefix:prefix key:@"company"]];
	}
	if (![NSString isBlank:[address objectForKey:@"address1"]]) {
		[post setObject:nilToNull([address objectForKey:@"address1"]) forKey:[self addressPrefix:prefix key:@"street"]];
	}
	if (![NSString isBlank:[address objectForKey:@"address2"]]) {
		[post setObject:nilToNull([address objectForKey:@"address2"]) forKey:[self addressPrefix:prefix key:@"street2"]];
	}
	if (![NSString isBlank:[address objectForKey:@"city"]]) {
		[post setObject:nilToNull([address objectForKey:@"city"]) forKey:[self addressPrefix:prefix key:@"city"]];
	}
	if (![NSString isBlank:[address objectForKey:@"state"]]) {
		[post setObject:nilToNull([address objectForKey:@"state"]) forKey:[self addressPrefix:prefix key:@"state"]];
	}
	if (![NSString isBlank:[address objectForKey:@"zip"]]) {
		[post setObject:nilToNull([address objectForKey:@"zip"]) forKey:[self addressPrefix:prefix key:@"zip"]];
	}
	if (![NSString isBlank:[address objectForKey:@"country"]]) {
		[post setObject:nilToNull([address objectForKey:@"country"]) forKey:[self addressPrefix:prefix key:@"country"]];
	}
	if (![NSString isBlank:[address objectForKey:@"phone"]]) {
		[post setObject:nilToNull([address objectForKey:@"phone"]) forKey:[self addressPrefix:prefix key:@"phone"]];
	}
}

- (NSString *) addressKeyPrefix:(NSString *)type
{
	if ([type isEqualToString:@"shipping"]) return @"ship";
	return @"bill";
}

- (NSString *) addressPrefix:(NSString *)prefix key:(NSString *)key
{
	return [NSString stringWithFormat:@"%@%@", prefix, key, nil];
}

- (void) addInvoice:(NSMutableDictionary *)post options:(NSDictionary *)_options
{
	if (![NSString isBlank:[_options objectForKey:@"orderId"]])
		[post setObject:nilToNull([_options objectForKey:@"orderId"]) forKey:@"invoice"];
}

- (void) addCreditCard:(NSMutableDictionary *)post creditcard:(BillingCreditCard *)creditcard
{
	[post setObject:nilToNull([creditcard number]) forKey:@"card"];
	if (![NSNull isNull:[creditcard verificationValue]]) {
		[post setObject:nilToNull([creditcard verificationValue]) forKey:@"cvv2"];
	}
	[post setObject:nilToNull([self expdate:creditcard]) forKey:@"expir"];
	[post setObject:nilToNull([creditcard name]) forKey:@"name"];
}

- (NSDictionary *) parse:(NSString *)body
{
	NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
	NSArray *lines = [body componentsSeparatedByString:@"&"];

	NSString *line;
	NSEnumerator *enumerator = [lines objectEnumerator];
	while (line = [enumerator nextObject]) {
		NSString *key = [line stringByMatching:@"^(\\w+)\\=(.*)$" capture:1];
		NSString *obj = [line stringByMatching:@"^(\\w+)\\=(.*)$" capture:2];
		[fields setObject:nilToNull([obj stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding]) forKey:key];
	}

	NSMutableDictionary *returnParams = [[NSMutableDictionary alloc] init];
	[returnParams setObject:nilToNull([fields objectForKey:@"UMstatus"]) forKey:@"status"];
	[returnParams setObject:nilToNull([fields objectForKey:@"UMauthCode"]) forKey:@"authCode"];
	[returnParams setObject:nilToNull([fields objectForKey:@"UMrefNum"]) forKey:@"refNum"];
	[returnParams setObject:nilToNull([fields objectForKey:@"UMbatch"]) forKey:@"batch"];
	[returnParams setObject:nilToNull([fields objectForKey:@"UMavsResult"]) forKey:@"avsResult"];
	[returnParams setObject:nilToNull([fields objectForKey:@"UMavsResultCode"]) forKey:@"avsResultCode"];
	[returnParams setObject:nilToNull([fields objectForKey:@"UMcvv2Result"]) forKey:@"cvv2Result"];
	[returnParams setObject:nilToNull([fields objectForKey:@"UMcvv2ResultCode"]) forKey:@"cvv2ResultCode"];
	[returnParams setObject:nilToNull([fields objectForKey:@"UMvpasResultCode"]) forKey:@"vpasResultCode"];
	[returnParams setObject:nilToNull([fields objectForKey:@"UMresult"]) forKey:@"result"];
	[returnParams setObject:nilToNull([fields objectForKey:@"UMerror"]) forKey:@"error"];
	[returnParams setObject:nilToNull([fields objectForKey:@"UMerrorcode"]) forKey:@"errorCode"];
	[returnParams setObject:nilToNull([fields objectForKey:@"UMacsurl"]) forKey:@"acsUrl"];
	[returnParams setObject:nilToNull([fields objectForKey:@"UMpayload"]) forKey:@"payload"];

	NSString *key;
	NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
	enumerator = [returnParams keyEnumerator];
	while (key = [enumerator nextObject]) {
		if (![NSNull isNull:[returnParams objectForKey:key]])
			[ret setObject:[returnParams objectForKey:key] forKey:key];
	}

	return ret;
}

- (BillingResponse *) commit:(NSString*)action parameters:(NSMutableDictionary*)parameters
{
	NSDictionary *response = [self parse:[self sslPost:[self GatewayUrl]
                                                data:[self postData:action
                                                         parameters:parameters]
                                             headers:nil]];


	bool test;
	if (![NSNull isNull:[[self options] objectForKey:@"test"]]) {
		test = [[self options] objectForKey:@"test"];
	} else {
		test = [self isTest];
	}

	NSDictionary *avsResult;
	if (![NSString isBlank:[response objectForKey:@"avsResultCode"]]) {
		avsResult = [NSDictionary dictionaryWithObjectsAndKeys:
																		[[response objectForKey:@"avsResultCode"] substringWithRange:NSMakeRange(0,1)], @"streetMatch",
																		[[response objectForKey:@"avsResultCode"] substringWithRange:NSMakeRange(1,1)], @"postalMatch",
																		[[response objectForKey:@"avsResultCode"] substringWithRange:NSMakeRange(2,1)], @"code",
																		nil];
	} else {
		avsResult = [[NSDictionary alloc] init];
	}

	return [[BillingResponse alloc] init:[[response objectForKey:@"status"] isEqualToString:@"Approved"]
                               message:[self messageFrom:response]
                                params:response
                               options:[NSDictionary dictionaryWithObjectsAndKeys:
																						MakeBool(test), @"test",
																						[response objectForKey:@"refNum"], @"authorization",
																						[response objectForKey:@"cvv2ResultCode"], @"cvvResult",
																						avsResult, @"avsResult",
																						nil]];
}

- (NSString *) messageFrom:(NSDictionary*)response
{
	if ([[response objectForKey:@"status"] isEqualToString:@"Approved"])
		return @"Success";

	if ([NSString isBlank:[response objectForKey:@"error"]])
		return @"Unspecified error";

	return [response objectForKey:@"error"];
}

- (NSString *) postData:(NSString *)action parameters:(NSMutableDictionary*)parameters
{
	[parameters setObject:[[UsaEpayGateway Transactions] objectForKey:action] forKey:@"command"];
	[parameters setObject:[[self options] objectForKey:@"login"] forKey:@"key"];
	[parameters setObject:@"Objective Merchant" forKey:@"software"];

	/*	int testmode = ([self isTest]) ? 1 : 0;  Turn testmode off, since we use the sandbox URL instead*/
	int testmode = 0;
	[parameters setObject:MakeInt(testmode) forKey:@"testmode"];

	NSMutableArray *params = [[NSMutableArray alloc] init];

	NSString *key;
	NSEnumerator *enumerator = [parameters keyEnumerator];
	while (key = [enumerator nextObject]) {
		NSString *obj = [parameters objectForKey:key];
		[params addObject:[NSString stringWithFormat:@"UM%@=%@",
																key,
																[[NSString stringWithFormat:@"%@", obj] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
																nil]];
	}

	NSString *paramStr = [params componentsJoinedByString:@"&"];
	return paramStr;
}


//
// Class Methods
//

static NSArray* _UsaEpayGateway_supportedCountries = nil;
static NSArray* _UsaEpayGateway_supportedCardtypes = nil;

+ (NSArray *) supportedCountries {
	if (_UsaEpayGateway_supportedCountries==nil) {
		_UsaEpayGateway_supportedCountries = [NSArray arrayWithObjects:@"US", nil];
	}
	return _UsaEpayGateway_supportedCountries;
}
+ (void) setSupportedCountries:(NSArray *)countries {
}
+ (NSArray *) supportedCardtypes {
	if (_UsaEpayGateway_supportedCardtypes==nil) {
		_UsaEpayGateway_supportedCardtypes = [NSArray arrayWithObjects:@"visa", @"master", @"american_express", nil];
	}
	return _UsaEpayGateway_supportedCardtypes;
}
+ (void) setSupportedCardtypes:(NSArray *)cardtypes {
}
+ (NSString *) homepageUrl {
	return @"http://www.usaepay.com";
}
+ (void) setHomepageUrl:(NSString *)url {
}
+ (NSString *) displayName {
	return @"USA ePay";
}
+ (void) setDisplayName:(NSString *)dname {
}

static NSMutableString* _UsaEpayGateway_Url = nil;
+ (NSString *) Url
{
	if (_UsaEpayGateway_Url==nil)
		_UsaEpayGateway_Url = [[NSString stringWithString:@"https://www.usaepay.com/gate.php"] retain];
	return _UsaEpayGateway_Url;
}

static NSMutableString* _UsaEpayGateway_SandboxUrl = nil;
+ (NSString *) SandboxUrl
{
	if (_UsaEpayGateway_SandboxUrl==nil)
		_UsaEpayGateway_SandboxUrl = [[NSString stringWithString:@"https://sandbox.usaepay.com/gate.php"] retain];
	return _UsaEpayGateway_SandboxUrl;
}


static NSDictionary* _UsaEpayGateway_Transactions = nil;
+ (NSDictionary*)Transactions
{
	if (_UsaEpayGateway_Transactions == nil)
		_UsaEpayGateway_Transactions = [[NSDictionary dictionaryWithObjectsAndKeys:
													@"cc:authonly", @"authorization",
													@"cc:sale", @"purchase",
													@"cc:capture", @"capture",
												 nil] retain];
	return _UsaEpayGateway_Transactions;
}



@end
