//
//  LayerFunViewController.m
//  LayerFun
//
//  Created by Anonymous Apple Employee for Jim Hillhouse on 6/9/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "LayerFunViewController4.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


static CGFloat		kMaxHeightWidth			= 200.0; // Defines maximum image height



@implementation LayerFunViewController4


@synthesize pageLabel;
@synthesize perspectiveMultiple;
@synthesize perspectiveSlider;

@synthesize pictureDistance;
@synthesize yOffSet;
@synthesize pictureDistanceSlider;


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//
	// Set variables
	//
	self.pictureDistance					= 10.0;
	self.perspectiveMultiple				= 10.0;
	
	
	//
	// Set images
	//
	pictureImage							= [UIImage imageNamed:@"Steve"];
	pictureFrameImageView.image				= [UIImage imageNamed:@"boys_frame"];
	
	
	//
	// Resize the picture CGRect
	//
	CGRect pictureRect						= [self resizeRectFromImage:pictureImage];
		
	
	//
	// Now set the pictureImageView image to the UIImage
	//
	pictureImageView.image					= pictureImage;
	
	
	//
	// Now set the layer hierarchy
	//
	self.pageLabel.layer.zPosition			= 50.0;
	masterView.layer.zPosition				= 1.0;
	pictureView.layer.zPosition				= self.pictureDistance;
	backgroundView.layer.zPosition			= 0.0;
	
	pictureFrameView.layer.zPosition		= self.pictureDistance + 10.0;

	
	//
	// Adjust the backgroundView
	//
	masterView.frame						= pictureRect;
	masterView.center						= CGPointMake(160.0, 170.0);
	
	
	//
	// pictureImageView is the view containing the image view of the person being flushed
	//
	pictureView.frame						= CGRectMake(20.0, 20.0, pictureRect.size.width - 40.0, pictureRect.size.height - 40.0);
	pictureView.layer.shadowOpacity			= 0.5;
	pictureView.layer.shadowOffset			= CGSizeMake(5.0, 10.0);
	pictureView.layer.shadowRadius			= 15.0;
	pictureView.layer.shouldRasterize		= YES;		
	
	//
	// Set the backgroundView to its size
	//
	backgroundView.frame					= CGRectMake(0.0, 0.0, pictureRect.size.width, pictureRect.size.height);
	backgroundView.layer.shadowOpacity		= 0.5;
	backgroundView.layer.shadowOffset		= CGSizeMake(2.5, 5.0);
	backgroundView.layer.shadowRadius		= 7.0;
	backgroundView.layer.shouldRasterize	= YES;		
	
	
	//
	// Set the pictureFrameView
	//
	pictureFrameView.frame					= CGRectMake(-10.0, -10.0, pictureRect.size.width + 20.0, pictureRect.size.height + 20.0);
	pictureFrameView.layer.shadowOpacity	= 0.5;
	pictureFrameView.layer.shadowOffset		= CGSizeMake(5.0, 10.0);
	pictureFrameView.layer.shadowRadius		= 15.0;
	pictureFrameView.layer.shouldRasterize	= YES;
}



- (void)dealloc 
{
	[pageLabel release];
	[perspectiveSlider release];
	[pictureDistanceSlider release];
	
    [super dealloc];
}



- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:YES];
	
	[self animateMasterView];
}



#pragma mark -
#pragma mark Animation Methods
- (void)animateMasterView
{
	CATransform3D perspective				= CATransform3DIdentity;
	perspective.m34							= -1.0 / ( 100.0 * self.perspectiveMultiple );
	
	[masterView.layer setSublayerTransform:perspective];
	
	CABasicAnimation *picture				= [CABasicAnimation animationWithKeyPath:@"sublayerTransform.rotation.y"];
	picture.fromValue						= [NSNumber numberWithFloat:0.0];
	picture.toValue							= [NSNumber numberWithFloat:M_PI * 2.0];
	picture.repeatCount						= HUGE_VAL;
	picture.duration						= 5.0;
	
	[masterView.layer addAnimation:picture forKey:@"sublayerTransform"];
	
	masterView.layer.zPosition				= 1.0;
	pictureView.layer.zPosition				= self.pictureDistance;
	backgroundView.layer.zPosition			= 0.0;
	
	pictureFrameView.layer.zPosition		= self.pictureDistance * 2.0;
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
	CGFloat imageScaleWidth					= kMaxHeightWidth / pictureImage.size.width;
	CGFloat imageScaleHeight				= kMaxHeightWidth / pictureImage.size.height;
	
	if (pictureImage.size.width > pictureImage.size.height) // Landscape
	{
		//		NSLog(@"Landscape");
		imageResizedWidth					= floorf(pictureImage.size.width * imageScaleHeight);
		imageResizedHeight					= floorf(pictureImage.size.height * imageScaleHeight);
	}
	else // Portrait or Square
	{
		//		NSLog(@"Portrait");
		imageResizedWidth					= floorf(pictureImage.size.width * imageScaleWidth);
		imageResizedHeight					= floorf(pictureImage.size.height * imageScaleWidth);
	}	
	
	return imageRect						= CGRectMake(self.view.frame.size.width / 2.0 - imageResizedWidth / 2.0, // origin.x
														 self.view.frame.size.height / 2.0 - imageResizedHeight / 2.0, // origin.y
														 imageResizedWidth + 30.0, // width
														 imageResizedHeight + 30.0); // height
	
}



#pragma mark -
#pragma mark IBAction Methods for Setting Perspecive & View Distances
- (IBAction)perspectiveMultipleSetting
{
	self.perspectiveMultiple				= (CGFloat)self.perspectiveSlider.value;
	[self animateMasterView];
}



- (IBAction)pictureDistanceSetting
{
	self.pictureDistance					= (CGFloat)self.pictureDistanceSlider.value;
	[self animateMasterView];
}



@end
