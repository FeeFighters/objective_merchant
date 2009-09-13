//
//  PaypalGateway.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "PaypalGateway.h"
#import "RegexKitLite.h"
#import "objCFixes.h"
#import "GDataXMLNode.h"
#import "GDataXMLNodeAdditions.h"


@interface PaypalGateway (Private)
- (NSString*) buildSaleOrAuthorizationRequest:(NSString*)action money:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)options;
- (void) addCreditCard:(GDataXMLElement*)xml creditcard:(BillingCreditCard*)creditcard address:(NSDictionary*)address options:(NSDictionary*)options;
- (NSString*) creditCardType:(NSString*)type;
- (BillingResponse*) buildResponse:(bool)success message:(NSString *)message params:(NSDictionary*)params options:(NSDictionary*)options;

// Include Paypal Common API Private Definitions
#include "PaypalCommonAPI_Private.h"

@end


@implementation PaypalGateway

- (BillingResponse *) authorize:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)_options
{
	[self requires:_options, @"ip", nil];
	return [self commit:@"DoDirectPayment"
				request:[self buildSaleOrAuthorizationRequest:@"Authorization"
														money:money
												   creditcard:creditcard
													  options:_options]
			];
}

- (BillingResponse *) purchase:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)_options
{
	[self requires:_options, @"ip", nil];
	return [self commit:@"DoDirectPayment"
				request:[self buildSaleOrAuthorizationRequest:@"Sale"
														money:money
												   creditcard:creditcard
													  options:_options]
			];
}

- (id) express:(NSDictionary*)_options
{
	// @express ||= PaypalExpressGateway.new(@options)
	return nil;  // TODO: Not currently supported
}

//
// Private Methods
//

