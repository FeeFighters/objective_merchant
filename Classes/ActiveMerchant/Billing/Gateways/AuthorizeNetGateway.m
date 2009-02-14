//
//  AuthorizeNetGateway.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "AuthorizeNetGateway.h"
#import "RegexKitLite.h"
#import "objCFixes.h"
#import "CvvResult.h"
#import "AvsResult.h"

@interface AuthorizeNetGateway (Private)
- (NSDictionary*) parse:(NSString*)body;
- (NSString*) postData:(NSString*)action parameters:(NSDictionary*)parameters;
- (NSString*) messageFrom:(NSDictionary*)results;
- (bool) is_success:(NSDictionary*)response;
- (bool) is_fraudReview:(NSDictionary*)response;
- (void) addInvoice:(NSMutableDictionary*)post options:(NSDictionary*)_options;
- (void) addCreditCard:(NSMutableDictionary*)post creditcard:(BillingCreditCard*)creditcard;
- (void) addCustomerData:(NSMutableDictionary*)post options:(NSDictionary*)_options;
- (void) addDuplicateWindow:(NSMutableDictionary*)post;
- (void) addAddress:(NSMutableDictionary*)post options:(NSDictionary*)_options;
- (NSString*) expdate:(BillingCreditCard*)creditcard;
- (BillingResponse*) commit:(NSString*)action money:(id)money parameters:(NSMutableDictionary*)parameters;
- (NSArray *) split:(NSString*)data;
@end


@implementation AuthorizeNetGateway


//
// Public 
//
- (id) init:(NSMutableDictionary *)_options
{
	[self requires:_options, @"login", @"password", nil];
	options = _options;
	return [super init:_options];
}

//# Performs an authorization, which reserves the funds on the customer's credit card, but does not
//# charge the card.
//#
//# ==== Parameters
//#
//# * <tt>money</tt> -- The amount to be authorized. Either an Integer value in cents or a Money object.
//# * <tt>creditcard</tt> -- The CreditCard details for the transaction.
//# * <tt>options</tt> -- A hash of optional parameters.
- (BillingResponse *) authorize:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)_options
{
	NSMutableDictionary *post = [[NSMutableDictionary alloc] init];
	[self addInvoice:post options:_options];
	[self addCreditCard:post creditcard:creditcard];
	[self addAddress:post options:_options];
	[self addCustomerData:post options:_options];
	[self addInvoice:post options:_options];	
	[self addDuplicateWindow:post];

	return [self commit:@"AUTH_ONLY" money:money parameters:post];
}

//# Perform a purchase, which is essentially an authorization and capture in a single operation.
//#
//# ==== Parameters
//#
//# * <tt>money</tt> -- The amount to be purchased. Either an Integer value in cents or a Money object.
//# * <tt>creditcard</tt> -- The CreditCard details for the transaction.
//# * <tt>options</tt> -- A hash of optional parameters.
- (BillingResponse *) purchase:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)_options
{
	NSMutableDictionary *post = [[NSMutableDictionary alloc] init];
	[self addInvoice:post options:_options];
	[self addCreditCard:post creditcard:creditcard];
	[self addAddress:post options:_options];
	[self addCustomerData:post options:_options];
	[self addDuplicateWindow:post];
	
	return [self commit:@"AUTH_CAPTURE" money:money parameters:post];
}

//# Captures the funds from an authorized transaction.
//#
//# ==== Parameters
//#
//# * <tt>money</tt> -- The amount to be captured.  Either an Integer value in cents or a Money object.
//# * <tt>authorization</tt> -- The authorization returned from the previous authorize request.
- (BillingResponse *) capture:(id)money authorization:(NSString*)authorization options:(NSDictionary*)_options
{
	NSMutableDictionary *post = [[NSMutableDictionary alloc] init];
	[post setObject:nilToNull(authorization) forKey:@"trans_id"];
	
	[self addCustomerData:post options:_options];
	
	return [self commit:@"PRIOR_AUTH_CAPTURE" money:money parameters:post];
}

