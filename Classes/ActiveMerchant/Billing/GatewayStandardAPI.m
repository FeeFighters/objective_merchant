//
//  GatewayStandardAPI.m
//  TransFS Card Terminal
//
//  Created by Joshua Krall on 9/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GatewayStandardAPI.h"


@implementation BillingGateway (GatewayStandardAPI)


- (BillingResponse *) authorize:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)options
{
  [NSException raise:@"Gateway Action Not Supported" format:@"%@ does not support authorize", [[self class] description]];
  return nil;
}

- (BillingResponse *) purchase:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)options
{
  [NSException raise:@"Gateway Action Not Supported" format:@"%@ does not support purchase", [[self class] description]];
  return nil;
}

- (BillingResponse *) capture:(id)money authorization:(NSString*)authorization options:(NSDictionary*)options
{
  [NSException raise:@"Gateway Action Not Supported" format:@"%@ does not support capture", [[self class] description]];
  return nil;
}

- (BillingResponse *) voidAuthorization:(NSString*)authorization options:(NSDictionary*)options
{
  [NSException raise:@"Gateway Action Not Supported" format:@"%@ does not support voidAuthorization", [[self class] description]];
  return nil;
}

- (BillingResponse *) credit:(id)money identification:(NSString*)identification options:(NSDictionary*)options
{
  [NSException raise:@"Gateway Action Not Supported" format:@"%@ does not support credit", [[self class] description]];
  return nil;
}

- (BillingResponse *) recurring:(id)money creditcard:(BillingCreditCard*)creditcard options:(NSDictionary*)options
{
  [NSException raise:@"Gateway Action Not Supported" format:@"%@ does not support recurring", [[self class] description]];
  return nil;
}

- (BillingResponse *) updateRecurring:(NSDictionary*)options
{
  [NSException raise:@"Gateway Action Not Supported" format:@"%@ does not support updateRecurring", [[self class] description]];
  return nil;
}

- (BillingResponse *) cancelRecurring:(NSString*)subscriptionId
{
  [NSException raise:@"Gateway Action Not Supported" format:@"%@ does not support cancelRecurring", [[self class] description]];
  return nil;
}

- (NSString*) endpointUrl
{
  [NSException raise:@"Gateway Action Not Supported" format:@"%@ does not provide an endpointUrl", [[self class] description]];
  return nil;
}

@end
