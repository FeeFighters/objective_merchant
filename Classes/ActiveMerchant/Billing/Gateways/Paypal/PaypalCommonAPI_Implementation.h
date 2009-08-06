/*
 *  PaypalCommonAPI_Implementation.h
 *  objective_merchant
 *
 *  Created by Joshua Krall on 3/3/09.
 *  Copyright 2009 TransFS.com. All rights reserved.
 *
 */

//
// Private Methods
//

- (NSString*) buildReauthorizeRequest:(id)money authorization:(NSString*)authorization options:(NSDictionary*)_options
{
	GDataXMLElement* xmlRoot = [GDataXMLElement elementWithName:@"DoReauthorizationReq"];
	[xmlRoot addAttribute:[GDataXMLElement elementWithName:@"xmlns" stringValue:[PaypalGateway PAYPAL_NAMESPACE]]];

	GDataXMLElement* xml_DoDirectPaymentRequest = [GDataXMLElement elementWithName:@"DoReauthorizationRequest"];
	[xml_DoDirectPaymentRequest addAttribute:[GDataXMLElement elementWithName:@"xmlns:n2" stringValue:[PaypalGateway EBAY_NAMESPACE]]];

	[xml_DoDirectPaymentRequest addChild:[GDataXMLElement elementWithName:@"n2:Version" stringValue:[[self class] API_VERSION]]];
	[xml_DoDirectPaymentRequest addChild:[GDataXMLElement elementWithName:@"AuthorizationID" stringValue:authorization]];
	GDataXMLElement* amount_node = [GDataXMLElement elementWithName:@"Amount" stringValue:[self amount:money]];
	if ([_options objectForKey:@"currency"])
		[amount_node addAttribute:[GDataXMLElement elementWithName:@"currencyID" stringValue:[_options objectForKey:@"currency"]]];
	else
		[amount_node addAttribute:[GDataXMLElement elementWithName:@"currencyID" stringValue:[self currency:money]]];
	[xml_DoDirectPaymentRequest addChild:amount_node];

	[xmlRoot addChild:xml_DoDirectPaymentRequest];

	NSString* xmlText = [xmlRoot XMLString];
	NSLog(@"buildReauthorizeRequest xml: %@", xmlText);
	return xmlText;
}

- (NSString*) buildCaptureRequest:(id)money authorization:(NSString*)authorization options:(NSDictionary*)_options
{
	GDataXMLElement* xmlRoot = [GDataXMLElement elementWithName:@"DoCaptureReq"];
	[xmlRoot addAttribute:[GDataXMLElement elementWithName:@"xmlns" stringValue:[PaypalGateway PAYPAL_NAMESPACE]]];

	GDataXMLElement* xml_DoDirectPaymentRequest = [GDataXMLElement elementWithName:@"DoCaptureRequest"];
	[xml_DoDirectPaymentRequest addAttribute:[GDataXMLElement elementWithName:@"xmlns:n2" stringValue:[PaypalGateway EBAY_NAMESPACE]]];

	[xml_DoDirectPaymentRequest addChild:[GDataXMLElement elementWithName:@"n2:Version" stringValue:[[self class] API_VERSION]]];
	[xml_DoDirectPaymentRequest addChild:[GDataXMLElement elementWithName:@"AuthorizationID" stringValue:authorization]];
	GDataXMLElement* amount_node = [GDataXMLElement elementWithName:@"Amount" stringValue:[self amount:money]];
	if ([_options objectForKey:@"currency"])
		[amount_node addAttribute:[GDataXMLElement elementWithName:@"currencyID" stringValue:[_options objectForKey:@"currency"]]];
	else
		[amount_node addAttribute:[GDataXMLElement elementWithName:@"currencyID" stringValue:[self currency:money]]];
	[xml_DoDirectPaymentRequest addChild:amount_node];
	[xml_DoDirectPaymentRequest addChild:[GDataXMLElement elementWithName:@"CompleteType" stringValue:@"Complete"]];
	[xml_DoDirectPaymentRequest addChild:[GDataXMLElement elementWithName:@"Note" stringValue:[_options objectForKey:@"description"]]];

	[xmlRoot addChild:xml_DoDirectPaymentRequest];

	NSString* xmlText = [xmlRoot XMLString];
	NSLog(@"buildCaptureRequest xml: %@", xmlText);
	return xmlText;
}

