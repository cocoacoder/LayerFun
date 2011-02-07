//
//  LayerFunViewController.h
//  LayerFun
//
//  Created by Anonymous Apple Employee for Jim Hillhouse on 6/9/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LayerFunViewController3 : UIViewController 
{
	// ivars
	CGFloat perspectiveMultiple;
	CGFloat pictureDistance;
	
	IBOutlet UIView			*masterView;
	UIImage					*pictureImage;
	IBOutlet UIView			*pictureView;
	IBOutlet UIView			*backgroundView;
	IBOutlet UIImageView	*pictureImageView;
}

@property (nonatomic, retain)		IBOutlet		UILabel		*pageLabel;

- (void)animate;
- (CGRect)resizeRectFromImage:(UIImage *)anImage;

@end

