//
//  HttpBodyBuilder.m
//  Google Play Project
//
//  Created by William Joshua Billingham on 4/24/13.
//  Copyright 2013 University of Michigan. All rights reserved.
//

#import "HttpBodyBuilder.h"


@implementation HttpBodyBuilder
@synthesize body;

- (id)init {
	body = [[NSMutableString stringWithString:@""] retain];
	
	return self;
}

- (void)addField:(NSString*)key withValue:(NSString*) value {
	[self.body appendString:key];
	[self.body appendString:[NSString stringWithFormat:@"=%@&", value]];
}

- (NSData*)close {
	if ([self.body length] > 0) {
		// get rid of last erroneous "&"
		[self.body deleteCharactersInRange:NSMakeRange([self.body length] - 1, 1)];
	}
	NSData* body_data = [self.body dataUsingEncoding:NSUTF8StringEncoding];
	return body_data;
}
	
@end