- (NSString*) buildCreditRequest:(id)money identification:(NSString*)identification options:(NSDictionary*)_options
{
	GDataXMLElement* xmlRoot = [GDataXMLElement elementWithName:@"RefundTransactionReq"];
	[xmlRoot addAttribute:[GDataXMLElement elementWithName:@"xmlns" stringValue:[PaypalGateway PAYPAL_NAMESPACE]]];

	GDataXMLElement* xml_DoDirectPaymentRequest = [GDataXMLElement elementWithName:@"RefundTransactionRequest"];
	[xml_DoDirectPaymentRequest addAttribute:[GDataXMLElement elementWithName:@"xmlns:n2" stringValue:[PaypalGateway EBAY_NAMESPACE]]];

	[xml_DoDirectPaymentRequest addChild:[GDataXMLElement elementWithName:@"n2:Version" stringValue:[[self class] API_VERSION]]];
	[xml_DoDirectPaymentRequest addChild:[GDataXMLElement elementWithName:@"TransactionID" stringValue:identification]];
	GDataXMLElement* amount_node = [GDataXMLElement elementWithName:@"Amount" stringValue:[self amount:money]];
	if ([_options objectForKey:@"currency"])
		[amount_node addAttribute:[GDataXMLElement elementWithName:@"currencyID" stringValue:[_options objectForKey:@"currency"]]];
	else
		[amount_node addAttribute:[GDataXMLElement elementWithName:@"currencyID" stringValue:[self currency:money]]];
	[xml_DoDirectPaymentRequest addChild:amount_node];
	[xml_DoDirectPaymentRequest addChild:[GDataXMLElement elementWithName:@"RefundType" stringValue:@"Complete"]];
	[xml_DoDirectPaymentRequest addChild:[GDataXMLElement elementWithName:@"Note" stringValue:[_options objectForKey:@"description"]]];

	[xmlRoot addChild:xml_DoDirectPaymentRequest];

	NSString* xmlText = [xmlRoot XMLString];
	NSLog(@"buildCreditRequest xml: %@", xmlText);
	return xmlText;
}
- (NSString*) buildVoidRequest:(NSString*)authorization options:(NSDictionary*)_options
{
	GDataXMLElement* xmlRoot = [GDataXMLElement elementWithName:@"DoVoidReq"];
	[xmlRoot addAttribute:[GDataXMLElement elementWithName:@"xmlns" stringValue:[PaypalGateway PAYPAL_NAMESPACE]]];

	GDataXMLElement* xml_DoDirectPaymentRequest = [GDataXMLElement elementWithName:@"DoVoidRequest"];
	[xml_DoDirectPaymentRequest addAttribute:[GDataXMLElement elementWithName:@"xmlns:n2" stringValue:[PaypalGateway EBAY_NAMESPACE]]];

	[xml_DoDirectPaymentRequest addChild:[GDataXMLElement elementWithName:@"n2:Version" stringValue:[[self class] API_VERSION]]];
	[xml_DoDirectPaymentRequest addChild:[GDataXMLElement elementWithName:@"AuthorizationID" stringValue:authorization]];
	[xml_DoDirectPaymentRequest addChild:[GDataXMLElement elementWithName:@"Note" stringValue:[_options objectForKey:@"description"]]];

	[xmlRoot addChild:xml_DoDirectPaymentRequest];

	NSString* xmlText = [xmlRoot XMLString];
	NSLog(@"buildVoidRequest xml: %@", xmlText);
	return xmlText;
}

//- (NSString*) buildMassPayRequest:(...);

