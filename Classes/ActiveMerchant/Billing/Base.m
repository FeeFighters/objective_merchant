//
//  Base.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "Base.h"


@implementation BillingBase

static BillingModes _BillingBase_mode = PRODUCTION;
static BillingModes _BillingBase_gatewayMode = PRODUCTION;
static BillingModes _BillingBase_integrationMode = PRODUCTION;

+ (BillingModes) gatewayMode
{
	return _BillingBase_gatewayMode;
}

+ (void)setGatewayMode:(BillingModes)gatewayMode
{
	_BillingBase_gatewayMode = gatewayMode;
}

+ (BillingModes) integrationMode
{
	return _BillingBase_integrationMode;
}

+ (void)setIntegrationMode:(BillingModes)integrationMode
{
	_BillingBase_integrationMode = integrationMode;
}

+ (BillingModes) mode
{
	return _BillingBase_mode;
}

+ (void)setMode:(BillingModes)mode
{
	_BillingBase_mode = mode;
	_BillingBase_integrationMode = mode;
	_BillingBase_gatewayMode = mode;	
}

+ (bool)is_test_mode
{
	return (_BillingBase_gatewayMode == TEST);
}

@end