//# Void a previous transaction
//#
//# ==== Parameters
//#
//# * <tt>authorization</tt> - The authorization returned from the previous authorize request.
- (BillingResponse *) voidAuthorization:(NSString*)authorization options:(NSDictionary*)options
{
	NSMutableDictionary *post = [[NSMutableDictionary alloc] init];
	[post setObject:nilToNull(authorization) forKey:@"trans_id"];
	
	return [self commit:@"VOID" money:nil parameters:post];
}


//# Credit an account.
//#
//# This transaction is also referred to as a Refund and indicates to the gateway that
//# money should flow from the merchant to the customer.
//#
//# ==== Parameters
//#
//# * <tt>money</tt> -- The amount to be credited to the customer. Either an Integer value in cents or a Money object.
//# * <tt>identification</tt> -- The ID of the original transaction against which the credit is being issued.
//# * <tt>options</tt> -- A hash of parameters.
//#
//# ==== Options
//#
//# * <tt>"cardNumber"</tt> -- The credit card number the credit is being issued to. (REQUIRED)
- (BillingResponse *) credit:(id)money identification:(NSString*)identification options:(NSDictionary*)_options
{
	[self requires:_options, @"cardNumber", nil];
	
	NSMutableDictionary *post = [[NSMutableDictionary alloc] init];
	[post setObject:nilToNull(identification) forKey:@"trans_id"];
	[post setObject:nilToNull([_options objectForKey:@"cardNumber"]) forKey:@"trans_id"];	
	
	return [self commit:@"CREDIT" money:money parameters:post];
}	

//# Create a recurring payment.
//#
//# This transaction creates a new Automated Recurring Billing (ARB) subscription. Your account must have ARB enabled.
//#
//# ==== Parameters
//#
//# * <tt>money</tt> -- The amount to be charged to the customer at each interval. Either an Integer value in cents or
//#   a Money object.
//# * <tt>creditcard</tt> -- The CreditCard details for the transaction.
//# * <tt>options</tt> -- A hash of parameters.
//#
//# ==== Options
//#
//# * <tt>:interval</tt> -- A hash containing information about the interval of time between payments. Must
//#   contain the keys <tt>:length</tt> and <tt>:unit</tt>. <tt>:unit</tt> can be either <tt>:months</tt> or <tt>:days</tt>.
//#   If <tt>:unit</tt> is <tt>:months</tt> then <tt>:interval</tt> must be an integer between 1 and 12 inclusive.
//#   If <tt>:unit</tt> is <tt>:days</tt> then <tt>:interval</tt> must be an integer between 7 and 365 inclusive.
//#   For example, to charge the customer once every three months the hash would be
//#   +{ :unit => :months, :interval => 3 }+ (REQUIRED)
//# * <tt>:duration</tt> -- A hash containing keys for the <tt>:startDate</tt> the subscription begins (also the date the
//#   initial billing occurs) and the total number of billing <tt>:occurences</tt> or payments for the subscription. (REQUIRED)
//- (BillingResponse *) recurring:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)_options
//{
//	[self requires:_options, @"interval", @"duration", @"billingAddress", nil];
//	[self requires:[_options objectForKey:@"interval"], @"length", [NSArray arrayWithObjects:@"unit", @"days", @"months", nil], nil];
//	[self requires:[_options objectForKey:@"duration"], @"startDate", @"occurrences", nil];	
//	[self requires:[_options objectForKey:@"billingAddress"], @"firstName", @"lastName", nil];		
//
//	[_options setObject:nilToNull(creditcard) forKey:@"creditCard"];
//	[_options setObject:nilToNull(money) forKey:@"money"];
//
//	
//	//	request = build_recurring_request(:create, options)
//	//	recurring_commit(:create, request)
//}
//- (BillingResponse *) updateRecurring:(NSDictionary*)options;
//- (BillingResponse *) cancelRecurring:(NSString*)subscriptionId;


//
// Private
//

