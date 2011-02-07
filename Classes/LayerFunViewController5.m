//
//  LayerFunViewController.m
//  LayerFun
//
//  Created by James Hillhouse on 1/15/11.
//  Copyright 2011 PortableFrontier. All rights reserved.
//

#import "LayerFunViewController5.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


static CGFloat		kMaxHeightWidth			= 150.0; // Defines maximum image height and width


//
// LayerFunViewController5 Class Extension
//
@interface LayerFunViewController5 ()
- (void)animateMasterView;
- (CGRect)resizeRectFromImage:(UIImage *)anImage;
- (void)rotateViewsByAngle:(CGFloat)anAngle;
- (void)offSetView:(CGFloat)anOffset;

@end



@implementation LayerFunViewController5


@synthesize pageLabel;

@synthesize perspectiveSlider;
@synthesize pictureDistanceSlider;
@synthesize rotationAngleSlider;

@synthesize masterView;
@synthesize pictureView;
@synthesize backgroundView;
@synthesize pictureImageView;
@synthesize pictureFrameView;
@synthesize pictureFrameImageView;

@synthesize perspectiveMultiple;



- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//
	// Set variables
	//
	//
	// Resize the picture CGRect
	//
	self.pictureImageView.image					= [UIImage imageNamed:@"Steve"];
	CGRect pictureRect							= [self resizeRectFromImage:pictureImageView.image];
	
	
	//
	// Now set the layer hierarchy
	//
	self.pageLabel.layer.zPosition				= 50.0;
	self.masterView.layer.zPosition				= 1.0;
	self.pictureView.layer.zPosition			= (CGFloat)self.pictureDistanceSlider.value;
	self.backgroundView.layer.zPosition			= 0.0;
	self.pictureFrameView.layer.zPosition		= (CGFloat)self.pictureDistanceSlider.value + 10.0;

	
	//
	// Adjust the backgroundView
	//
	self.masterView.frame						= pictureRect;
	self.masterView.center						= CGPointMake(160.0, 150.0);
	
	
	//
	// pictureImageView is the view containing the image view of the person being flushed
	//
	self.pictureView.frame						= CGRectMake(20.0, 20.0, pictureRect.size.width - 40.0, pictureRect.size.height - 40.0);
	self.pictureView.layer.shadowOpacity		= 0.5;
	self.pictureView.layer.shadowOffset			= CGSizeMake(5.0, 10.0);
	self.pictureView.layer.shadowRadius			= 15.0;
	self.pictureView.layer.shouldRasterize		= YES;		
	
	//
	// Set the backgroundView to its size
	//
	self.backgroundView.frame					= CGRectMake(0.0, 0.0, pictureRect.size.width, pictureRect.size.height);
	self.backgroundView.layer.shadowOpacity		= 0.5;
	self.backgroundView.layer.shadowOffset		= CGSizeMake(2.5, 5.0);
	self.backgroundView.layer.shadowRadius		= 7.0;
	self.backgroundView.layer.shouldRasterize	= YES;		
	
	
	//
	// Set the pictureFrameView
	//
	self.pictureFrameView.frame					= CGRectMake(-10.0, -10.0, pictureRect.size.width + 20.0, pictureRect.size.height + 20.0);
	self.pictureFrameView.layer.shadowOpacity	= 0.5;
	self.pictureFrameView.layer.shadowOffset	= CGSizeMake(5.0, 10.0);
	self.pictureFrameView.layer.shadowRadius	= 15.0;
	self.pictureFrameView.layer.shouldRasterize	= YES;
}



- (void)dealloc 
{
	[pageLabel release];
	[perspectiveSlider release];
	[pictureDistanceSlider release];
	[rotationAngleSlider release];
	
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
	perspective.m34							= -1.0 / ( 100.0 * self.perspectiveSlider.value );
	
	[masterView.layer setSublayerTransform:perspective];
	
	CABasicAnimation *picture				= [CABasicAnimation animationWithKeyPath:@"sublayerTransform.rotation.y"];
	picture.fromValue						= [NSNumber numberWithFloat:0.0];
	picture.toValue							= [NSNumber numberWithFloat:M_PI * 2.0];
	picture.repeatCount						= HUGE_VAL;
	picture.duration						= 5.0;
	
	[self.masterView.layer addAnimation:picture forKey:@"sublayerTransform"];
	
	self.masterView.layer.zPosition			= 1.0;
	self.pictureView.layer.zPosition		= self.pictureDistanceSlider.value;
	self.backgroundView.layer.zPosition		= 0.0;
	
	self.pictureFrameView.layer.zPosition	= self.pictureDistanceSlider.value * 2.0;
}	