- (NSString*) buildSaleOrAuthorizationRequest:(NSString*)action money:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)_options
{
	NSDictionary* billingAddress;
	if ([_options objectForKey:@"billingAddress"])
		billingAddress = [_options objectForKey:@"billingAddress"];
	else
		billingAddress = [_options objectForKey:@"address"];
	NSString* currencyCode;
	if ([_options objectForKey:@"currency"])
		currencyCode = [_options objectForKey:@"currency"];
	else
		currencyCode = [self currency:money];

	GDataXMLElement* xmlRoot = [GDataXMLElement elementWithName:@"DoDirectPaymentReq"];
	[xmlRoot addAttribute:[GDataXMLElement elementWithName:@"xmlns" stringValue:[PaypalGateway PAYPAL_NAMESPACE]]];

	GDataXMLElement* xml_DoDirectPaymentRequest = [GDataXMLElement elementWithName:@"DoDirectPaymentRequest"];
	[xml_DoDirectPaymentRequest addAttribute:[GDataXMLElement elementWithName:@"xmlns:n2" stringValue:[PaypalGateway EBAY_NAMESPACE]]];

	[xml_DoDirectPaymentRequest addChild:[GDataXMLElement elementWithName:@"n2:Version" stringValue:[PaypalGateway API_VERSION]]];
	GDataXMLElement* xml_n2_DoDirectPaymentRequestDetails = [GDataXMLElement elementWithName:@"n2:DoDirectPaymentRequestDetails"];

	[xml_n2_DoDirectPaymentRequestDetails addChild:[GDataXMLElement elementWithName:@"n2:PaymentAction" stringValue:action]];
	GDataXMLElement* xml_n2_PaymentDetails = [GDataXMLElement elementWithName:@"n2:PaymentDetails"];

	GDataXMLElement* xml_n2_OrderTotal = [GDataXMLElement elementWithName:@"n2:OrderTotal" stringValue:[self amount:money]];
	[xml_n2_OrderTotal addAttribute:[GDataXMLNode elementWithName:@"currencyID" stringValue:currencyCode]];
	[xml_n2_PaymentDetails addChild:xml_n2_OrderTotal];

	if (	[_options objectForKey:@"subtotal"] &&
			[_options objectForKey:@"shipping"] &&
			[_options objectForKey:@"handling"] &&
			[_options objectForKey:@"tax"] )
	{
		GDataXMLElement* node;
		GDataXMLNode* attr = [GDataXMLNode elementWithName:@"currencyID" stringValue:currencyCode];

		node = [GDataXMLElement elementWithName:@"n2:ItemTotal" stringValue:[self amount:[_options objectForKey:@"subtotal"]]];
		[node addAttribute:attr];
		[xml_n2_PaymentDetails addChild:node];
		node = [GDataXMLElement elementWithName:@"n2:ShippingTotal" stringValue:[self amount:[_options objectForKey:@"shipping"]]];
		[node addAttribute:attr];
		[xml_n2_PaymentDetails addChild:node];
		node = [GDataXMLElement elementWithName:@"n2:HandlingTotal" stringValue:[self amount:[_options objectForKey:@"handling"]]];
		[node addAttribute:attr];
		[xml_n2_PaymentDetails addChild:node];
		node = [GDataXMLElement elementWithName:@"n2:TaxTotal" stringValue:[self amount:[_options objectForKey:@"tax"]]];
		[node addAttribute:attr];
		[xml_n2_PaymentDetails addChild:node];
	}

	[xml_n2_PaymentDetails addChild:[GDataXMLElement elementWithName:@"n2:NotifyURL" stringValue:[_options objectForKey:@"notifyUrl"]]];
	[xml_n2_PaymentDetails addChild:[GDataXMLElement elementWithName:@"n2:OrderDescription" stringValue:[_options objectForKey:@"description"]]];
	[xml_n2_PaymentDetails addChild:[GDataXMLElement elementWithName:@"n2:InvoiceID" stringValue:[_options objectForKey:@"orderId"]]];
	if (![NSString isBlank:[BillingGateway applicationId]]) {
		[xml_n2_PaymentDetails addChild:[GDataXMLElement elementWithName:@"n2:ButtonSource" stringValue:[[BillingGateway applicationId] substringWithRange:NSMakeRange(0, ([[BillingGateway applicationId] length] > 32) ? 32 : [[BillingGateway applicationId] length]) ]]];
	}

	if ([_options objectForKey:@"shippingAddress"]!=nil)
		[self addAddress:xml_n2_PaymentDetails element:@"n2:ShipToAddress" address:[_options objectForKey:@"shippingAddress"]];

	[self addCreditCard:xml_n2_DoDirectPaymentRequestDetails creditcard:creditcard address:billingAddress options:_options];
	[xml_n2_DoDirectPaymentRequestDetails addChild:[GDataXMLElement elementWithName:@"n2:IPAddress" stringValue:[_options objectForKey:@"ip"]]];

	[xml_n2_DoDirectPaymentRequestDetails addChild:xml_n2_PaymentDetails];
	[xml_DoDirectPaymentRequest addChild:xml_n2_DoDirectPaymentRequestDetails];
	[xmlRoot addChild:xml_DoDirectPaymentRequest];

	NSString* xmlText = [xmlRoot XMLString];
	NSLog(@"buildSaleOrAuthorizationRequest xml: %@", xmlText);
	return xmlText;
}