- (BillingResponse*) commit:(NSString*)action money:(id)money parameters:(NSMutableDictionary*)parameters
{
	if (![action isEqualToString:@"VOID"])
		[parameters setObject:[self amount:money] forKey:@"amount"];
	
	//# Only activate the test_request when the :test option is passed in	
	[parameters setObject:([options objectForKey:@"test"] ? @"TRUE" : @"FALSE") forKey:@"testRequest"];
	
	NSString *url = [self is_test] ? [[self class] testUrl] : [[self class] liveUrl];
	NSString *postDataParms = [self postData:action parameters:parameters];
	NSString *data = [self sslPost:url data:postDataParms headers:[[NSMutableDictionary alloc] init]];
	
	NSDictionary *response = [self parse:data];
	
	NSString *message = [self messageFrom:response];
	
	//# Return the response. The authorization can be taken out of the transaction_id
	//# Test Mode on/off is something we have to parse from the response text.
	//# It usually looks something like this
	//#
	//#   (TESTMODE) Successful Sale
	bool testMode = [self is_test] || [message isMatchedByRegex:@"TESTMODE"];
	
	NSDictionary *optionshash = [NSDictionary dictionaryWithObjectsAndKeys:
								 MakeBool(testMode), @"test",
								 nilToNull([response objectForKey:@"transactionId"]), @"authorization",
								 MakeBool([self is_fraudReview:response]), @"fraudReview",
								 nilToNull([NSDictionary dictionaryWithObjectsAndKeys:[response objectForKey:@"avsResultCode"], @"code", nil]), @"avsResult",
								 nilToNull([response objectForKey:@"cardCode"]), @"cvvResult",
								 nil
								 ];
	BillingResponse *ret = [[BillingResponse alloc] init:[self is_success:response] message:message params:response options:optionshash];
	return ret;
}

- (NSDictionary*) parse:(NSString*)body
{
	NSArray *fields = [self split:body];
	
	NSDictionary *results = [NSDictionary dictionaryWithObjectsAndKeys:
							 nilToNull([fields objectAtIndex:ResponseCode]),		@"responseCode",
							 nilToNull([fields objectAtIndex:ResponseReasonCode]),	@"responseReasonCode",	
							 nilToNull([fields objectAtIndex:ResponseReasonText]),	@"responseReasonText",	
							 nilToNull([fields objectAtIndex:AvsResultCode]),		@"avsResultCode",	
							 nilToNull([fields objectAtIndex:TransactionId]),		@"transactionId",	
							 nilToNull([fields objectAtIndex:CardCodeResponseCode]),	@"cardCode",
							 nil
							 ];
	return results;
}

- (NSArray *) split:(NSString*)data
{
	return [[data substringWithRange:NSMakeRange(1, [data length]-2)] componentsSeparatedByRegex:@"\\$,\\$"];
}

