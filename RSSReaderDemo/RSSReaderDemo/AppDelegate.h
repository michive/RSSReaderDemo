//
//  AppDelegate.h
//  RSSReaderDemo
//  Demo for RSS Reader
//  Created by Michele Verani on 20/05/15.
//  Copyright (c) 2015 mikydevelop. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RSSTableViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) RSSTableViewController *rssTableViewController;


@end

