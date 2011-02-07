//
//  LayerFunViewController.h
//  LayerFun
//
//  Created by Anonymous Apple Employee for Jim Hillhouse on 6/9/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LayerFunViewController4 : UIViewController 
{
	// ivars
	CGFloat perspectiveMultiple;
	UISlider *perspectiveSlider;
	
	CGFloat pictureDistance;
	CGFloat yOffset;
	UISlider *pictureDistanceSlider;
	
	
	IBOutlet UIView			*masterView;
	UIImage					*pictureImage;
	IBOutlet UIView			*pictureView;
	IBOutlet UIView			*backgroundView;
	IBOutlet UIImageView	*pictureImageView;
	IBOutlet UIView			*pictureFrameView;
	IBOutlet UIImageView	*pictureFrameImageView;
}


@property (nonatomic, retain)	IBOutlet	UILabel		*pageLabel;

@property						IBOutlet	CGFloat		perspectiveMultiple;
@property (nonatomic, retain)	IBOutlet	UISlider	*perspectiveSlider;

@property						IBOutlet	CGFloat		pictureDistance;
@property						IBOutlet	CGFloat		yOffSet;
@property (nonatomic, retain)	IBOutlet	UISlider	*pictureDistanceSlider;


- (void)animateMasterView;
- (CGRect)resizeRectFromImage:(UIImage *)anImage;
- (IBAction)perspectiveMultipleSetting;
- (IBAction)pictureDistanceSetting;

@end