- (NSDictionary*) parse:(NSString*)action xml:(NSString*)xml
{
	NSMutableDictionary* response = [[NSMutableDictionary alloc] init];
	NSMutableArray *errorCodes = [NSMutableArray array];
	NSMutableArray *errorMessages = [NSMutableArray array];

	NSError* parseError = nil;
	GDataXMLDocument* xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:&parseError];
	GDataXMLElement* root = [xmlDoc rootElement];
	NSString* nodeQuery = [NSString stringWithFormat:@"//ns:%@Response", action];
	NSArray* nodes = [root nodesForXPath:nodeQuery error:&parseError];
	NSArray* soapFaults = [root nodesForXPath:@"//SOAP-ENV:Fault" error:&parseError];
	if ([nodes count] > 0)
	{
		root = [nodes objectAtIndex:0];
		GDataXMLElement* childNode;
		NSEnumerator *enumerator = [[root children] objectEnumerator];
		while (childNode = [enumerator nextObject])
		{
			if ([[childNode name] isEqualToString:@"Errors"]) {
				NSString* shortMessage = nil;
				NSString* longMessage = nil;

				GDataXMLElement* childError;
				NSEnumerator *errorEnumerator = [[childNode children] objectEnumerator];
				while (childError = [errorEnumerator nextObject])
				{
					if ([[childError name] isEqualToString:@"LongMessage"] && ![NSString isBlank:[childError stringValue]])
						longMessage = [childError stringValue];
					else if ([[childError name] isEqualToString:@"ShortMessage"] && ![NSString isBlank:[childError stringValue]])
						shortMessage = [childError stringValue];
					else if ([[childError name] isEqualToString:@"ErrorCode"] && ![NSString isBlank:[childError stringValue]])
						[errorCodes addObject:[childError stringValue]];
				}

				if (longMessage || shortMessage) {
					NSString* message = (longMessage!=nil) ? longMessage : shortMessage;
					[errorMessages addObject:message];
				}
			}
			else {
				[self parseElement:response node:childNode];
			}
		} // for all child nodes of root
		[response setObject:[errorMessages componentsJoinedByString:@" "] forKey:@"message"];
		[response setObject:[errorCodes componentsJoinedByString:@", "] forKey:@"errorCodes"];
	}
	else if ([soapFaults count] > 0)
	{
		root = [soapFaults objectAtIndex:0];
		[self parseElement:response node:root];
		[response setObject:[NSString stringWithFormat:@"%@: %@ - %@",
										[response objectForKey:@"faultcode"],
										[response objectForKey:@"faultstring"],
										[response objectForKey:@"detail"]]
					 forKey:@"message"];
	}

	return response;
}

- (NSString*) fixCamelCase:(NSString*)str
{
	NSString *s = [str toCamelcase];
	s = [s stringByReplacingOccurrencesOfRegex:@"AVS" withString:@"Avs"];
	s = [s stringByReplacingOccurrencesOfRegex:@"CVV" withString:@"Cvv"];
	s = [s stringByReplacingOccurrencesOfRegex:@"ID" withString:@"Id"];
	s = [s lowercaseFirstLetter];
	NSLog(@"%@ -> %@", str, s);
	return s;
}

- (void) parseElement:(NSMutableDictionary*)response node:(GDataXMLElement*)node
{
	if ([node elementChildCount] > 0)
	{
		GDataXMLElement* childNode;
		NSEnumerator *enumerator = [[node elementChildren] objectEnumerator];
		while (childNode = [enumerator nextObject]) {
			[self parseElement:response node:childNode];
		}
	}
	else
	{
		[response setObject:[node stringValue] forKey:[self fixCamelCase:[node name]]];
		GDataXMLElement* attr;
		NSEnumerator *enumerator = [[node attributes] objectEnumerator];
		while (attr = [enumerator nextObject]) {
			if ([[attr name] isEqualToString:@"currencyID"])
				[response setObject:[attr stringValue] forKey:[NSString stringWithFormat:@"%@_%@",
															   [self fixCamelCase:[node name]],
															   [self fixCamelCase:[attr name]]]];
		}
	}
}

- (NSString*) buildRequest:(NSString*)body
{
	GDataXMLElement* xmlRoot = [GDataXMLElement elementWithName:@"env:Envelope"];
	NSString* key;
	NSEnumerator *enumerator = [[PaypalGateway ENVELOPE_NAMESPACES] keyEnumerator];
	while (key = [enumerator nextObject]) {
		[xmlRoot addAttribute:[GDataXMLElement elementWithName:key stringValue:[[PaypalGateway ENVELOPE_NAMESPACES] objectForKey:key]]];
	}

	GDataXMLElement* xml_envHeader = [GDataXMLElement elementWithName:@"env:Header"];

	[self addCredentials:xml_envHeader];
	[xmlRoot addChild:xml_envHeader];

	GDataXMLElement* xml_envBody = [GDataXMLElement elementWithName:@"env:Body"];

	NSError* errors;
	GDataXMLElement* xml_envBodyNodes = [[GDataXMLElement alloc] initWithXMLString:body error:&errors];
	[xml_envBody addChild:xml_envBodyNodes];
	[xmlRoot addChild:xml_envBody];

	GDataXMLDocument *doc = [(GDataXMLDocument*)[GDataXMLDocument alloc] initWithRootElement:xmlRoot];
	NSString* xmlText = [[NSString alloc] initWithData:[doc XMLData] encoding:NSUTF8StringEncoding];
	NSLog(@"buildRequest xml: %@", xmlText);
	return xmlText;
}

