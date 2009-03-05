/*
 *  PaypalCommonAPI_Private.h
 *  objective_merchant
 *
 *  Created by Joshua Krall on 3/3/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

- (NSString*) buildReauthorizeRequest:(id)money authorization:(NSString*)authorization options:(NSDictionary*)options;
- (NSString*) buildCaptureRequest:(id)money authorization:(NSString*)authorization options:(NSDictionary*)options;
- (NSString*) buildCreditRequest:(id)money identification:(NSString*)identification options:(NSDictionary*)options;
- (NSString*) buildVoidRequest:(NSString*)authorization options:(NSDictionary*)options;
//- (NSString*) buildMassPayRequest:(...);
- (NSDictionary*) parse:(NSString*)action xml:(NSString*)xml;
- (void) parseElement:(NSMutableDictionary*)response node:(GDataXMLElement*)node;
- (NSString*) buildRequest:(NSString*)body;
- (void) addCredentials:(GDataXMLElement*)xml;
- (void) addAddress:(GDataXMLElement*)xml element:(NSString*)element address:(NSDictionary*)address;
- (NSString*) endpointUrl;
- (BillingResponse*) commit:(NSString*)action request:(NSString*)request;
- (bool) is_fraudReview:(NSDictionary*)response;
- (NSString*) authorizationFrom:(NSDictionary*)response;
- (bool) is_successful:(NSDictionary*)response;
- (NSString*) messageFrom:(NSDictionary*)response;

