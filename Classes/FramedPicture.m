//
//  FramedPicture.m
//  LayerFunFinal
//
//  Created by James Hillhouse on 1/27/11.
//  Copyright 2011 PortableFrontier. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


#import "FramedPicture.h"


static CGFloat		kMaxHeightWidth			= 200.0; // Defines maximum image height and width


@interface FramedPicture()

- (void)animateMasterView;
- (void)rotateViewsByAngle:(CGFloat)anAngle;
- (void)offSetView:(CGFloat)anOffset;
- (CGRect)resizeRectFromImage:(UIImage *)anImage inView:(UIView *)aView;

@end



@implementation FramedPicture


@synthesize masterView;
@synthesize pictureView;
@synthesize backgroundView;
@synthesize pictureImageView;
@synthesize pictureFrameView;
@synthesize pictureFrameImageView;

@synthesize perspectiveMultiple;
@synthesize pictureDistance;
@synthesize yOffset;



- (id)init 
{
    self = [super init];
    if (self) 
    {
        NSLog(@"Picture frame object instantiated.");
    }
    return self;
}



- (void)createFramedPictureWithImage:(UIImage *)aPictureImage 
				   pictureFrameImage:(UIImage *)aFrameImage 
{
	self.pictureImageView.image			= aPictureImage;
	self.pictureFrameImageView.image	= aFrameImage;
}



#pragma mark -
#pragma mark Animation Methods
- (void)animateMasterView
{
	CATransform3D perspective					= CATransform3DIdentity;
	perspective.m34								= -1.0 / ( 100.0 * self.perspectiveMultiple );
	
	[self.masterView.layer setSublayerTransform:perspective];
	
	CABasicAnimation *picture					= [CABasicAnimation animationWithKeyPath:@"sublayerTransform.rotation.y"];
	picture.fromValue							= [NSNumber numberWithFloat:0.0];
	picture.toValue								= [NSNumber numberWithFloat:M_PI * 2.0];
	picture.repeatCount							= HUGE_VAL;
	picture.duration							= 5.0;
	
	[self.masterView.layer addAnimation:picture forKey:@"sublayerTransform"];
	
	self.masterView.layer.zPosition				= 1.0;
	self.pictureView.layer.zPosition			= self.pictureDistance;
	self.backgroundView.layer.zPosition			= 0.0;
	
	self.pictureFrameView.layer.zPosition		= self.pictureDistance * 2.0;
}	



- (void)rotateViewsByAngle:(CGFloat)anAngle
{
	
	//
	// Give a pre-rotation of the picture 
	//
	
	// Rotate the picture views using implicit animation
	[UIView beginAnimations:@"Rotate Picture Views" context:NULL];	
	
	[UIView animateWithDuration:0.0 animations:^{
		CATransform3D pictureFrameTransform		= CATransform3DIdentity;
		pictureFrameTransform					= CATransform3DRotate(pictureFrameTransform, anAngle, 1.0, 0.0, 0.0);
		pictureFrameTransform					= CATransform3DScale(pictureFrameTransform, 1.0, 1.0, 1.0);
		
		self.backgroundView.layer.transform		= pictureFrameTransform;
		self.pictureView.layer.transform		= pictureFrameTransform;
		self.pictureFrameView.layer.transform	= pictureFrameTransform;		
	}];
	
	[UIView commitAnimations];	
}



- (void)offSetView:(CGFloat)anOffset
{
	[UIView beginAnimations:@"Translate Picture Views" context:NULL];
	
	[UIView animateWithDuration:0.0 animations:^{
		// Create transforms and apply them to multiple views
		[UIView setAnimationDuration:-0.1];
		CATransform3D pictureOffsetTransform	= pictureView.layer.transform;
		pictureOffsetTransform					= CATransform3DTranslate(pictureOffsetTransform, 0.0, -anOffset, anOffset);
		pictureFrameView.layer.transform		= pictureOffsetTransform;
		
		pictureOffsetTransform					= pictureView.layer.transform;
		pictureOffsetTransform					= CATransform3DTranslate(pictureOffsetTransform, 0.0, anOffset, -anOffset);
		backgroundView.layer.transform			= pictureOffsetTransform;
	}];
	
	[UIView commitAnimations];
}



- (CGRect)resizeRectFromImage:(UIImage *)anImage inView:(UIView *)aView
{
	CGRect imageRect;
	
	////////////////////////////////////////////////////
	//
	// Working with backgroundImageView and its subviews
	//
	////////////////////////////////////////////////////
	
	CGFloat imageResizedWidth;
	CGFloat imageResizedHeight;
	CGFloat imageScaleWidth					= kMaxHeightWidth / pictureImageView.image.size.width;
	CGFloat imageScaleHeight				= kMaxHeightWidth / pictureImageView.image.size.height;
	
	if (pictureImageView.image.size.width > pictureImageView.image.size.height) // Landscape
	{
		//		NSLog(@"Landscape");
		imageResizedWidth				= floorf(pictureImageView.image.size.width * imageScaleHeight);
		imageResizedHeight				= floorf(pictureImageView.image.size.height * imageScaleHeight);
	}
	else
	{
		//		NSLog(@"Portrait or square");
		imageResizedWidth				= floorf(pictureImageView.image.size.width * imageScaleWidth);
		imageResizedHeight				= floorf(pictureImageView.image.size.height * imageScaleWidth);
	}
	
	return imageRect					= CGRectMake(aView.frame.size.width / 2.0 - imageResizedWidth / 2.0, // origin.x
													 aView.frame.size.height / 2.0 - imageResizedHeight / 2.0, // origin.y
													 imageResizedWidth + 30.0, // width
													 imageResizedHeight + 30.0); // height
	
}


@end