- (void) addCredentials:(GDataXMLElement*)xml
{
	GDataXMLElement* xmlRoot = [GDataXMLElement elementWithName:@"RequesterCredentials"];
	NSString* key;
	NSEnumerator *enumerator = [[PaypalGateway CREDENTIALS_NAMESPACES] keyEnumerator];
	while (key = [enumerator nextObject]) {
		[xmlRoot addAttribute:[GDataXMLElement elementWithName:key stringValue:[[PaypalGateway CREDENTIALS_NAMESPACES] objectForKey:key]]];
	}

	GDataXMLElement* xmlCredentials = [GDataXMLElement elementWithName:@"n1:Credentials"];

	[xmlCredentials addChild:[GDataXMLElement elementWithName:@"Username" stringValue:[options objectForKey:@"login"]]];
	[xmlCredentials addChild:[GDataXMLElement elementWithName:@"Password" stringValue:[options objectForKey:@"password"]]];
	[xmlCredentials addChild:[GDataXMLElement elementWithName:@"Subject" stringValue:[options objectForKey:@"subject"]]];
	if (![NSString isBlank:[options objectForKey:@"signature"]])
		[xmlCredentials addChild:[GDataXMLElement elementWithName:@"Signature" stringValue:[options objectForKey:@"signature"]]];

	[xmlRoot addChild:xmlCredentials];
	[xml addChild:xmlRoot];
}

- (void) addAddress:(GDataXMLElement*)xml element:(NSString*)element address:(NSDictionary*)address
{
	if (address==nil) return;

	GDataXMLElement* xmlAddress = [GDataXMLElement elementWithName:element];

	[xmlAddress addChild:[GDataXMLNode elementWithName:@"n2:Name" stringValue:[address objectForKey:@"name"]]];
	[xmlAddress addChild:[GDataXMLNode elementWithName:@"n2:Street1" stringValue:[address objectForKey:@"address1"]]];
	[xmlAddress addChild:[GDataXMLNode elementWithName:@"n2:Street2" stringValue:[address objectForKey:@"address2"]]];
	[xmlAddress addChild:[GDataXMLNode elementWithName:@"n2:CityName" stringValue:[address objectForKey:@"city"]]];
	if ([NSString isBlank:[address objectForKey:@"state"]])
		[xmlAddress addChild:[GDataXMLNode elementWithName:@"n2:StateOrProvince" stringValue:@"N/A"]];
	else
		[xmlAddress addChild:[GDataXMLNode elementWithName:@"n2:StateOrProvince" stringValue:[address objectForKey:@"state"]]];
	[xmlAddress addChild:[GDataXMLNode elementWithName:@"n2:Country" stringValue:[address objectForKey:@"country"]]];
	[xmlAddress addChild:[GDataXMLNode elementWithName:@"n2:PostalCode" stringValue:[address objectForKey:@"zip"]]];
	[xmlAddress addChild:[GDataXMLNode elementWithName:@"n2:Phone" stringValue:[address objectForKey:@"phone"]]];

	[xml addChild:xmlAddress];
}

- (NSString*) endpointUrl
{
	NSString* certOrSig = ([NSString isBlank:[options objectForKey:@"signature"]]) ? @"certificate" : @"signature";

	if ([self isTest])
		return [[[[self class] URLS] objectForKey:@"test"] objectForKey:certOrSig];
	return [[[[self class] URLS] objectForKey:@"live"] objectForKey:certOrSig];
}

