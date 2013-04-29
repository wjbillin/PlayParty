//
//  PartyServerAPI.m
//  Google Play Project
//
//  Created by William Joshua Billingham on 4/24/13.
//  Copyright 2013 University of Michigan. All rights reserved.
//

#import "PartyServerAPI.h"
#import "HttpBodyBuilder.h"

NSString* baseUrl = @"https://eecs285party.appspot.com/";

@implementation PartyServerAPI
@synthesize host;

+ (id)sharedManager {
    static PartyServerAPI *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
	if (self = [super init]) {
		host = [@"" retain];
	}
	return self;
}

- (void)login:(NSString*)host pass:(NSString*)pass title:(NSString*)title withDelegate:(id)delegate {
	
	self.host = host;
	
	NSString* addr = [baseUrl stringByAppendingString:@"login"];
	NSURL* url = [NSURL URLWithString:addr];
	NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url
													   cachePolicy:NSURLRequestUseProtocolCachePolicy
												   timeoutInterval:60.0];
	
	HttpBodyBuilder* builder = [[HttpBodyBuilder alloc] init];
	[builder addField:@"email" withValue:host];
	[builder addField:@"auth" withValue:pass];
	[builder addField:@"title" withValue:title];
	
	NSData* body_data = [builder close];
	
	NSLog(@"body sent to middle man is %@", builder.body);
	
	HttpClient* client = [[[HttpClient alloc] initWithDelegate:delegate] autorelease];
	client.isStartup = FALSE;
	
	// will call -didSucceedUrlLoad method of delegate
	[client dispatchPostWithRequest:req body:body_data];
	
	[builder release];
	
};

- (void)getPlaylists:(NSArray*)playlists withDelegate:(id)delegate {
	
	NSString* addr = [baseUrl stringByAppendingString:@"get_songs"];
	
	NSLog(@"address is %@", addr);
	
	NSURL* url = [NSURL URLWithString:addr];
	NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url
													   cachePolicy:NSURLRequestUseProtocolCachePolicy
												   timeoutInterval:60.0];
	
	HttpBodyBuilder* builder = [[HttpBodyBuilder alloc] init];
	[builder addField:@"host" withValue:self.host];
	[builder addField:@"num" withValue:[NSString stringWithFormat:@"%d", [playlists count]]];
	for (int i = 0; i < [playlists count]; ++i) {
		[builder addField:[NSString stringWithFormat:@"p%d", i+1]
				withValue:[NSString stringWithFormat:@"%d", [[playlists	objectAtIndex:i] integerValue]]];
	}
	
	[builder close];
	
	NSLog(@"body sent to middle man is %@", builder.body);
	
	HttpClient* client = [[[HttpClient alloc] initWithDelegate:delegate] autorelease];
	client.isStartup = FALSE;
	
	[client dispatchGetWithRequest:req query:builder.body];
	
	[builder release];
}

- (void)setTimestamp:(id)delegate withDate:(NSDate*)date {
	
	NSString* addr = [baseUrl stringByAppendingString:@"set_timestamp"];
	
	NSLog(@"address is %@", addr);
	
	NSURL* url = [NSURL URLWithString:addr];
	NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url
													   cachePolicy:NSURLRequestUseProtocolCachePolicy
												   timeoutInterval:60.0];
	
	HttpBodyBuilder* builder = [[HttpBodyBuilder alloc] init];
	[builder addField:@"host" withValue:self.host];

	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MMddHHmmss"];
	[builder addField:@"time" withValue:[formatter stringFromDate:date]];
	
	NSData* body_data = [builder close];
	
	NSLog(@"body sent to middle man is %@", builder.body);
	
	HttpClient* client = [[[HttpClient alloc] initWithDelegate:delegate] autorelease];
	client.isStartup = FALSE;
	
	[client dispatchPostWithRequest:req body:body_data];
	
	[formatter release];
	[builder release];
}
	 
- (void)checkUpdates:(id)delegate lastModified:(NSDate*)date {
	NSString* addr = [baseUrl stringByAppendingString:@"check_update"];
	
	NSLog(@"address is %@", addr);
	
	NSURL* url = [NSURL URLWithString:addr];
	NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url
													   cachePolicy:NSURLRequestUseProtocolCachePolicy
												   timeoutInterval:60.0];
	
	HttpBodyBuilder* builder = [[HttpBodyBuilder alloc] init];
	[builder addField:@"host" withValue:self.host];
	
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MMddHHmmss"];
	[builder addField:@"last_mod" withValue:[formatter stringFromDate:date]];
	
	[builder close];
	
	NSLog(@"body sent to middle man is %@", builder.body);
	
	HttpClient* client = [[[HttpClient alloc] initWithDelegate:delegate] autorelease];
	client.isStartup = FALSE;
	
	[client dispatchGetWithRequest:req query:builder.body];
	
	[formatter release];
	[builder release];
}

- (void)addSongToQueue:(id)delegate songIndex:(NSIndexPath*)indexPath {
	NSString* addr = [baseUrl stringByAppendingString:@"action"];
	
	NSLog(@"address is %@", addr);
	
	NSURL* url = [NSURL URLWithString:addr];
	NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url
													   cachePolicy:NSURLRequestUseProtocolCachePolicy
												   timeoutInterval:60.0];
	
	HttpBodyBuilder* builder = [[HttpBodyBuilder alloc] init];
	[builder addField:@"host" withValue:self.host];
	
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MMddHHmmss"];
	[builder addField:@"time" withValue:[formatter stringFromDate:[NSDate date]]];
	
	[builder addField:@"pl_index" withValue:[NSString stringWithFormat:@"%d", indexPath.section]];
	[builder addField:@"song_index" withValue:[NSString stringWithFormat:@"%d", indexPath.row]];
	[builder addField:@"action" withValue:[NSString stringWithFormat:@"%d", 1]]; // add, not delete
	
	NSData* body_data = [builder close];
	
	NSLog(@"body sent to middle man is %@", builder.body);
	
	HttpClient* client = [[[HttpClient alloc] initWithDelegate:delegate] autorelease];
	client.isStartup = FALSE;
	
	[client dispatchPostWithRequest:req body:body_data];
	
	[formatter release];
	[builder release];
}

- (void)dealloc {
	[super dealloc];
}


@end
