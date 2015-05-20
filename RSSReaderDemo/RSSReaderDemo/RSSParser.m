//
//  RSSParser.m
//  RSSReaderDemo
//
//  Created by Michele Verani on 20/05/15.
//  Copyright (c) 2015 mikydevelop. All rights reserved.
//

#import "RSSParser.h"

@implementation RSSParser

@synthesize delegate = _delegate;

#pragma mark - lifecycle

/**
 * @method Intialization method
 * @param urlStr URL definition
 *
 */
-(instancetype) initWithUrl:(NSString*)urlStr
{
    self = [super init];
    if (self)
    {
        _url = [NSURL URLWithString:urlStr];
    }
    
    return self;
}

#pragma mark - Private Methods

-(void) createConnection:(NSURL*)url
{
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if (theConnection)
    {
        _rssData = [NSMutableData data];
    }
    else
    {
        NSString * errorString = [NSString stringWithFormat:@"Unable connect from web site"];
        
        if ([self.delegate respondsToSelector:@selector(endingParsingWithError:)])
        {
            [self.delegate endingParsingWithError:errorString];
        }
        
    }
}

//Sorting the title's film
-(NSArray*) createSortedArray:(NSMutableArray*) unsortedArray
{
    NSArray * sortedArray = [[NSArray alloc] init];
    
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
    sortedArray = [unsortedArray sortedArrayUsingDescriptors:sortDescriptors];
    
    return sortedArray;
}

#pragma mark - Public Methods
/**
 *  @method Start the process to create the connection with
 *          Fandango feed an parsing feed
 *
 */
-(void) startParse
{
    [self createConnection:_url];
}

#pragma mark -
#pragma mark NSUrlConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_rssData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSString *result = [[NSString alloc] initWithData:_rssData encoding:NSUTF8StringEncoding];
    
    NSLog(@"RESULT: %@",result);
    
    // NSXMLParser
    _xmlParser = [[NSXMLParser alloc] initWithData:_rssData];
    
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
    [_xmlParser setDelegate:self];
    
    // Enable these features of NSXMLParser.
    [_xmlParser setShouldProcessNamespaces:NO];
    [_xmlParser setShouldReportNamespacePrefixes:NO];
    [_xmlParser setShouldResolveExternalEntities:NO];

    [_xmlParser parse];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSString * errorString = [NSString stringWithFormat:@"Unable to download feeds from web site (Error code %li )", [error code]];
    
    if ([self.delegate respondsToSelector:@selector(endingParsingWithError:)])
    {
        [self.delegate endingParsingWithError:errorString];
    }
    
}

#pragma mark NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //Initialize the Datasource
    _allVideos = [[NSMutableArray alloc] init];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSString * errorString = [NSString stringWithFormat:@"Unable to download feeds from web site (Error code %li )", [parseError code]];
    
    if ([self.delegate respondsToSelector:@selector(endingParsingWithError:)])
    {
        [self.delegate endingParsingWithError:errorString];
    }
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    _currentElement = [elementName copy];
    
    if ([elementName isEqualToString:@"item"])
    {
        // clear out videos elements...
        _item = [[NSMutableDictionary alloc] init];
        _currentTitle = [[NSMutableString alloc] init];
        _currentDate = [[NSMutableString alloc] init];
        _currentSummary = [[NSMutableString alloc] init];
        _currentLink = [[NSMutableString alloc] init];
        _currentImage = [[NSMutableString alloc] init];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{

    if ([elementName isEqualToString:@"item"])
    {
        // save values to an item, then store that item into the array
        [_item setObject:_currentTitle forKey:@"title"];
        [_item setObject:_currentLink forKey:@"link"];
        [_item setObject:_currentSummary forKey:@"summary"];
        [_item setObject:_currentDate forKey:@"date"];
        [_item setObject:_currentImage forKey:@"image"];
        
        [_allVideos addObject:_item];
        
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    // save the characters for the current item...
    if ([_currentElement isEqualToString:@"title"])
    {
        [_currentTitle appendString:string];
        
    }
    else if ([_currentElement isEqualToString:@"link"])
    {
        [_currentLink appendString:string];
        
    }
    else if ([_currentElement isEqualToString:@"description"])
    {
        [_currentSummary appendString:string];
        
    }
    else if ([_currentElement isEqualToString:@"pubDate"])
    {
        [_currentDate appendString:string];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    if ([self.delegate respondsToSelector:@selector(endingParsingWithSource:)])
    {
        NSArray *sortedArray = [self createSortedArray:[_allVideos mutableCopy]] ;
        
        [self.delegate endingParsingWithSource:[sortedArray mutableCopy]];
    }
}



@end
