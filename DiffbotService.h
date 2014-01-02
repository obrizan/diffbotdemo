//
//  DiffbotService.h
//  DiffBotDemo
//
//  Created by Vladimir Obrizan on 02.01.14.
//  Copyright (c) 2014 Design and Test Lab. All rights reserved.
//

#import <Foundation/Foundation.h>


/** A block which handles the product response.
 * @param	products	An array of products (NSDictionary).
 * @param	error		An error. It is nil if the request succeeded.
 */
typedef void(^ProductResponseBlock)(NSArray *products, NSError *error);


/** DiffbotService is a facade class to interact with all Diffbot services. It is a singleton object.
 * 
 * The service requires a develpment token to operate. Go to http://www.diffbot.com/pricing/ to get your own development token.
 */
@interface DiffbotService : NSObject<NSURLConnectionDataDelegate>


/**    =========================================================================
 @name Initializations
 *     =======================================================================*/


/** Returns a shared instance of Diffbot.
 */
+(instancetype)sharedService;


/** Sets the developer token.
 * @param	tokenStr	A developer token. It can't be an empty string.
 * @discussion You must set the token before calling any API method. Go to http://www.diffbot.com/pricing/ to get your own development token.
 * @exception NSInternalInconsistencyException Thrown when length of the token is zero.
 */
+(void)setToken:(NSString *)tokenStr;


/**    =========================================================================
 @name Public API
 *     =======================================================================*/


/** The Product API returns product details in the products array. Currently extracted data will only be returned from a single product. It is an asynchronous method.
 *
 * @param	productURL		Product URL to process (URL encoded). It can't be nil.
 * @param	block	The block which is called when the request is completed. It can't be nil.
 *
 * @return It returns nothing immediatelly. The block will be invoked when the response is arrived.
 * @exception NSInternalInconsistencyException Thrown when the productURL is nil, or the block is nil.
 */
+(void)getProductForURL:(NSURL *)productURL block:(ProductResponseBlock)block;


@end
