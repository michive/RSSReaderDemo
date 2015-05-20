//
//  RSSTableViewController.h
//  RSSReaderDemo
//  TableviewController for Fandango films
//
//  Created by Michele Verani on 20/05/15.
//  Copyright (c) 2015 mikydevelop. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RSSParser.h"

@interface RSSTableViewController : UITableViewController
{
    //List of the films
    NSArray *_allVideos;
    
    //activity indicator
    UIActivityIndicatorView * _activityIndicator;
    
    //feed parser
    RSSParser *_rssParser;
    
    UIBarButtonItem *_reloadBtn;
    
}

@end
