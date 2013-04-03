//
//  LoginViewController.m
//  Google Play Project
//
//  Created by William Joshua Billingham on 11/2/12.
//  Copyright 2012 University of Michigan. All rights reserved.
//

#import "LoginViewController.h"
#import "GoogleMusicAPI.h"

NSString* baseUrl = @"http://eecs285party.appspot.com/";

@implementation LoginViewController

@synthesize emailInput;
@synthesize passwordInput;
@synthesize responseData;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSLog(@"login view controller did load");
	self.title = @"Google Play Login";
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)submitButtonPressed:(id) sender {
	NSLog(@"Submit button pressed");
	NSString *email = [NSString stringWithFormat:@"%@", self.emailInput.text];
	NSString *password = [NSString stringWithFormat:@"%@", self.passwordInput.text];
	// error checking...
	
	// try login to google
	GoogleMusicAPI* api = [GoogleMusicAPI sharedManager];
	[api login:email withPassword:password withDelegate:self];
	/*NSString *url = [baseUrl stringByAppendingString:@"/login"];
	url = [url stringByAppendingString:email];
	url = [url stringByAppendingString:@"&password=who"];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
											 cachePolicy:NSURLRequestUseProtocolCachePolicy
										 timeoutInterval:60.0];
	NSLog(@"The url is %@", url);
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if (connection) {
		responseData = [[NSMutableData alloc] init];
	} else {
		NSLog(@"Error establishing connection");
	}*/
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.responseData setLength:0];
	
	NSHTTPURLResponse* http_response = (NSHTTPURLResponse*)response;
	int resp_code = [http_response statusCode];
	NSLog(@"Response code in login controller is %d", resp_code);
	
	GoogleMusicAPI* api = [GoogleMusicAPI sharedManager];
	[api.client setCookieFromResponse:response];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"Did receive data!");
	NSString* data_str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"Data is %@", data_str);
						   
	//[self.responseData appendData:data]; // this is just the html of the front page in google music
	
	[data_str release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Errored Out!");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"Finished loading!");
	// make request for playlists and show them in a new view contorller
	[connection release];
}

- (IBAction)backgroundTapPassword:(id) sender {
	NSLog(@"resigning responders");
	[self.view endEditing:YES];
}
	
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	NSLog(@"View unloading");
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	NSLog(@"ViewController deallocing");
    [super dealloc];
}


@end
