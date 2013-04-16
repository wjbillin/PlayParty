//
//  LoginViewController.m
//  Google Play Project
//
//  Created by William Joshua Billingham on 11/2/12.
//  Copyright 2012 University of Michigan. All rights reserved.
//

#import "LoginViewController.h"
#import "PlaylistSelectController.h"
#import "GoogleMusicAPI.h"

NSString* baseUrl = @"http://eecs285party.appspot.com/";

@implementation LoginViewController

@synthesize emailInput;
@synthesize passwordInput;
@synthesize responseData;
@synthesize playlistSelectController;

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
}

- (void)didSucceedUrlLoad:(NSMutableData*) data {
	// set up table view
	NSLog(@"Got good response, wooo!");
	
	[[self navigationController] pushViewController:playlistSelectController animated:YES];
	
	GoogleMusicAPI* api = [GoogleMusicAPI sharedManager];
	[api getPlaylists:self.playlistSelectController];
	
}

- (void)didErrorUrlLoad:(NSString*) error {
	NSLog(@"ERROR in login view controller url response");
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
