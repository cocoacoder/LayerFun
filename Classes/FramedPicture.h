//
//  FramedPicture.h
//  LayerFunFinal
//
//  Created by James Hillhouse on 1/27/11.
//  Copyright 2011 PortableFrontier. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FramedPicture : NSObject 
{
	UIView				*masterView;
	UIView				*pictureView;
	UIView				*backgroundView;
	UIImageView			*pictureImageView;
	UIView				*pictureFrameView;
	UIImageView			*pictureFrameImageView;	
	
	CGFloat				perspectiveMultiple;
	CGFloat				pictureDistance;
	CGFloat				yOffset;
	
}

@property (nonatomic, retain)		UIView			*masterView;
@property (nonatomic, retain)		UIView			*pictureView;
@property (nonatomic, retain)		UIView			*backgroundView;
@property (nonatomic, retain)		UIImageView		*pictureImageView;
@property (nonatomic, retain)		UIView			*pictureFrameView;
@property (nonatomic, retain)		UIImageView		*pictureFrameImageView;

@property							CGFloat			perspectiveMultiple;
@property							CGFloat			pictureDistance;
@property							CGFloat			yOffset;


- (void)createFramedPictureWithImage:(UIImage *)aPictureImage pictureFrameImage:(UIImage *)aFrameImage;

@end