- (BillingResponse*) commit:(NSString*)action request:(NSString*)request
{
	NSDictionary* response = [self parse:action
									 xml:[self sslPost:[self endpointUrl]
												  data:[self buildRequest:request]
											   headers:[NSMutableDictionary dictionary]]];

	BillingResponse* br = [self buildResponse:[self is_successful:response]
									  message:[self messageFrom:response] params:response
									  options:[NSDictionary dictionaryWithObjectsAndKeys:
												   MakeBool([self isTest]), @"test",
												   [self authorizationFrom:response], @"authorization",
												   [self is_fraudReview:response], @"fraudReview",
												   nilToNull([NSDictionary dictionaryWithObject:nilToNull([response objectForKey:@"avsCode"]) forKey:@"code"]), @"avsResult",
												   nilToNull([response objectForKey:@"cvv2Code"]), @"cvvResult",
												   nil]];
	return br;
}

- (bool) is_fraudReview:(NSDictionary*)response
{
	return [[response objectForKey:@"errorCodes"] isEqualToString:[[self class] FRAUD_REVIEW_CODE]];
}

- (NSString*) authorizationFrom:(NSDictionary*)response
{
	if ([response objectForKey:@"transactionId"])
		return [response objectForKey:@"transactionId"];
	if ([response objectForKey:@"authorizationId"])
		return [response objectForKey:@"authorizationId"];  // from reauthorization
	return [response objectForKey:@"refundTransactionId"];
}

- (bool) is_successful:(NSDictionary*)response
{
	if ([response objectForKey:@"ack"]==nil)
		return false;
	return [[[self class] SUCCESS_CODES] containsObject:[response objectForKey:@"ack"]];
}

- (NSString*) messageFrom:(NSDictionary*)response
{
	if ([response objectForKey:@"message"])
		return [response objectForKey:@"message"];
	return [response objectForKey:@"ack"];
}


//
// Class Methods
//

static NSString* _paypalcommonapi_API_VERSION = nil;
+ (NSString *) API_VERSION {
	if (_paypalcommonapi_API_VERSION==nil) {
		_paypalcommonapi_API_VERSION = @"52.0";
	}
	return _paypalcommonapi_API_VERSION;
}

static NSDictionary* _paypalcommonapi_URLS = nil;
+ (NSDictionary *) URLS {
	if (_paypalcommonapi_URLS == nil) {
		_paypalcommonapi_URLS = [NSDictionary dictionaryWithObjectsAndKeys:
								 [NSDictionary dictionaryWithObjectsAndKeys:@"https://api.sandbox.paypal.com/2.0/", @"certificate",
								  @"https://api-3t.sandbox.paypal.com/2.0/", @"signature",
								  nil], @"test",
								 [NSDictionary dictionaryWithObjectsAndKeys:@"https://api-aa.paypal.com/2.0/", @"certificate",
								  @"https://api-3t.paypal.com/2.0/", @"signature",
								  nil], @"live",
								 nil];
	}
	[_paypalcommonapi_URLS retain];
	return _paypalcommonapi_URLS;
}

static NSString* _paypalcommonapi_PAYPAL_NAMESPACE = nil;
+ (NSString *) PAYPAL_NAMESPACE {
	if (_paypalcommonapi_PAYPAL_NAMESPACE==nil) {
		_paypalcommonapi_PAYPAL_NAMESPACE = @"urn:ebay:api:PayPalAPI";
	}
	return _paypalcommonapi_PAYPAL_NAMESPACE;
}
static NSString* _paypalcommonapi_EBAY_NAMESPACE = nil;
+ (NSString *) EBAY_NAMESPACE {
	if (_paypalcommonapi_EBAY_NAMESPACE==nil) {
		_paypalcommonapi_EBAY_NAMESPACE = @"urn:ebay:apis:eBLBaseComponents";
	}
	return _paypalcommonapi_EBAY_NAMESPACE;
}

static NSDictionary* _paypalcommonapi_ENVELOPE_NAMESPACES = nil;
+ (NSDictionary *) ENVELOPE_NAMESPACES {
	if (_paypalcommonapi_ENVELOPE_NAMESPACES == nil) {
		_paypalcommonapi_ENVELOPE_NAMESPACES = [NSDictionary dictionaryWithObjectsAndKeys:
												@"http://www.w3.org/2001/XMLSchema", @"xmlns:xsd",
												@"http://schemas.xmlsoap.org/soap/envelope/", @"xmlns:env",
												@"http://www.w3.org/2001/XMLSchema-instance", @"xmlns:xsi",
												nil];
	}
	[_paypalcommonapi_ENVELOPE_NAMESPACES retain];
	return _paypalcommonapi_ENVELOPE_NAMESPACES;
}

