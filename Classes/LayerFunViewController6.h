//
//  LayFunViewController6.h
//  LayerFunFinal
//
//  Created by James Hillhouse on 2/1/11.
//  Copyright 2011 PortableFrontier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//#import <CoreGraphics/CoreGraphics.h>
//#import <CoreVideo/CoreVideo.h>
//#import <CoreMedia/CoreMedia.h>


#define INITIAL_ROTATION    0.0
#define INITIAL_TILT        0.0


//
// Some say that we shouldn't use properties save to expose state items of an instance of a class...c'est la vive.
// I like properties because of dot syntax.
//


@interface LayerFunViewController6 : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate, UIGestureRecognizerDelegate>
{
	// LayerFun UI Controls
	UISlider				*perspectiveSlider;	
	UISlider				*pictureDistanceSlider;
	UISlider				*rotationAngleSlider;
	
	// LayerFun View Hierarchy
	UILabel					*pageLabel;
	UIView					*masterView;
	UIView					*pictureView;
	UIView					*backgroundView;
	UIImageView				*pictureImageView;
	UIView					*pictureFrameView;
	UIImageView				*pictureFrameImageView;
	
	CGFloat					perspectiveMultiple;
	
	// LayerFun Screenshot ivars
	AVCaptureSession		*capturedSession;
	
	BOOL					scanning;
	// Views
	UIView					*captureView;
	UIImageView				*captureImageView;
	UIView					*overlayView;
	UIImageView				*scannedImage;
	// Buttons
	UIButton				*scanButton;
	UIButton				*cameraButton;
	
    // Rotation, Tilt, and Spacing
    CGFloat                 translationY;
    CGFloat                 tilt;
    CGFloat                 tiltIncrement;
    CGFloat                 translationX;
    CGFloat                 rotation;
    CGFloat                 rotationIncrement;
    CGFloat                 angle;
    CGFloat                 zoom;
    CGFloat                 zoomIncrement;
    CGFloat                 angleIncrement;
    CGFloat                 tiltDampener;
}


// LayerFun UI Properties
@property (nonatomic, retain)		IBOutlet		UILabel                 *pageLabel;

@property (nonatomic, retain)		IBOutlet		UISlider                *perspectiveSlider;
@property (nonatomic, retain)		IBOutlet		UISlider                *pictureDistanceSlider;
@property (nonatomic, retain)		IBOutlet		UISlider                *rotationAngleSlider;

@property (nonatomic, retain)		IBOutlet		UIView                  *masterView;
@property (nonatomic, retain)		IBOutlet		UIView                  *pictureView;
@property (nonatomic, retain)		IBOutlet		UIView                  *backgroundView;
@property (nonatomic, retain)		IBOutlet		UIImageView             *pictureImageView;
@property (nonatomic, retain)		IBOutlet		UIView                  *pictureFrameView;
@property (nonatomic, retain)		IBOutlet		UIImageView             *pictureFrameImageView;

@property											CGFloat                 perspectiveMultiple;

// LayerFun Screenshot Properties
@property (nonatomic, retain)						AVCaptureSession        *capturedSession;

@property											BOOL                    scanning;

@property (nonatomic, retain)		IBOutlet		UIView                  *captureView;
@property (nonatomic, retain)		IBOutlet		UIImageView             *captureImageView;
@property (nonatomic, retain)		IBOutlet		UIView                  *overlayView;
@property (nonatomic, retain)						UIImageView             *scannedImage;

@property (nonatomic, retain)		IBOutlet		UIButton                *scanButton;
@property (nonatomic, retain)		IBOutlet		UIButton                *cameraButton;

// Rotation, Tilt, and Spacing
@property                                           CGFloat                 translationY;
@property                                           CGFloat                 tilt;
@property                                           CGFloat                 tiltIncrement;
@property                                           CGFloat                 translationX;
@property                                           CGFloat                 rotation;
@property                                           CGFloat                 rotationIncrement;
@property                                           CGFloat                 angle;
@property                                           CGFloat                 zoom;
@property                                           CGFloat                 zoomIncrement;
@property                                           CGFloat                 angleIncrement;
@property                                           CGFloat                 tiltDampener;
@property (nonatomic, retain)                       UITapGestureRecognizer  *tapRecognizer;
@property (nonatomic, retain)                       UIPanGestureRecognizer  *panRecognizer;
@property (nonatomic, retain)                       UIPinchGestureRecognizer *pinchRecognizer;


// LayerFun UI Methods
- (IBAction)perspectiveMultipleSetting;
- (IBAction)pictureDistanceSetting;
- (IBAction)rotatePictureSetting;

// LayerFun Screenshot Methods
- (IBAction)setupCamera;
- (IBAction)scan;


@end

