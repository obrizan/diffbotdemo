//
//  DiffbotService.m
//  DiffBotDemo
//
//  Created by Vladimir Obrizan on 02.01.14.
//  Copyright (c) 2014 Design and Test Lab. All rights reserved.
//

#import "DiffbotService.h"

@implementation DiffbotService
{
	/// Developer token.
	NSString *_token;
	
	NSURLConnection *_connection;
	NSMutableData *_data;
	
	ProductResponseBlock _productResponseBlock;
}


//==============================================================================


#pragma mark - Initializations.

+(instancetype)sharedService
{
	static dispatch_once_t once;
    static DiffbotService *sharedService;
    dispatch_once(&once, ^{ sharedService = [[self alloc] init]; });
    return sharedService;
}


//==============================================================================


+(void)setToken:(NSString *)tokenStr
{
	NSParameterAssert(tokenStr.length > 0);
	
	DiffbotService *service = [DiffbotService sharedService];
	service->_token = tokenStr;
}


//==============================================================================


#pragma mark - Public API.

+(void)getProductForURL:(NSURL *)url block:(void(^)(NSArray *products, NSError *error))block
{
	DiffbotService *service = [DiffbotService sharedService];
	[service getProductForURL:url block:block];
}


//==============================================================================


#pragma mark - Private API.

-(void)getProductForURL:(NSURL *)productURL block:(ProductResponseBlock)block
{
	NSAssert(_token, @"You should intialize DiffbotService with your API token first: [DiffbotService setToken:@\"Your API token\"]");
	NSParameterAssert(productURL);
	NSParameterAssert(block);
	
	_productResponseBlock = block;
	
	// An example of the product request:
	// http://api.diffbot.com/v2/product?token=af53252cb32735368bf65c1b03287324&url=http://store.artlebedev.com/toys/first-floor/kopilkus/
	NSString *urlString = [NSString stringWithFormat:@"http://api.diffbot.com/v2/product?token=%@&url=%@", _token, productURL.absoluteString];
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	_connection = [NSURLConnection connectionWithRequest:request delegate:self];
}


//==============================================================================


#pragma mark - NSURLDataConnectionDelegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
	if (response.statusCode >= 400)
	{
		NSError *error = [NSError errorWithDomain:@"Unexpected server response." code:response.statusCode userInfo:nil];
		_productResponseBlock(@[], error);
		
		[self connection:connection didFailWithError:error];
	}
	else
	{
		_data = [NSMutableData data];
	}
}


//==============================================================================


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[_data appendData:data];
}


//==============================================================================


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSError *error = nil;
	NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:_data options:0 error:&error];
	if (!error)
	{
		NSArray *products = dic[@"products"];
		_productResponseBlock(products, nil);
	}
	else
	{
		_productResponseBlock(@[], error);
	}
	
	_data = nil;
	_connection = nil;
	_productResponseBlock = nil;
}


//==============================================================================


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Notify about the error.
	_productResponseBlock(@[], error);

	// Release the resources.
	[_connection cancel];
	_connection = nil;
	_data = nil;
	_productResponseBlock = nil;
}


//==============================================================================

@end
