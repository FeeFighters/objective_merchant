//
//  PostsData.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//


- (NSString*) sslPost:(NSString *)url data:(NSString *)data headers:(NSMutableDictionary*)headers
{
	[headers setObject:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
	
	CFURLRef myURL = CFURLCreateWithString(kCFAllocatorDefault, (CFStringRef)url, NULL);
	
	CFStringRef requestMethod = CFSTR("POST");
	CFHTTPMessageRef myRequest = CFHTTPMessageCreateRequest(kCFAllocatorDefault, requestMethod, myURL,
															kCFHTTPVersion1_1);
	
	CFStringRef headerFieldName = CFSTR("Content-Type");
	CFStringRef headerFieldValue = CFSTR("application/x-www-form-urlencoded");
	CFHTTPMessageSetHeaderFieldValue(myRequest, headerFieldName, headerFieldValue);
	CFHTTPMessageSetBody(myRequest, (CFDataRef)[data UTF8String]);

	CFReadStreamRef myReadStream = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, myRequest);
	
	NSDictionary *sslSettings = [NSDictionary dictionaryWithObjectsAndKeys:
								 (NSString *)kCFStreamSocketSecurityLevelNegotiatedSSL, kCFStreamSSLLevel,
								 [NSNumber numberWithBool:YES], kCFStreamSSLAllowsExpiredCertificates,
								 [NSNumber numberWithBool:YES], kCFStreamSSLAllowsExpiredRoots,
								 [NSNumber numberWithBool:YES], kCFStreamSSLAllowsAnyRoot,
								 [NSNumber numberWithBool:NO], kCFStreamSSLValidatesCertificateChain,
								 [NSNull null], kCFStreamSSLPeerName,
								 nil];
	CFReadStreamSetProperty(myReadStream, kCFStreamPropertySSLSettings, sslSettings);
	CFReadStreamSetProperty(myReadStream, kCFStreamPropertyHTTPShouldAutoredirect, kCFBooleanTrue);
	
	CFReadStreamOpen(myReadStream);

	CFHTTPMessageRef myResponse = (CFHTTPMessageRef)CFReadStreamCopyProperty(myReadStream, kCFStreamPropertyHTTPResponseHeader);	
	//CFStringRef myStatusLine = CFHTTPMessageCopyResponseStatusLine(myResponse);
	//UInt32 myErrCode = CFHTTPMessageGetResponseStatusCode(myResponse);	

	CFDataRef myBody = CFHTTPMessageCopyBody(myResponse);
	NSString *body = [[NSString alloc] initWithBytes:CFDataGetBytePtr(myBody) length:CFDataGetLength(myBody)];
	
	CFRelease(myURL);
	CFRelease(myRequest);
	CFRelease(myReadStream);	
	CFRelease(myResponse);		
	//CFRelease(myStatusLine);
	CFRelease(myBody);
	[sslSettings release];
	
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
