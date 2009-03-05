//
//  PostsData.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

#import "objCFixes.h"

- (NSString*) sslPost:(NSString *)url data:(NSString *)data headers:(NSMutableDictionary*)headers
{
	[headers setObject:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
	
	NSURL *myURL = [NSURL URLWithString:url];

	NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:myURL];

	NSString* curKey;
	NSEnumerator *enumerator = [headers keyEnumerator];
	while (curKey = [enumerator nextObject]) {
		[myRequest addValue:nilToNull([headers objectForKey:curKey]) forHTTPHeaderField:curKey];
	}

	[myRequest setHTTPMethod:@"POST"];
	[myRequest setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLResponse *myResponse = nil;
	NSError *error = nil;
	NSData *responseData = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:&myResponse error:&error];
	NSString *body = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	
	return body;
}

//
// Class inheritable accessors
//
static bool _Posts_Data_sslStrict = true;
static bool _Posts_Data_pemPassword = false;
static bool _Posts_Data_retrySafe = false;
static int _Posts_Data_openTimeout = 60;
static int _Posts_Data_readTimeout = 60;
static int _Posts_Data_maxRetries = 3;

+ (bool) sslStrict
{
	return _Posts_Data_sslStrict;
}
+ (void) setSslStrict:(bool)val
{
	_Posts_Data_sslStrict = val;
}
+ (bool) pemPassword
{
	return _Posts_Data_pemPassword;
}
+ (void) setPemPassword:(bool)val
{
	_Posts_Data_pemPassword = val;
}
+ (bool) retrySafe
{
	return _Posts_Data_retrySafe;
}
+ (void) setRetrySafe:(bool)val
{
	_Posts_Data_retrySafe = val;
}
+ (int) openTimeout
{
	return _Posts_Data_openTimeout;
}
+ (void) setOpenTimeout:(int)val
{
	_Posts_Data_openTimeout = val;
}
+ (int) readTimeout
{
	return _Posts_Data_readTimeout;
}
+ (void) setReadTimeout:(int)val
{
	_Posts_Data_readTimeout = val;
}
+ (int) maxRetries
{
	return _Posts_Data_maxRetries;
}
