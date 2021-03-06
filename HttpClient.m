//
//  HttpClient.m
//  Google Play Project
//
//  Created by William Joshua Billingham on 3/12/13.
//  Copyright 2013 University of Michigan. All rights reserved.
//

#import "HttpClient.h"

NSString* GOOGLE_COOKIE_FORMAT = @"?u=0&xt=%@";
NSString* GOOGLE_LOGIN_AUTH_KEY = @"Authorization";
NSString* GOOGLE_LOGIN_AUTH_VALUE = @"GoogleLogin auth=%@";
NSString* HTTPS_PLAY_GOOGLE_COM_MUSIC_LISTEN = @"https://play.google.com/music/listen?hl=en&u=0";
NSString* HTTPS_PLAY_GOOGLE_COM_MUSIC_SERVICES = @"https://play.google.com/music/services/";

@implementation HttpClient

@synthesize authorizationToken;
@synthesize cookie;
@synthesize rawCookie;
@synthesize receivedData;
@synthesize client;
@synthesize isStartup;

- (id)init {
	authorizationToken = [@"" retain];
	cookie = [@"" retain];
	rawCookie = [@"" retain];
	receivedData = [[NSMutableData data] retain];
	client = [self retain];
	isStartup = true;
	return self;
}

- (id)initWithDelegate:(id)delegate {
	authorizationToken = [@"" retain];
	cookie = [@"" retain];
	rawCookie = [@"" retain];
	receivedData = [[NSMutableData data] retain];
	client = [delegate retain];
	isStartup = true;
	return self;
}

- (void)setClientOnce:(id)delegate {
	self.client = delegate;
}

- (NSString*)extractAuthToken:(NSString*)response {
	
	//Pattern pattern = Pattern.compile("Auth=(?<AUTH>(.*?))$", Pattern.CASE_INSENSITIVE);
	//String auth = pattern.matcher(EntityUtils.toString(response.getEntity())).group();
	
	NSRange startRange = [response rangeOfString:@"Auth="];
	NSRange targetRange;
	targetRange.location = startRange.location + startRange.length;
	targetRange.length = response.length - targetRange.location;
	NSString * result = [response substringWithRange:targetRange];
	NSRange endRange = [result rangeOfString:@"\n"];
	endRange.length = endRange.location;
	endRange.location = 0;
	result = [result substringWithRange:endRange];
	
	NSLog(@"Extracted auth token is %@", result);
	
	return result;
}

- (NSMutableURLRequest*)prepareConnection:(NSString*)address withMethod:(NSString*)method {
	
	NSLog(@"In prepare connection");
	
	// Create the request.
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self adjustAddress:address] 
											 cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:60.0];
	
	[request setHTTPMethod:method];
	//connection.setDoOutput(output);
	if(self.authorizationToken != NULL && self.authorizationToken != @"")
	{
		NSLog(@"Auth token is valid");
		[request setValue:[NSString stringWithFormat:GOOGLE_LOGIN_AUTH_VALUE, self.authorizationToken]
			forHTTPHeaderField:GOOGLE_LOGIN_AUTH_KEY];
	}
	NSLog(@"the login auth header is %@", [NSString stringWithFormat:GOOGLE_LOGIN_AUTH_VALUE, self.authorizationToken]);
	return request;
}

- (void)dispatchGet:(NSString*)address {
	NSMutableURLRequest* request = [self prepareConnection:address withMethod:@"GET"];
	
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if (connection) {
		// Create the NSMutableData to hold the received data.
		// receivedData is an instance variable declared elsewhere.
		NSLog(@"set up connection ok");
	} else {
		NSLog(@"failed to set up the connection");
		// Inform the user that the connection failed.
	}
}

- (void)dispatchGetWithRequest:(NSMutableURLRequest *)req query:(NSString*) query {
	
	NSString* path = [[[req URL] absoluteString] stringByAppendingString:@"?"];
	
	[req setURL:[NSURL URLWithString:[path stringByAppendingString:query]]];
	[req setHTTPMethod:@"GET"];
	
	NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
	
	if (connection) {
		NSLog(@"set up connection ok");
	} else {
		NSLog(@"failed to set up connection");
	}
}

