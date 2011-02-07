//
//  LayerFunViewController.m
//  LayerFun
//
//  Created by Anonymous Apple Employee for Jim Hillhouse on 6/9/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "LayerFunViewController2.h"
#import <QuartzCore/QuartzCore.h>


static CGFloat		kMaxHeightWidth		= 200.0; // Defines maximum image height



@implementation LayerFunViewController2

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	pictureImage						= [UIImage imageNamed:@"Steve"];
	
	//	NSLog(@"backgroundView.frame is assigned with size = (%f, %f, %f, %f )", imageRect.origin.x, imageRect.origin.y, imageRect.size.width, imageRect.size.height);
		
	
	//
	// Now set the pictureImageView image to the UIImage
	//
	pictureImageView.image				= pictureImage;

	//
	// Determine the proper rect from the image. 
	//
	CGRect pictureRect					= [self resizeRectFromImage:pictureImage];
	
	
	//
	// Adjust the backgroundView
	//
	masterView.frame					= pictureRect;
	masterView.center					= CGPointMake(160.0, 240.0);
		
	
	//
	// Set the backgroundView to its size
	//
	backgroundView.frame				= CGRectMake(0.0, 0.0, pictureRect.size.width, pictureRect.size.height);
	
	
	//
	// pictureImageView is the view containing the image view of the person being flushed
	//
	pictureView.frame					= CGRectMake(15, 15, pictureRect.size.width - 30.0, pictureRect.size.height - 30.0);
	
}



- (void)dealloc 
{
    [super dealloc];
}



- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:YES];
	
	[self animate];
}



#pragma mark -
#pragma mark Animation Methods
- (void)animate
{
	CABasicAnimation *picture			= [CABasicAnimation animationWithKeyPath:@"sublayerTransform.rotation.y"];
	picture.fromValue					= [NSNumber numberWithFloat:0.0];
	picture.toValue						= [NSNumber numberWithFloat:M_PI * 2.0];
	picture.repeatCount					= HUGE_VAL;
	picture.duration					= 5.0;
	
	[masterView.layer addAnimation:picture forKey:@"sublayerTransform"];
	
	masterView.layer.zPosition			= 0.0;
	pictureView.layer.zPosition			= 10.0;
	backgroundView.layer.zPosition		= 0.0;
	
}



#pragma mark -
#pragma mark Other Methods

- (CGRect)resizeRectFromImage:(UIImage *)anImage
{
	CGRect imageRect;
	
	////////////////////////////////////////////////
	//
	// Working with backgroundImageView and its subviews
	//
	////////////////////////////////////////////////
	
	CGFloat imageResizedWidth;
	CGFloat imageResizedHeight;
	CGFloat imageScaleWidth				= kMaxHeightWidth / pictureImage.size.width;
	CGFloat imageScaleHeight			= kMaxHeightWidth / pictureImage.size.height;
	
	if (pictureImage.size.width > pictureImage.size.height) // Landscape
	{
		//		NSLog(@"Landscape");
		imageResizedWidth				= floorf(pictureImage.size.width * imageScaleHeight);
		imageResizedHeight				= floorf(pictureImage.size.height * imageScaleHeight);
	}
	else // Portrait or Square
	{
		//		NSLog(@"Portrait");
		imageResizedWidth				= floorf(pictureImage.size.width * imageScaleWidth);
		imageResizedHeight				= floorf(pictureImage.size.height * imageScaleWidth);
	}
	
	return imageRect					= CGRectMake(self.view.frame.size.width / 2.0 - imageResizedWidth / 2.0, // origin.x
													 self.view.frame.size.height / 2.0 - imageResizedHeight / 2.0, // origin.y
													 imageResizedWidth + 30.0, // width
													 imageResizedHeight + 30.0); // height
	
}



@end