static NSDictionary* _paypalcommonapi_CREDENTIALS_NAMESPACES = nil;
+ (NSDictionary *) CREDENTIALS_NAMESPACES {
	if (_paypalcommonapi_CREDENTIALS_NAMESPACES == nil) {
		_paypalcommonapi_CREDENTIALS_NAMESPACES = [NSDictionary dictionaryWithObjectsAndKeys:
												   [[self class] PAYPAL_NAMESPACE], @"xmlns",
												   [[self class] EBAY_NAMESPACE], @"xmlns:n1",
												   @"0", @"env:mustUnderstand",
												   nil];
	}
	[_paypalcommonapi_CREDENTIALS_NAMESPACES retain];
	return _paypalcommonapi_CREDENTIALS_NAMESPACES;
}

static NSDictionary* _paypalcommonapi_AUSTRALIAN_STATES = nil;
+ (NSDictionary *) AUSTRALIAN_STATES {
	if (_paypalcommonapi_AUSTRALIAN_STATES == nil) {
		_paypalcommonapi_AUSTRALIAN_STATES = [NSDictionary dictionaryWithObjectsAndKeys:
											  @"Australian Capital Territory", @"ACT",
											  @"New South Wales", @"NSW",
											  @"Northern Territory", @"NT",
											  @"Queensland", @"QLD",
											  @"South Australia", @"SA",
											  @"Tasmania", @"TAS",
											  @"Victoria", @"VIC",
											  @"Western Australia", @"WA",
											  nil];
	}
	[_paypalcommonapi_AUSTRALIAN_STATES retain];
	return _paypalcommonapi_AUSTRALIAN_STATES;
}

static NSArray* _paypalcommonapi_SUCCESS_CODES = nil;
+ (NSArray *) SUCCESS_CODES {
	if (_paypalcommonapi_SUCCESS_CODES==nil) {
		_paypalcommonapi_SUCCESS_CODES = [NSArray arrayWithObjects:@"Success", @"SuccessWithWarning", nil];
	}
	[_paypalcommonapi_SUCCESS_CODES retain];
	return _paypalcommonapi_SUCCESS_CODES;
}

static NSString* _paypalcommonapi_FRAUD_REVIEW_CODE = nil;
+ (NSString *) FRAUD_REVIEW_CODE {
	if (_paypalcommonapi_FRAUD_REVIEW_CODE==nil) {
		_paypalcommonapi_FRAUD_REVIEW_CODE = @"11610";
	}
	return _paypalcommonapi_FRAUD_REVIEW_CODE;
}

static NSString* _paypalcommonapi_defaultCurrency = nil;
+ (NSString *) defaultCurrency {
	if (_paypalcommonapi_defaultCurrency==nil) {
		_paypalcommonapi_defaultCurrency = @"USD";
	}
	return _paypalcommonapi_defaultCurrency;
}

//
// Public
//
- (id) init:(NSMutableDictionary *)_options
{
	[self requires:_options, @"login", @"password", nil];
	options = _options;

	if ([options objectForKey:@"pem"]==nil && [options objectForKey:@"signature"]==nil)
		[NSException raise:@"ArgumentError"
					format:@"An API Certificate or API Signature is required to make requests to PayPal"];

	return [super init:_options];
}

- (bool) isTest
{
	if ([options objectForKey:@"test"])
		return true;
	return [super isTest];
}

- (BillingResponse*) reauthorize:(id)money authorization:(NSString*)authorization options:(NSDictionary*)_options
{
	return [self commit:@"DoReauthorization" request:[self buildReauthorizeRequest:money authorization:authorization options:_options]];
}

- (BillingResponse*) capture:(id)money authorization:(NSString*)authorization options:(NSDictionary*)_options
{
	return [self commit:@"DoCapture" request:[self buildCaptureRequest:money authorization:authorization options:_options]];
}

//- (BillingResponse*) transfer:(...);

- (BillingResponse*) voidAuthorization:(NSString*)authorization options:(NSDictionary*)_options
{
	return [self commit:@"DoVoid" request:[self buildVoidRequest:authorization options:_options]];
}

- (BillingResponse*) credit:(id)money indentification:(NSString*)indentification options:(NSDictionary*)_options
{
	return [self commit:@"RefundTransaction" request:[self buildCreditRequest:money identification:indentification options:_options]];
}