- (void)rotateViewsByAngle:(CGFloat)anAngle
{
	
	//
	// Give a pre-rotation of the picture 
	//
	
	// Rotate the picture views using implicit animation
	[UIView animateWithDuration:0.0 animations:^{
		CATransform3D pictureFrameTransform		= CATransform3DIdentity;
		pictureFrameTransform					= CATransform3DRotate(pictureFrameTransform, anAngle, 1.0, 0.0, 0.0);
		pictureFrameTransform					= CATransform3DScale(pictureFrameTransform, 1.0, 1.0, 1.0);
		
		self.backgroundView.layer.transform		= pictureFrameTransform;
		self.pictureView.layer.transform		= pictureFrameTransform;
		self.pictureFrameView.layer.transform	= pictureFrameTransform;		
	}];
}



- (void)offSetView:(CGFloat)anOffset
{
	[UIView animateWithDuration:0.0 animations:^{
		// Create transforms and apply them to multiple views
		[UIView setAnimationDuration:-0.1];
		CATransform3D pictureOffsetTransform	= self.pictureView.layer.transform;
		pictureOffsetTransform					= CATransform3DTranslate(pictureOffsetTransform, 0.0, -anOffset, anOffset);
		self.pictureFrameView.layer.transform	= pictureOffsetTransform;
		
		pictureOffsetTransform					= self.pictureView.layer.transform;
		pictureOffsetTransform					= CATransform3DTranslate(pictureOffsetTransform, 0.0, anOffset, -anOffset);
		self.backgroundView.layer.transform		= pictureOffsetTransform;
	}];
}



#pragma mark -
#pragma mark Other Methods

- (CGRect)resizeRectFromImage:(UIImage *)anImage
{
	CGRect imageRect;
	
	////////////////////////////////////////////////////
	//
	// Working with backgroundImageView and its subviews
	//
	////////////////////////////////////////////////////
	
	CGFloat imageResizedWidth;
	CGFloat imageResizedHeight;
	CGFloat imageScaleWidth				= kMaxHeightWidth / anImage.size.width;
	CGFloat imageScaleHeight			= kMaxHeightWidth / anImage.size.height;
	
	if (anImage.size.width > anImage.size.height) // Landscape
	{
		// NSLog(@"Landscape");
		imageResizedWidth				= floorf( anImage.size.width * imageScaleHeight );
		imageResizedHeight				= floorf( anImage.size.height * imageScaleHeight );
	}
	else // Portrait or Square
	{
		// NSLog(@"Portrait");
		imageResizedWidth				= floorf( anImage.size.width * imageScaleWidth );
		imageResizedHeight				= floorf( anImage.size.height * imageScaleWidth );
	}
	
	return imageRect					= CGRectMake( self.view.frame.size.width / 2.0 - imageResizedWidth / 2.0, // origin.x
													 self.view.frame.size.height / 2.0 - imageResizedHeight / 2.0, // origin.y
													 imageResizedWidth + 30.0, // width
													 imageResizedHeight + 30.0 ); // height
	
}



#pragma mark -
#pragma mark IBAction Methods for Setting Perspecive & View Distances
- (IBAction)perspectiveMultipleSetting
{
	self.perspectiveMultiple			= (CGFloat)self.perspectiveSlider.value;
	[self animateMasterView];
}



- (IBAction)pictureDistanceSetting
{
	[self offSetView:( CGFloat ) ( self.pictureDistanceSlider.value * sin( self.rotationAngleSlider.value * M_PI ))];
	[self animateMasterView];
}



- (IBAction)rotatePictureSetting
{
	[self rotateViewsByAngle:( CGFloat )self.rotationAngleSlider.value * M_PI];
	
	[self offSetView:( CGFloat )( self.pictureDistanceSlider.value * sin( self.rotationAngleSlider.value * M_PI ))];
	[self animateMasterView];
}



@end
