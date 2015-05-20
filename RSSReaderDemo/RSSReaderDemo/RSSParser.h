//
//  RSSParser.h
//  RSSReaderDemo
//
//  Implementation Parsing feed
//  Created by Michele Verani on 20/05/15.
//  Copyright (c) 2015 mikydevelop. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RSSParserDelegate <NSObject>

-(void) endingParsingWithSource:(NSMutableArray*) resultParsingArray;
-(void) endingParsingWithError:(NSString *) parsingError;

@end

@interface RSSParser : NSObject<NSXMLParserDelegate, NSURLConnectionDelegate>
{
    //Url
    NSURL *_url;
    
    //parser
    NSXMLParser *_xmlParser;
    
    //item of rss feed
    NSMutableDictionary *_item;
    
    //Mutable data to store the response
    NSMutableData *_rssData;
    
    //elements of the Fandango's feed
    NSMutableString *_currentElement;
    NSMutableString *_currentTitle;
    NSMutableString *_currentDate;
    NSMutableString *_currentSummary;
    NSMutableString *_currentLink;
    NSMutableString *_currentImage;
    
    //storing the video data
    NSMutableArray *_allVideos;
    
    //internal delegate
    id<RSSParserDelegate> _delegate;
}

#pragma mark - Initialize methods
-(instancetype) initWithUrl:(NSString*)urlStr;

#pragma mark - Public methods
-(void) startParse;

#pragma mark - Public properties
@property (nonatomic, strong) id<RSSParserDelegate> delegate;

@end
