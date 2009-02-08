//
//  Validatable_Implementation.h
//  objective_merchant
//
//  Created by Joshua Krall on 2/7/09.
//  Copyright 2009 TransFS.com. All rights reserved.
//


- (void) setAttributes:(NSDictionary *)_attributes
{
	NSString *key;
	NSEnumerator *enumerator = [_attributes keyEnumerator];
	while (key = [enumerator nextObject]) {
		NSString *selectorName = [NSString stringWithFormat:@"set%s", [key capitalizedString]];
		[self performSelector:NSSelectorFromString(selectorName) withObject:[_attributes objectForKey:key]];		
	}		
}

- (bool) is_valid
{
	[(NSMutableDictionary *)_errors removeAllObjects];
	if ([self respondsToSelector:NSSelectorFromString(@"beforeValidate")])
		[self performSelector:NSSelectorFromString(@"beforeValidate")];
	if ([self respondsToSelector:NSSelectorFromString(@"validate")])
		[self performSelector:NSSelectorFromString(@"validate")];
	return ([_errors count] == 0);
}

- (id) init:(NSDictionary*)attributes
{
	[self setAttributes:attributes];
	return self;
}

- (Errors *) errors
{
	if (_errors==nil) {
		_errors = [[Errors alloc] init:self];
	}
	return _errors;
}