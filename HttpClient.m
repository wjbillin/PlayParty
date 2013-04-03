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
@synthesize delegate;

- (id)init {
	authorizationToken = [@"" retain];
	cookie = [@"" retain];
	rawCookie = [@"" retain];
	receivedData = [[NSMutableData data] retain];
	delegate = [self retain];
	return self;
}

- (void)setDelegateOnce:(id)delegate {
	self.delegate = delegate;
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
	// HttpURLConnection connection = (HttpURLConnection) adjustAddress(address).toURL().openConnection();
	// connection.setRequestMethod("GET");
	// connection.setRequestProperty("Cookie", rawCookie);
	// if(authorizationToken != null)
	// {
	// connection.setRequestProperty("Authorization", String.format("GoogleLogin auth=%1$s", authorizationToken));
	// }
	NSMutableURLRequest* request = [self prepareConnection:address withMethod:@"GET"];
	
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self.delegate];
	if (connection) {
		// Create the NSMutableData to hold the received data.
		// receivedData is an instance variable declared elsewhere.
		NSLog(@"set up connection ok");
	} else {
		NSLog(@"failed to set up the connection");
		// Inform the user that the connection failed.
	}
	
	/*connection.connect();
	if(connection.getResponseCode() != 200)
	{
		throw new IllegalStateException("Statuscode " + connection.getResponseCode() + " not supported");
	}
	
	setCookie(connection);
	
	return streamToString(connection.getInputStream());*/
}

- (void)dispatchPost:(NSString*)address withForm:(FormBuilder*)form isLogin:(bool)login {
	
	NSMutableURLRequest* request = [self prepareConnection:address withMethod:@"POST"];
	NSString* string = form.content_type;
	if([string length] != 0) {
		[request setValue:string forHTTPHeaderField:@"Content-Type"];
		request.HTTPBody = form.data; // this should be a property so we can reference it
	} else {
		NSLog(@"content type is null or empty");
		return;
	}
	
	NSURLConnection * connection; 
	if (login) {
		connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	} else {
		connection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
	}

	if (connection) {
		// Create the NSMutableData to hold the received data.
		// receivedData is an instance variable declared elsewhere.
		NSLog(@"set up connection ok");
	} else {
		NSLog(@"failed to set up the connection");
		// Inform the user that the connection failed.
	}
	
	
	/*connection.connect();
	connection.getOutputStream().write(form.getBytes());
	if(connection.getResponseCode() != 200)
	{
		throw new IllegalStateException("Statuscode " + connection.getResponseCode() + " not supported");
	}
	
	String response = streamToString(connection.getInputStream());
	
	setCookie(connection);
	
	if(!isStartup) *** call these methods where appropriate
	{
		return response;
	}
	return setupAuthentication(response);*/
}

- (void)setCookieFromResponse:(NSURLResponse*)response {
	
	NSHTTPURLResponse* http_response = (NSHTTPURLResponse *)response;
	NSDictionary* fields = [http_response allHeaderFields];
	
	NSString* string = [fields valueForKey:@"Set-Cookie"];
	
	if([string length] != 0 && cookie == NULL) {
		self.rawCookie = string;
		NSRange startRange = [self.rawCookie rangeOfString:@"xt="];
		NSRange targetRange;
		targetRange.location = startRange.location + startRange.length;
		targetRange.length = self.rawCookie.length - targetRange.location;
		NSString * result = [self.rawCookie substringWithRange:targetRange];
		NSRange endRange = [result rangeOfString:@"\n"];
		endRange.length = endRange.location;
		endRange.location = 0;
		self.cookie = [self.rawCookie substringWithRange:endRange];
		
		NSLog(@"%@", self.cookie);
	}
}

- (void)setupAuthentication:(NSString*)response {
	self.authorizationToken = [self extractAuthToken:response];
	NSLog(@"%@", self.authorizationToken);
	[self dispatchPost:HTTPS_PLAY_GOOGLE_COM_MUSIC_LISTEN withForm:[FormBuilder getEmpty] isLogin:false];
}

- (NSURL*)adjustAddress:(NSString*)address {
	NSRange range = [address rangeOfString:HTTPS_PLAY_GOOGLE_COM_MUSIC_SERVICES];
	if(range.location != NSNotFound)
	{
		NSString * cookie_str = [NSString stringWithFormat:GOOGLE_COOKIE_FORMAT, self.cookie];
		address = [address stringByAppendingString:cookie_str];
	}
	
	NSLog(@"%@", address);
	
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
}

-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data {
	NSLog(@"Received data");
	[self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // release the connection, and the data object
    [connection release];
	
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
	
	NSLog(@"%", [[[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding] autorelease]);
	
    [connection release];
	
	// login was successful, let's set up the authentication
	NSString* response = [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease];
	[self setupAuthentication:response];
}

- (void)dealloc {
	[authorizationToken release];
	[cookie release];
	[rawCookie release];
	[delegate release];
	[receivedData release];
	
	[super dealloc];
}

@end
