//
//  RSSTableViewController.h
//  RSSReaderDemo
//  TableviewController for Fandango films
//
//  Created by Michele Verani on 20/05/15.
//  Copyright (c) 2015 mikydevelop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSTableViewController : UITableViewController
{
    //List of the films
    NSArray *_allVideos;
    
    //activity indicator
    UIActivityIndicatorView * _activityIndicator;
    
}

@end