- (NSString*) postData:(NSString*)action parameters:(NSDictionary*)parameters
{
	NSMutableDictionary* post = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								 @"3.1", @"version",
								 nilToNull([options objectForKey:@"login"]), @"login",
								 nilToNull([options objectForKey:@"password"]), @"tran_key",
								 @"FALSE", @"relay_response",
								 nilToNull(action), @"type",
								 @"TRUE", @"delim_data",
								 @",", @"delim_char",
								 @"$", @"encap_char",
								 nil
								 ];
	
	[post addEntriesFromDictionary:parameters];
	
	NSMutableArray* requestArray = [[NSMutableArray alloc] init];
	NSString *curKey;
	NSEnumerator *enumerator;
	enumerator = [post keyEnumerator];
	while (curKey = [enumerator nextObject]) {
		NSString *curObj = [post objectForKey:curKey];
		if (![NSString is_blank:curObj])
			[requestArray addObject:[NSString stringWithFormat:@"x_%@=%@", curKey, [curObj stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	}
	NSString *joinedStr = [requestArray componentsJoinedByString:@"&"];
	return joinedStr;
}


- (NSString*) messageFrom:(NSDictionary*)results
{
	if ([[results objectForKey:@"responseCode"] intValue] == Declined)
	{
		if ([[AuthorizeNetGateway CardCodeErrors] containsStringEqualTo:[results objectForKey:@"cardCode"]])
			return [[BillingCvvResult messages] objectForKey:[results objectForKey:@"cardCode"]];
		
		if ([[AuthorizeNetGateway AvsErrors] containsStringEqualTo:[results objectForKey:@"avsResultCode"]])
			return [[BillingAvsResult messages] objectForKey:[results objectForKey:@"avsResultCode"]];
	}
	
	if ([results objectForKey:@"responseReasonText"]==nil)
		return @"";
	
	NSString *s = [results objectForKey:@"responseReasonText"];
	return [s substringToIndex:([s length] - 1)];
}


- (bool) is_success:(NSDictionary*)response
{
	return ([[response objectForKey:@"responseCode"] intValue]==Approved);
}

- (bool) is_fraudReview:(NSDictionary*)response
{
	return ([[response objectForKey:@"responseCode"] intValue]==FraudReview);
}

- (void) addInvoice:(NSMutableDictionary*)post options:(NSDictionary*)_options
{
	[post setObject:nilToNull([_options objectForKey:@"orderId"]) forKey:@"invoice_num"];
	[post setObject:nilToNull([_options objectForKey:@"description"]) forKey:@"description"];	
}

- (void) addCreditCard:(NSMutableDictionary*)post creditcard:(BillingCreditCard*)creditcard
{
	[post setObject:nilToNull([creditcard number]) forKey:@"card_num"];
	if ([creditcard has_verificationValue])
		[post setObject:[creditcard verificationValue] forKey:@"card_code"];	
	[post setObject:nilToNull([self expdate:creditcard]) forKey:@"exp_date"];
	[post setObject:nilToNull([creditcard firstName]) forKey:@"first_name"];	
	[post setObject:nilToNull([creditcard lastName]) forKey:@"last_name"];
}

- (void) addCustomerData:(NSMutableDictionary*)post options:(NSDictionary*)_options
{
	if ([_options objectForKey:@"email"]!=nil) 
	{
		[post setObject:nilToNull([_options objectForKey:@"email"]) forKey:@"email"];		
		[post setObject:false forKey:@"email_customer"];			
	}
	if ([_options objectForKey:@"customer"]!=nil) 
	{
		[post setObject:nilToNull([_options objectForKey:@"customer"]) forKey:@"cust_id"];			
	}
	if ([_options objectForKey:@"ip"]!=nil) 
	{
		[post setObject:nilToNull([_options objectForKey:@"ip"]) forKey:@"customer_ip"];			
	}
}

//# x_duplicate_window won't be sent by default, because sending it changes the response.
//# "If this field is present in the request with or without a value, an enhanced duplicate transaction response will be sent."
//# (as of 2008-12-30) http://www.authorize.net/support/AIM_guide_SCC.pdf
- (void) addDuplicateWindow:(NSMutableDictionary*)post
{
	if ([AuthorizeNetGateway duplicateWindow]!=nil)
		[post setObject:nilToNull([AuthorizeNetGateway duplicateWindow]) forKey:@"duplicate_window"];					
}

- (void) addAddress:(NSMutableDictionary*)post options:(NSDictionary*)_options
{
	NSDictionary *address = [_options objectForKey:@"billingAddress"];
	if (address==nil)
		address = [_options objectForKey:@"address"];
	
	if (address!=nil)
	{
		[post setObject:nilToNull([address objectForKey:@"address1"]) forKey:@"address"];
		[post setObject:nilToNull([address objectForKey:@"company"]) forKey:@"company"];
		[post setObject:nilToNull([address objectForKey:@"phone"]) forKey:@"phone"];		
		[post setObject:nilToNull([address objectForKey:@"zip"]) forKey:@"zip"];		
		[post setObject:nilToNull([address objectForKey:@"city"]) forKey:@"city"];		
		[post setObject:nilToNull([address objectForKey:@"country"]) forKey:@"country"];		
		if ([NSString is_blank:[address objectForKey:@"state"]])
			[post setObject:@"n/a" forKey:@"state"];
		else
			[post setObject:nilToNull([address objectForKey:@"state"]) forKey:@"state"];			
	}
}

- (NSString*) expdate:(BillingCreditCard*)creditcard
{
	NSString *year = [NSString stringWithFormat:@"%.4i", [[creditcard year] intValue]];
	return [NSString stringWithFormat:@"%.2i%@", [[creditcard month] intValue], [year substringWithRange:NSMakeRange([year length]-2, 2)]];
}



//
// Class Methods
// 

static NSMutableString* _AuthorizeNetGateway_testUrl = nil;
static NSMutableString* _AuthorizeNetGateway_liveUrl = nil;
static NSMutableString* _AuthorizeNetGateway_arbTestUrl = nil;
static NSMutableString* _AuthorizeNetGateway_arbLiveUrl = nil;

+ (NSString *) testUrl
{
	if (_AuthorizeNetGateway_testUrl==nil)
		_AuthorizeNetGateway_testUrl = [NSString stringWithString:@"https://test.authorize.net/gateway/transact.dll"];
	return _AuthorizeNetGateway_testUrl;
}
+ (void) setTestUrl:(NSString *)url
{
	[_AuthorizeNetGateway_testUrl setString:url];
}
+ (NSString *) liveUrl
{
	if (_AuthorizeNetGateway_liveUrl==nil)
		_AuthorizeNetGateway_liveUrl = [NSString stringWithString:@"https://secure.authorize.net/gateway/transact.dll"];
	return _AuthorizeNetGateway_liveUrl;
}
+ (void) setLiveUrl:(NSString *)url
{
	[_AuthorizeNetGateway_liveUrl setString:url];
}
+ (NSString *) arbTestUrl
{
	if (_AuthorizeNetGateway_arbTestUrl==nil)
		_AuthorizeNetGateway_arbTestUrl = [NSString stringWithString:@"https://apitest.authorize.net/xml/v1/request.api"];
	return _AuthorizeNetGateway_arbTestUrl;
}
+ (void) setArbTestUrl:(NSString *)url
{
	[_AuthorizeNetGateway_arbTestUrl setString:url];
}
+ (NSString *) arbLiveUrl
{
	if (_AuthorizeNetGateway_arbLiveUrl==nil)
		_AuthorizeNetGateway_arbLiveUrl = [NSString stringWithString:@"https://api.authorize.net/xml/v1/request.api"];
	return _AuthorizeNetGateway_arbLiveUrl;
}
+ (void) setArbLiveUrl:(NSString *)url
{
	[_AuthorizeNetGateway_arbLiveUrl setString:url];
}

static NSMutableString* _AuthorizeNetGateway_duplicateWindow = nil;
+ (NSString *) duplicateWindow
{
	return _AuthorizeNetGateway_duplicateWindow;
}
+ (void) setDuplicateWindow:(NSString *)val
{
	[_AuthorizeNetGateway_duplicateWindow setString:val];	
}

static NSArray* _AuthorizeNetGateway_CardCodeErrors = nil;
+ (NSArray*)CardCodeErrors
{
	if (_AuthorizeNetGateway_CardCodeErrors==nil)
		_AuthorizeNetGateway_CardCodeErrors = [NSArray arrayWithObjects:@"N", @"S", nil];
	return _AuthorizeNetGateway_CardCodeErrors;
}

static NSArray* _AuthorizeNetGateway_AvsErrors = nil;
+ (NSArray*)AvsErrors
{
	if (_AuthorizeNetGateway_AvsErrors==nil)
		_AuthorizeNetGateway_AvsErrors = [NSArray arrayWithObjects:@"A", @"E", @"N", @"R", @"W", @"Z", nil];
	return _AuthorizeNetGateway_AvsErrors;
}
+ (NSString*)AuthorizeNetArbNamespace
{
	return @"AnetApi/xml/v1/schema/AnetApiSchema.xsd";
}

static NSDictionary* _AuthorizeNetGateway_RecurringActions = nil;
+ (NSDictionary*)RecurringActions
{
	if (_AuthorizeNetGateway_RecurringActions == nil)
		_AuthorizeNetGateway_RecurringActions = [NSDictionary dictionaryWithObjectsAndKeys:
													@"ARBCreateSubscription", @"create",
													@"ARBUpdateSubscription", @"update",
													@"ARBCancelSubscription", @"cancel", 
												 nil];
	return _AuthorizeNetGateway_RecurringActions;
}



@end
