//
//  ViewController.m
//  DiffBotDemo
//
//  Created by Vladimir Obrizan on 02.01.14.
//  Copyright (c) 2014 Design and Test Lab. All rights reserved.
//

#import "ViewController.h"

#import "DiffbotService.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet UITextField *URLText;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end

@implementation ViewController


//==============================================================================


- (IBAction)getProductClicked:(id)sender
{
	[self.URLText resignFirstResponder];
	[self.activity startAnimating];
	
	NSURL *URL = [NSURL URLWithString:self.URLText.text];
	
	// Call Diffbot.
	[DiffbotService getProductForURL:URL block:^(NSArray *products, NSError *error)
	{
		[self.activity stopAnimating];
		
		if (error)
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
			[alert show];
			return;
		}
		
		NSDictionary *product = products[0];
		
		self.titleLabel.text = product[@"title"];
		self.priceLabel.text = product[@"offerPrice"];
		self.descriptionText.text = product[@"description"];
	}];
}


//==============================================================================

@end