- (void) addCreditCard:(GDataXMLElement*)xml creditcard:(BillingCreditCard*)creditcard address:(NSDictionary*)address options:(NSDictionary*)_options
{
	GDataXMLElement* xml_n2_CreditCard = [GDataXMLElement elementWithName:@"n2:CreditCard"];

	[xml_n2_CreditCard addChild:[GDataXMLElement elementWithName:@"n2:CreditCardType" stringValue:[self creditCardType:[self cardBrand:creditcard]]]];
	[xml_n2_CreditCard addChild:[GDataXMLElement elementWithName:@"n2:CreditCardNumber" stringValue:creditcard.number]];
	[xml_n2_CreditCard addChild:[GDataXMLElement elementWithName:@"n2:ExpMonth" stringValue:[self format:creditcard.month option:@"twoDigits"]]];
	[xml_n2_CreditCard addChild:[GDataXMLElement elementWithName:@"n2:ExpYear" stringValue:[self format:creditcard.year option:@"fourDigits"]]];
	[xml_n2_CreditCard addChild:[GDataXMLElement elementWithName:@"n2:CVV2" stringValue:creditcard.verificationValue]];

	if (	[[self cardBrand:creditcard] isEqualToString:@"switch"] ||
			[[self cardBrand:creditcard] isEqualToString:@"solo"] )
	{
		if (![NSString isBlank:[creditcard.startMonth stringValue]])
			[xml_n2_CreditCard addChild:[GDataXMLElement elementWithName:@"n2:StartMonth" stringValue:[self format:creditcard.startMonth option:@"twoDigits"]]];
		if (![NSString isBlank:[creditcard.startYear stringValue]])
			[xml_n2_CreditCard addChild:[GDataXMLElement elementWithName:@"n2:StartYear" stringValue:[self format:creditcard.startYear option:@"fourDigits"]]];
		if (![NSString isBlank:[creditcard.issueNumber stringValue]])
			[xml_n2_CreditCard addChild:[GDataXMLElement elementWithName:@"n2:IssueNumber" stringValue:[self format:creditcard.issueNumber option:@"twoDigits"]]];
	}

	GDataXMLElement* xml_n2_CardOwner = [GDataXMLElement elementWithName:@"n2:CardOwner"];

	GDataXMLElement* xml_n2_PayerName = [GDataXMLElement elementWithName:@"n2:PayerName"];
	[xml_n2_PayerName addChild:[GDataXMLElement elementWithName:@"n2:FirstName" stringValue:creditcard.firstName]];
	[xml_n2_PayerName addChild:[GDataXMLElement elementWithName:@"n2:LastName" stringValue:creditcard.lastName]];
	[xml_n2_CardOwner addChild:xml_n2_PayerName];

	[xml_n2_CardOwner addChild:[GDataXMLElement elementWithName:@"n2:Payer" stringValue:[_options objectForKey:@"email"]]];

	[self addAddress:xml_n2_CardOwner element:@"n2:Address" address:address];

	[xml_n2_CreditCard addChild:xml_n2_CardOwner];
	[xml addChild:xml_n2_CreditCard];
}

- (NSString*) creditCardType:(NSString*)type
{
	if ([type isEqualToString:@"visa"]) return @"Visa";
	if ([type isEqualToString:@"master"]) return @"MasterCard";
	if ([type isEqualToString:@"discover"]) return @"Discover";
	if ([type isEqualToString:@"american_express"]) return @"Amex";
	if ([type isEqualToString:@"switch"]) return @"Switch";
	if ([type isEqualToString:@"solo"]) return @"Solo";
	return nil;
}

- (BillingResponse*) buildResponse:(bool)_success message:(NSString *)_message params:(NSDictionary*)_params options:(NSDictionary*)_options
{
	return [[BillingResponse alloc] init:_success
								 message:_message
								  params:_params
								 options:_options];
}

//
// Class Methods
//

static NSArray* _PaypalGateway_supportedCountries = nil;
static NSArray* _PaypalGateway_supportedCardtypes = nil;

+ (NSArray *) supportedCountries {
	if (_PaypalGateway_supportedCountries==nil) {
		_PaypalGateway_supportedCountries = [NSArray arrayWithObjects:@"US", nil];
	}
	[_PaypalGateway_supportedCountries retain];
	return _PaypalGateway_supportedCountries;
}
+ (void) setSupportedCountries:(NSArray *)countries {
}
+ (NSArray *) supportedCardtypes {
	if (_PaypalGateway_supportedCardtypes==nil) {
		_PaypalGateway_supportedCardtypes = [NSArray arrayWithObjects:@"visa", @"master", @"american_express", @"discover", nil];
	}
	[_PaypalGateway_supportedCardtypes retain];
	return _PaypalGateway_supportedCardtypes;
}
+ (void) setSupportedCardtypes:(NSArray *)cardtypes {
}
+ (NSString *) homepageUrl {
	return @"https://www.paypal.com/cgi-bin/webscr?cmd=_wp-pro-overview-outside";
}
+ (void) setHomepageUrl:(NSString *)url {
}
+ (NSString *) displayName {
	return @"PayPal Website Payments Pro (US)";
}
+ (void) setDisplayName:(NSString *)dname {
}


//
// Include Paypal Common API Implementation
//
#include "PaypalCommonAPI_Implementation.h"


@end
