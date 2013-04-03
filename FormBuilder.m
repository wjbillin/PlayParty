//
//  FormBuilder.m
//  Google Play Project
//
//  Created by William Joshua Billingham on 3/21/13.
//  Copyright 2013 University of Michigan. All rights reserved.
//

#import "FormBuilder.h"


@implementation FormBuilder

@synthesize data;
@synthesize content_type;
@synthesize boundary;

- (id)init {
	NSDateFormatter* date_formatter = [[NSDateFormatter alloc] init];
	[date_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate* date = [NSDate date];
	
	boundary = [[@"----------" stringByAppendingString:[date_formatter stringFromDate:date]] retain];
	content_type = [[@"multipart/form-data; boundary=" stringByAppendingString:self.boundary] retain];
	
	data = [[NSMutableData data] retain];
	
	[date_formatter release];
	
	return self;
}

+ (FormBuilder*)getEmpty {
	FormBuilder* form = [[[FormBuilder alloc] init] autorelease];
	[form close];
	return form;
}

- (void)addField:(NSString*)key withValue:(NSString*)value {
	NSString* entry = @"";
	entry = [entry stringByAppendingString:[NSString stringWithFormat:@"\r\n--%@\r\n", self.boundary]];
	entry = [entry stringByAppendingString:@"Content-Disposition: form-data;"];
	entry = [entry stringByAppendingString:[NSString stringWithFormat:@"name=\"%@\";\r\n\r\n%@", key, value]];
	
	[self.data appendData:[entry dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)close {
	NSString* message = [@"\r\n--" stringByAppendingString:self.boundary];
	message = [message stringByAppendingString:@"--\r\n"];
	[self.data appendData:[message dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSString* data_str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", data_str);
	[data_str release];
}

@end