- (void)dispatchPost:(NSString*)address withForm:(FormBuilder*)form {
	
	NSMutableURLRequest* request = [self prepareConnection:address withMethod:@"POST"];
	NSString* string = form.content_type;
	if([string length] != 0) {
		[request setValue:string forHTTPHeaderField:@"Content-Type"];
		request.HTTPBody = form.data; // this should be a property so we can reference it
	} else {
		NSLog(@"content type is null or empty");
		return;
	}
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

	if (connection) {
		// Create the NSMutableData to hold the received data.
		// receivedData is an instance variable declared elsewhere.
		NSLog(@"set up connection ok");
	} else {
		NSLog(@"failed to set up the connection");
		// Inform the user that the connection failed.
	}
}

- (void)dispatchPostWithRequest:(NSMutableURLRequest*)req body:(NSData*)body {
	
	[req setHTTPBody:body];
	[req setHTTPMethod:@"POST"];
	
	NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
	
	if (connection) {
		NSLog(@"set up connection ok");
	} else {
		NSLog(@"failed to set up connection");
	}
}


- (void)setCookieFromResponse:(NSURLResponse*)response {
	
	NSHTTPURLResponse* http_response = (NSHTTPURLResponse *)response;
	NSDictionary* fields = [http_response allHeaderFields];
	
	NSString* string = [fields valueForKey:@"Set-Cookie"];
	
	NSLog(@"cookie from response is %@", string);
	
	if([string length] != 0 && cookie == @"") {
		self.rawCookie = string;
		NSRange startRange = [self.rawCookie rangeOfString:@"xt="];
		NSRange targetRange;
		targetRange.location = startRange.location + startRange.length;
		targetRange.length = self.rawCookie.length - targetRange.location;
		NSString * result = [self.rawCookie substringWithRange:targetRange];
		NSRange endRange = [result rangeOfString:@";"];
		endRange.length = endRange.location;
		endRange.location = 0;
		self.cookie = [result substringWithRange:endRange];
		
		NSLog(@"%@", self.cookie);
	}
}

- (void)setupAuthentication:(NSString*)response {
	self.authorizationToken = [self extractAuthToken:response];
	//NSLog(@"auth token is %@", self.authorizationToken);
	[self dispatchPost:HTTPS_PLAY_GOOGLE_COM_MUSIC_LISTEN withForm:[FormBuilder getEmpty]];
}

- (NSURL*)adjustAddress:(NSString*)address {
	NSRange range = [address rangeOfString:HTTPS_PLAY_GOOGLE_COM_MUSIC_SERVICES];
	if(range.location != NSNotFound)
	{
		NSString * cookie_str = [NSString stringWithFormat:GOOGLE_COOKIE_FORMAT, self.cookie];
		address = [address stringByAppendingString:cookie_str];
	}
	
	NSLog(@"final address is %@", address);
	
	return [NSURL URLWithString:address];
}

// NSURLConnectionDelgate methods

-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Received response");
	[self setCookieFromResponse:response];
	[self.receivedData setLength:0];
	
	NSHTTPURLResponse* http_response = (NSHTTPURLResponse*)response;
	int resp_code = [http_response statusCode];
	NSLog(@"Response code in http client is %d", resp_code);
	
	if (resp_code != 200) {
		// unauthorized or other bad things, tell client
		[connection cancel];
		[connection release];
		NSString* error = @"Response code error: ";
		error = [error stringByAppendingString:[NSString stringWithFormat:@"%d", resp_code]];
		[self.client didErrorUrlLoad:error];
	}
}

-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data {
	NSLog(@"Received data");
	[self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // release the connection, and the data object
    [connection release];
	
    // inform the user
	NSString* error_str = [NSString stringWithFormat:@"Connection failed! Error - %@ %@",
						   [error localizedDescription],
						   [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]];
	
	[self.client didErrorUrlLoad:error_str];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
	
    [connection release];
	
	if (self.isStartup) {
		// this will fire off another post request to authorize listening to music
		self.isStartup = false;
		NSString* response = [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease];
		[self setupAuthentication:response];
	} else {
		[self.client didSucceedUrlLoad:self.receivedData];
	}
}		

- (void)dealloc {
	[authorizationToken release];
	[cookie release];
	[rawCookie release];
	[client release];
	[receivedData release];
	
	[super dealloc];
}

@end
