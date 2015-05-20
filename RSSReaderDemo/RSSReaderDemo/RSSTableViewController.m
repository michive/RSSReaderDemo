//
//  RSSTableViewController.m
//  RSSReaderDemo
//
//  Created by Michele Verani on 20/05/15.
//  Copyright (c) 2015 mikydevelop. All rights reserved.
//

#import "RSSTableViewController.h"

@interface RSSTableViewController ()

@end

@implementation RSSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"Feeds";
    
    _reloadBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadData)];
    
    self.navigationItem.rightBarButtonItem =  _reloadBtn;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //starting point
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method's

// Load data
- (void)loadData
{
    
    static NSString * const BaseURLString = @"http://www.fandango.com/rss/newmovies.rss";
    
    NSString *pathString = [NSString stringWithFormat:@"%@", BaseURLString];
    
    [self createParserForURL:pathString];
    
}

//initialization elements and starting parsing feed
-(void) createParserForURL:(NSString*)path
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [_activityIndicator setFrame:CGRectMake(self.view.frame.size.width/2 - 20, self.view.frame.size.height/2 -20, 40, 40)];
    
    [self.view addSubview:_activityIndicator];
    
    [_activityIndicator startAnimating];
    
    //initialize datasource
    _allVideos = [[NSMutableArray alloc] init];
    
    _rssParser = [[RSSParser alloc] initWithUrl:path];
    
    //custom delegate
    _rssParser.delegate = (id) self;
    
    //start process
    [_rssParser startParse];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_allVideos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"Cell";
    
    NSDictionary *cellContentDict = [_allVideos objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSString *articleDateString = [cellContentDict objectForKey:@"date"];
    
    cell.textLabel.text = [cellContentDict objectForKey:@"title"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", articleDateString];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Navigation logic
    NSString * storyLink = [[_allVideos objectAtIndex: indexPath.row] objectForKey: @"link"];
    
    // clean up the link - get rid of spaces, returns, and tabs...
    storyLink = [storyLink stringByReplacingOccurrencesOfString:@" " withString:@""];
    storyLink = [storyLink stringByReplacingOccurrencesOfString:@"n" withString:@""];
    storyLink = [storyLink stringByReplacingOccurrencesOfString:@"	" withString:@""];
    
    //deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // open Safari
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:storyLink]];
}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

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
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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


#pragma mark - RSSParserDelegate

-(void) endingParsingWithSource:(NSMutableArray*) resultParsingArray
{
    _allVideos = resultParsingArray;
    
    [self.tableView reloadData];
    
    [_activityIndicator stopAnimating];
    [_activityIndicator removeFromSuperview];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
-(void) endingParsingWithError:(NSString *) parsingError
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [_activityIndicator stopAnimating];
    [_activityIndicator removeFromSuperview];
    
    UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:parsingError delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}


#pragma mark - Table view data source


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
