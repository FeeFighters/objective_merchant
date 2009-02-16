//
//  Utils_Implementation.m
//  objective_merchant
//
//  Created by Joshua Krall on 2/8/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//

- (NSString *) generateUniqueId
{
	NSMutableData *data = [[NSMutableData alloc] init];
	NSDate *today = [NSDate date];
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
	[dateFormatter setDateStyle:NSDateFormatterLongStyle];
	[dateFormatter setTimeStyle:NSDateFormatterLongStyle];
	NSString *dateStr = [dateFormatter stringFromDate:today];
	[data appendBytes:[dateStr UTF8String] length:[dateStr length]];
	
	[dateFormatter setDateFormat:@"S"];
	dateStr = [dateFormatter stringFromDate:today];	
	[data appendBytes:[dateStr UTF8String] length:[dateStr length]];
	
	NSString *randStr = [NSString stringWithFormat:@"%d", random()];
	[data appendBytes:[randStr UTF8String] length:[randStr length]];
	
	//	md5 << String($$)  -- Not sure what to do about this one...	
	
	NSString *classNameStr = [NSString stringWithFormat:@"%s", [[self class] name]];
	[data appendBytes:[classNameStr UTF8String] length:[classNameStr length]];
	
	return [data md5ToString];
}