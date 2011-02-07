//
//  LayerFunViewController.h
//  LayerFun
//
//  Created by James Hillhouse on 1/15/11.
//  Copyright 2011 PortableFrontier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LayerFunViewController5 : UIViewController 
{
	// Controllers
	UISlider				*perspectiveSlider;	
	UISlider				*pictureDistanceSlider;
	UISlider				*rotationAngleSlider;
	
	// View Hierarchy
	UILabel					*pageLabel;
	UIView					*masterView;
	UIView					*pictureView;
	UIView					*backgroundView;
	UIImageView				*pictureImageView;
	UIView					*pictureFrameView;
	UIImageView				*pictureFrameImageView;
	
	CGFloat					perspectiveMultiple;
}

@property (nonatomic, retain)	IBOutlet	UILabel			*pageLabel;

@property (nonatomic, retain)	IBOutlet	UISlider		*perspectiveSlider;
@property (nonatomic, retain)	IBOutlet	UISlider		*pictureDistanceSlider;
@property (nonatomic, retain)	IBOutlet	UISlider		*rotationAngleSlider;

@property (nonatomic, retain)	IBOutlet	UIView			*masterView;
@property (nonatomic, retain)	IBOutlet	UIView			*pictureView;
@property (nonatomic, retain)	IBOutlet	UIView			*backgroundView;
@property (nonatomic, retain)	IBOutlet	UIImageView		*pictureImageView;
@property (nonatomic, retain)	IBOutlet	UIView			*pictureFrameView;
@property (nonatomic, retain)	IBOutlet	UIImageView		*pictureFrameImageView;

@property									CGFloat			perspectiveMultiple;


- (IBAction)perspectiveMultipleSetting;
- (IBAction)pictureDistanceSetting;
- (IBAction)rotatePictureSetting;

@end

