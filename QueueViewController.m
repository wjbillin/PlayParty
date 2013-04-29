//
//  QueueViewController.m
//  Google Play Project
//
//  Created by William Joshua Billingham on 4/24/13.
//  Copyright 2013 University of Michigan. All rights reserved.
//

#import "GoogleMusicAPI.h"
#import "PartyServerAPI.h"
#import "QueueViewController.h"

@implementation QueueViewController

@synthesize queue;
@synthesize isInitialized;
@synthesize lastModified;
@synthesize timer;
@synthesize mp3_player;
@synthesize backgroundWebView;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	mp3_player = [[[MP3Player alloc] init] retain];
	backgroundWebView = [[UIWebView alloc] initWithFrame:CGRectZero];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.queue count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	NSDictionary* song = [self.queue objectAtIndex:indexPath.row];
    
    // Configure the cell...
	NSString* main_label = [song objectForKey:@"title"];
	NSMutableString* detail_label = [NSMutableString stringWithString:[song objectForKey:@"artist"]];
	[detail_label appendFormat:@" - %@", [song objectForKey:@"album"]];
	
	cell.textLabel.text = main_label;
	cell.detailTextLabel.text = detail_label;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark -
#pragma mark URL connection

- (void)didSucceedUrlLoad:(NSMutableData*)data {
	// received playlist data
	
	if (!self.isInitialized) {
		
		NSLog(@"Got response from setting of timestamp");
		// if data != 'OK', error out
		
		NSString* data_str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%@", data_str);
		if (![data_str isEqualToString:@"OK!"]) {
			NSLog(@"ERROR: setting of timestamp failed");
			return;
		}
		
		self.isInitialized = true;
		
		// start firing off queue checker requests every 5 seconds
		timer = [NSTimer scheduledTimerWithTimeInterval:5
												 target:self
											   selector:@selector(checkForUpdates:)
											   userInfo:nil
												repeats:YES];
		
		
	} else {
		NSLog(@"Got response from checking of queue");
		// if data != 'OK', error out
		
		NSString* data_str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%@", data_str);
		
		if ([data_str isEqualToString:@"Guest's time is later, should not happen"]) {
			NSLog(@"ERROR: guest's sent time should never be later than the last_mod");
		} else if (![data_str isEqualToString:@"OK!"]) {
			// assume we have a new, updated queue to display
			NSLog(@"We got a new queue!");
			
			// pull of new last_mod timestamp
			NSRange range = [data_str rangeOfString:@";"];
			if (range.location == NSNotFound) {
				NSLog(@"semi colon not found in queue checker response");
				return;
			}
			
			NSString* time_str = [data_str substringWithRange:NSMakeRange(0, range.location)];
			NSLog(@"time string is %@", time_str);
			
			// update our last_modified timestamp
			NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
			[formatter setDateFormat:@"MMddHHmmss"];
			self.lastModified = [formatter dateFromString:time_str];
			
			// strip the time from the json data that makes up the actual queue
			data_str = [data_str substringWithRange:NSMakeRange(range.location + 1,
																[data_str length] - range.location - 1)];
			NSLog(@"after removing time, data_str is %@", data_str);
			NSData* queue_data = [data_str dataUsingEncoding:NSUTF8StringEncoding];
			
			NSDictionary* result_dict = [queue_data objectFromJSONData];
			
			self.queue = [result_dict objectForKey:@"playlist"];
			[self.tableView reloadData];
			
			self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", [self.queue count]];
		} else {
			NSLog(@"Nothing new in the queue");
		}

	}
	
}

- (void)didErrorUrlLoad:(NSString*)error_str {
	NSLog(@"ERROR: %@", error_str);
}

- (void)setTimestamp {
	
	self.isInitialized = false;
	self.lastModified = [NSDate date];
	
	PartyServerAPI* server_api = [PartyServerAPI sharedManager];
	[server_api setTimestamp:self withDate:self.lastModified];
	
}

- (void)checkForUpdates:(NSTimer*)timer {
	
	NSLog(@"Calling to server to check queue");
	
	PartyServerAPI* server_api = [PartyServerAPI sharedManager];
	[server_api checkUpdates:self lastModified:self.lastModified];
	
}

#pragma mark -
#pragma mark Streaming MP3 Methods

- (void)PlayClick {
	NSLog(@"User clicked play");
	
	if ([self.queue count] == 0) {
		return;
	}
	
	//TODO: make this better
	[mp3_player playSong:[NSString stringWithUTF8String:
						  [[[self.queue objectAtIndex:0] objectForKey:@"id"] cStringUsingEncoding:NSUTF8StringEncoding]]
			withDelegate:self];
}

- (void)playUrl:(NSString*)url_str {
	
	NSURL* url = [NSURL URLWithString:url_str];
	NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url
													   cachePolicy:NSURLRequestUseProtocolCachePolicy
												   timeoutInterval:60.0];
	[req setHTTPMethod:@"GET"];
	
	[self.backgroundWebView loadRequest:req];
}
	
	

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView* header = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
	
	UIButton* play_button = [UIButton buttonWithType:UIButtonTypeCustom];
	play_button.frame = CGRectMake(140.0, 10, 40.0, 40.0);
	play_button.reversesTitleShadowWhenHighlighted = YES;
	
	[play_button setImage:[UIImage imageWithContentsOfFile:@"/Users/joshbillingham/Documents/PlayParty/play_button.png"]
				 forState:UIControlStateNormal];

	[play_button addTarget:self action:@selector(PlayClick) forControlEvents:UIControlEventTouchUpInside];
	
	[header addSubview:play_button];
	return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 50.0;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

