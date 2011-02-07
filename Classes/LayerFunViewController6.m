//
//  LayFunViewController6.m
//  LayerFunFinal
//
//  Created by James Hillhouse on 2/1/11.
//  Copyright 2011 PortableFrontier. All rights reserved.
//

#import "LayerFunViewController6.h"

#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>




static CGFloat		kMaxHeightWidth			= 150.0; // Defines maximum image height and width


//
// LayerFunViewController6 Class Extension
//
@interface LayerFunViewController6 ()

// LayerFun UI Methods
- (void)animateMasterViewToInitial;
- (void)transformMasterView;
- (CGRect)resizeRectFromImage:(UIImage *)anImage;
- (void)rotateViewsByAngle:(CGFloat)anAngle;
- (void)offSetView:(CGFloat)anOffset;

// LayerFun Screenshot Methods
- (void)setupCaptureSession;
- (void)renderView:(UIView*)view inContext:(CGContextRef)context;
- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;
- (void)cameraOn;
- (void)cameraOff;

// Gesture Methods
- (void)createGestureRecognizers;
- (void)handleTapFromGestureRecognizer:(UITapGestureRecognizer *)recognizer;
- (void)handleRotateAndTiltFromGestureRecognizer:(UIPanGestureRecognizer *)recognizer;

@end




@implementation LayerFunViewController6


// LayerFun UI Properties
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

// LayerFun Screenshot Properties
@synthesize capturedSession;

@synthesize scanning;

@synthesize captureView;
@synthesize captureImageView;
@synthesize overlayView;
@synthesize scannedImage;

@synthesize scanButton;
@synthesize cameraButton;

// Rotation, Tilt, and Spacing
@synthesize translationY;
@synthesize tilt;
@synthesize tiltIncrement;
@synthesize translationX;
@synthesize rotation;
@synthesize rotationIncrement;
@synthesize angle;
@synthesize zoom;
@synthesize zoomIncrement;
@synthesize angleIncrement;
@synthesize tiltDampener;
@synthesize tapRecognizer;
@synthesize panRecognizer;
@synthesize pinchRecognizer;



// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/



# pragma mark -
#pragma mark UIView Methods

- (void)dealloc 
{
	// Release LayerFun UI Elements
	[pageLabel release];
	
	[perspectiveSlider release];
	[pictureDistanceSlider release];
	[rotationAngleSlider release];
	
	[masterView release];
	[pictureView release];
	[backgroundView release];
	[pictureImageView release];
	[pictureFrameView release];
	[pictureFrameImageView release];
	
	
	// Release LayerFun Screenshot Elements
	[capturedSession release];

	[captureView release];
	[captureImageView release];
	[overlayView release];
	[scannedImage release];
	
	[scanButton release];
	[cameraButton release];
    
    [tapRecognizer release];
    [panRecognizer release];
    [pinchRecognizer release];
	
	
    [super dealloc];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	self.translationX                           = 0.001;
    self.translationY                           = 0.001;
    self.angle                                  = INITIAL_ROTATION;
    self.angleIncrement                         = 0.0;
	
	//////////////////////////////////////////////////////////////////////
	//																	//	
	//	SETUP THE UI													//
	//																	//	
	//////////////////////////////////////////////////////////////////////
	//	
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
	
	
	
	//////////////////////////////////////////////////////////////////////
	//																	//	
	// SETUP THE CAMERA													//
	//																	//	
	//////////////////////////////////////////////////////////////////////
	//
	//
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
	
	
	//
	// Set the zPostion for the capture view and the overlay view
	//
	self.captureView.layer.zPosition			= (CGFloat)self.pictureDistanceSlider.value + 1.0;
	self.overlayView.layer.zPosition			= (CGFloat)self.pictureDistanceSlider.value + 1.0;
	
	
	//
	// Position & Hide the capture view, which holds the AVCaptureView preview.
	//
	self.captureView.frame						= CGRectMake(20.0, 20.0, pictureRect.size.width - 40.0, pictureRect.size.height - 40.0);
	self.captureImageView.layer.opacity			= 1.0;
	
	
	//
	// Position & Hide the overlayerView, which I'm including for demo's sake.
	//
	self.overlayView.frame						= CGRectMake(20.0, 20.0, pictureRect.size.width - 40.0, pictureRect.size.height - 40.0);
	self.overlayView.layer.opacity				= 0.0;
	
	self.scanning								= NO;
	self.cameraButton.selected					= NO;
	self.cameraButton.center					= CGPointMake(160.0, 340.0);
	
	self.scanButton.selected					= NO;
	//self.scanButton.hidden						= YES;
	self.scanButton.center						= CGPointMake(160.0, 340.0);
	
	//
	// These UIButton calls set up the custom button to change its appearance when selected/not selected.
	//
	[self.scanButton setTitle:@"Stop" forState:UIControlStateSelected];
	[self.scanButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
	
	[self.scanButton setTitle:@"Scan" forState:UIControlStateNormal];
	[self.scanButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];	
	
	//
	// These UIButton calls set up the custom button to change its appearance when selected/not selected.
	//
	[self.cameraButton setTitle:@"Cancel" forState:UIControlStateSelected];
	[self.cameraButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
	
	[self.cameraButton setTitle:@"Camera" forState:UIControlStateNormal];
	[self.cameraButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	
    //
    // Create the Gesture Recognizers
    //
    [self createGestureRecognizers];
    self.rotation                               = 0.001;
    self.tilt                                   = 0.001;
    
    [self animateMasterViewToInitial];
}



- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:YES];
	
//	[self animateMasterView];
}



- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:YES];
	
	[self.capturedSession stopRunning];
	self.scanButton.selected				= NO;
	self.cameraButton.selected				= YES;	
	
}



- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	self.masterView							= nil;
	self.backgroundView						= nil;
	self.pictureView						= nil;
	self.pictureImageView					= nil;
	self.pictureFrameView					= nil;
	self.pictureFrameImageView				= nil;
	
	self.overlayView						= nil;
	self.captureView						= nil;
}



- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}



#pragma mark -
#pragma mark Animation Methods

- (void)animateMasterViewToInitial
{
    self.rotation                           = 0.0;
    self.tilt                               = 0.0;
    
	CATransform3D perspective				= CATransform3DIdentity;
	perspective.m34							= -1.0 / ( 100.0 * self.perspectiveSlider.value );
	
	[masterView.layer setSublayerTransform:perspective];
	
	CABasicAnimation *picture				= [CABasicAnimation animationWithKeyPath:@"sublayerTransform.rotation.y"];
    picture.fromValue                       = [NSNumber numberWithFloat:self.rotation];
    picture.toValue                         = [NSNumber numberWithFloat:0.0];
	picture.duration						= 1.75;
    picture.removedOnCompletion             = NO;
	
	[self.masterView.layer addAnimation:picture forKey:@"sublayerTransform"];
	
	self.masterView.layer.zPosition			= 1.0;
	self.pictureView.layer.zPosition		= self.pictureDistanceSlider.value;
	self.captureView.layer.zPosition		= self.pictureDistanceSlider.value + 1.0;
	self.overlayView.layer.zPosition		= self.pictureDistanceSlider.value + 1.0;
	self.backgroundView.layer.zPosition		= 0.0;
	self.pictureFrameView.layer.zPosition	= self.pictureDistanceSlider.value * 2.0;
}



- (void)transformMasterView
{
    self.rotation                           = self.rotation + self.rotationIncrement;
//    NSLog(@"rotation = %f", self.rotation);
    if ( ( self.tilt + self.tiltIncrement ) < M_PI_2 && ( self.tilt + self.tiltIncrement ) > -M_PI_2 ) 
    {
        self.tilt                           = self.tilt + self.tiltIncrement;
        
    }
    NSLog(@"tilt = %f\n\n", self.tilt);
    
    //	[UIView animateWithDuration:2.0 animations:^{
    CATransform3D perspective               = CATransform3DIdentity;
    perspective.m34                         = -1.0 / ( 100.0 * self.perspectiveSlider.value );
    
    perspective                             = CATransform3DRotate(perspective, self.rotation, 0.0, 1.0, 0.0);
    perspective                             = CATransform3DRotate(perspective, self.tilt, 1.0, 0.0, 0.0);
    perspective                             = CATransform3DScale(perspective, 1.0, 1.0, 1.0);
    
    self.masterView.layer.sublayerTransform = perspective;
    //    }];
     
	self.masterView.layer.zPosition			= 1.0;
	self.pictureView.layer.zPosition		= self.pictureDistanceSlider.value;
	self.captureView.layer.zPosition		= self.pictureDistanceSlider.value + 1.0;
	self.overlayView.layer.zPosition		= self.pictureDistanceSlider.value + 1.0;
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
		self.captureView.layer.transform		= pictureFrameTransform;
		self.overlayView.layer.transform		= pictureFrameTransform;
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
#pragma mark Camera Methods


// Create and configure a capture session and start it running
- (void)setupCaptureSession 
{
	NSLog(@"setupCaptureSession");
	
    NSError *error = nil;
	
	//
    // Create the session
	//
    AVCaptureSession *session					= [[AVCaptureSession alloc] init];
	
	//
    // Configure the session to produce lower resolution video frames, if your 
    // processing algorithm can cope. We'll specify medium quality for the
    // chosen device.
	//
    session.sessionPreset						= AVCaptureSessionPreset640x480;
	
    //
	// Find a suitable AVCaptureDevice
	//
    AVCaptureDevice *device						= [AVCaptureDevice
												   defaultDeviceWithMediaType:AVMediaTypeVideo];
	
	//
	// Support auto-focus locked mode
	//
	if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) 
	{
		NSError *error = nil;
		if ([device lockForConfiguration:&error]) 
        {
			device.focusMode					= AVCaptureFocusModeAutoFocus;
			[device unlockForConfiguration];
		}
		else 
		{
			// Respond to the failure as appropriate.
		}
	}
	
	//
	// Support auto flash mode
	//
	if ([device isFlashModeSupported:AVCaptureFlashModeAuto]) 
	{
		NSError *error = nil;
		if ([device lockForConfiguration:&error]) {
			device.flashMode					= AVCaptureFlashModeAuto;
			[device unlockForConfiguration];
		}
		else 
		{
			// Respond to the failure as appropriate.
		}
	}	
	
	//
    // Create a device input with the device and add it to the session.
	//
    AVCaptureDeviceInput *input					= [AVCaptureDeviceInput deviceInputWithDevice:device 
																			error:&error];
    if (!input) 
	{
        // Handling the error appropriately.
    }
    [session addInput:input];
	
	//
    // Create a VideoDataOutput and add it to the session
	//
    AVCaptureVideoDataOutput *output			= [[[AVCaptureVideoDataOutput alloc] init] autorelease];
    [session addOutput:output];
	
	//
	// GCD USED HERE
	//
    // Configure your output.
	//
    dispatch_queue_t queue						= dispatch_queue_create("myQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
    dispatch_release(queue);
	
    // Specify the pixel format
    output.videoSettings =				[NSDictionary dictionaryWithObject:
										 [NSNumber numberWithInt:kCVPixelFormatType_32BGRA] 
														  forKey:(id)kCVPixelBufferPixelFormatTypeKey];
	
	//
    // If you wish to cap the frame rate to a known value, such as 1/5 fps, and yes, that's very slow, set 
    // minFrameDuration.
	//
//    output.minFrameDuration                     = CMTimeMake(1, 15);
	//output.minFrameDuration					= CMTimeMakeWithSeconds(5, 10);
	
	//
	// This is what actually gets the AVCaptureSession going
	//
    [session startRunning];
	
	//
    // Assign session we've created here to our AVCaptureSession ivar.
	//
	// KEY POINT: With this AVCaptureSession property, you can start/stop scanning to your hearts content, or 
	// until the code you are trying to read has read it.
	//
	self.capturedSession						= session;
}



- (void)cameraOn
{
	self.cameraButton.selected					= YES;
	
	CGPoint newCameraButtonCenter				= self.cameraButton.center;
	newCameraButtonCenter.x						= 94.0;
	
	CGPoint	newScanButtonCenter					= self.scanButton.center;
	newScanButtonCenter.x						= 226.0;

	//
	// Translate the cameraButton and scanButton using view animation
	//
	[UIView animateWithDuration:0.75 animations:^{
		self.cameraButton.center				= newCameraButtonCenter;
		self.scanButton.center					= newScanButtonCenter;
		
		self.scanButton.layer.opacity			= 1.0;
		
		self.captureImageView.layer.opacity		= 0.0;
		
		self.pictureView.layer.opacity			= 0.0;
	}];
	
	[self setupCaptureSession];
	
	//
	// This creates the preview of the camera
	//
	AVCaptureVideoPreviewLayer *previewLayer	= [AVCaptureVideoPreviewLayer layerWithSession:self.capturedSession];
	
    previewLayer.frame							= self.captureView.bounds; // Assume you want the preview layer to fill the view.
    
    if (previewLayer.orientationSupported) 
    {
        previewLayer.orientation                = AVCaptureVideoOrientationPortrait;
    }
    
    previewLayer.videoGravity                   = AVLayerVideoGravityResizeAspectFill;
	[self.captureView.layer addSublayer:previewLayer];				
}



- (void)cameraOff
{
	self.cameraButton.selected					= NO;
	
	CGPoint newCameraButtonCenter				= self.cameraButton.center;
	newCameraButtonCenter.x						= 160.0;
	
	CGPoint	newScanButtonCenter					= self.scanButton.center;
	newScanButtonCenter.x						= 160.0;
	
	//
	// Translate the cameraButton and scanButton using view animation
	//
	[UIView animateWithDuration:0.75 animations:^{
		self.cameraButton.center				= newCameraButtonCenter;
		self.scanButton.center					= newScanButtonCenter;
		
		self.scanButton.layer.opacity			= 0.0;
		
		self.overlayView.layer.opacity			= 0.0;
		
		self.captureImageView.layer.opacity		= 1.0;
		
		self.pictureView.layer.opacity			= 0.0;
	}];
	
	
	[self.capturedSession stopRunning];	
}



#pragma mark -
#pragma mark Screenshot Methods Using AVFoundation and UIKit

//
// Delegate routine that is called when a sample buffer is written that captures camera content
//
- (void)captureOutput:(AVCaptureOutput *)captureOutput 
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer 
       fromConnection:(AVCaptureConnection *)connection
{ 
	
	if (self.scanning) 
	{
		NSLog(@"-captureOutput:didOutputSampleBuffer:fromConnection:");
		
		self.scanning						= NO;
		self.scanButton.selected			= NO;
		
		//
		// Create a UIImage from the sample buffer data
		//
		UIImage *image						= [self imageFromSampleBuffer:sampleBuffer];
		
		//
		// Create a graphics context with the target size
		//
		//CGSize imageSize					= [[UIScreen mainScreen] bounds].size;
		CGSize imageSize					= CGSizeMake(180.0, 235.0);
		//CGSize imageSize					= CGSizeMake(self.pictureFrameView.frame.size.width, self.pictureFrameView.frame.size.width);
		UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
		
		CGContextRef context				= UIGraphicsGetCurrentContext();
		
		//
		// Draw the image returned by the camera sample buffer into the context. 
		// Draw it into the same sized rectangle as the view that is displayed on the screen.
		//
		float menubarUIOffset				= 0.0;
		UIGraphicsPushContext(context);
		[image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height-menubarUIOffset)];
		UIGraphicsPopContext();
		
		//
		// Render the camera overlay view into the graphic context that we created above.
		//
		[self renderView:self.overlayView inContext:context];
		[self renderView:self.pictureFrameView inContext:context];
		
		//
		// Retrieve the screenshot image containing both the camera content and the overlay view
		//
		UIImage *screenshot					= UIGraphicsGetImageFromCurrentImageContext();
		
		UIGraphicsEndImageContext();
		
		UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
	}
	
	self.overlayView.layer.opacity			= 0.0;
}



// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer 
{
	NSLog(@"-imageFromSampleBuffer:sampleBuffer:\n\n");
	
	//
    // Get a CMSampleBuffer's Core Video image buffer for the media data
	//
    CVImageBufferRef imageBuffer		= CMSampleBufferGetImageBuffer(sampleBuffer); 
    
	//
	// Lock the base address of the pixel buffer
	//
    CVPixelBufferLockBaseAddress(imageBuffer, 0); 
	
    //
	// Get the number of bytes per row for the pixel buffer
	//
    void *baseAddress					= CVPixelBufferGetBaseAddress(imageBuffer); 
	
	//
    // Get the number of bytes per row for the pixel buffer
	//
    size_t bytesPerRow					= CVPixelBufferGetBytesPerRow(imageBuffer); 
    
	//
	// Get the pixel buffer width and height
	//
    size_t width						= CVPixelBufferGetWidth(imageBuffer); 
    size_t height						= CVPixelBufferGetHeight(imageBuffer); 
	
	//
    // Create a device-dependent RGB color space
	//
    CGColorSpaceRef colorSpace			= CGColorSpaceCreateDeviceRGB(); 
	
	//
    // Create a bitmap graphics context with the sample buffer data
	//
    CGContextRef context				= CGBitmapContextCreate(baseAddress, 
																width, 
																height, 
																8, 
																bytesPerRow, 
																colorSpace, 
																kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst); 
	
	//
	// Create a Quartz image from the pixel data in the bitmap graphics context
	//
    CGImageRef quartzImage				= CGBitmapContextCreateImage(context); 
	
	
	//////////////////////////////////////////////////////////////////////
	//																	//	
	// VERY IMPORTANT: Without this line, the image is rotated CCW 90°	//
	//																	//	
	//////////////////////////////////////////////////////////////////////
	//
    // Create an image object from the Quartz image
	//int frontCameraImageOrientation = UIImageOrientationLeftMirrored;
	int backCameraImageOrientation = UIImageOrientationRight;
	
	UIImage *image = [UIImage imageWithCGImage:quartzImage scale:(CGFloat)1.0 orientation:backCameraImageOrientation];
	
	//
	// Unlock the pixel buffer
	//
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
	
	//
    // Free up the context and color space
	//
    CGContextRelease(context); 
    CGColorSpaceRelease(colorSpace);
	
	//
	// Release the Quartz image
	//
    CGImageRelease(quartzImage);
	
    return (image);
}



// Render the UIView into the CGContextRef using the 
// CALayer/-renderInContext: method

- (void)renderView:(UIView*)view inContext:(CGContextRef)context
{
	NSLog(@"-renderView:inContext:");
	
	//
    // -renderInContext: renders in the coordinate space of the layer,
    // so we must first apply the layer's geometry to the graphics context
	//
    CGContextSaveGState(context);
    
	//
	// Center the context around the window's anchor point
	//
    CGContextTranslateCTM(context, [view center].x, [view center].y);
    
	//
	// Apply the window's transform about the anchor point
	//
    CGContextConcatCTM(context, [view transform]);
    
	//
	// Offset by the portion of the bounds left of and above the anchor point
	//
    CGContextTranslateCTM(context,
                          -[view bounds].size.width * [[view layer] anchorPoint].x,
                          -[view bounds].size.height * [[view layer] anchorPoint].y);
	
	//
    // Render the layer hierarchy to the current context
	//
    [[view layer] renderInContext:context];
	
	//
    // Restore the context
	//
    CGContextRestoreGState(context);
}




#pragma mark -
#pragma mark IBAction Methods for Setting Perspecive & View Distances
- (IBAction)perspectiveMultipleSetting
{
	self.perspectiveMultiple			= (CGFloat)self.perspectiveSlider.value;
	//[self animateMasterView];
}



- (IBAction)pictureDistanceSetting
{
	[self offSetView:( CGFloat ) ( self.pictureDistanceSlider.value * sin( self.rotationAngleSlider.value * M_PI ))];
	//[self animateMasterView];
}



- (IBAction)rotatePictureSetting
{
	[self rotateViewsByAngle:( CGFloat )self.rotationAngleSlider.value * M_PI];
	
	[self offSetView:( CGFloat )( self.pictureDistanceSlider.value * sin( self.rotationAngleSlider.value * M_PI ))];
	//[self animateMasterView];
}



- (IBAction)setupCamera
{
	if (!self.cameraButton.selected) 
	{
		[self cameraOn];
	}
	else 
	{
		[self cameraOff];
	}
}



- (IBAction)scan
{
	NSLog(@"Scanning");
	
	self.scanning									= YES;
	self.scanButton.selected						= YES;
	
	self.overlayView.layer.opacity					= 1.0;
}



#pragma mark -
#pragma mark Gesture Recognizers
- (void)createGestureRecognizers
{
    
    //
    // Gesture Recognizers
    //
    UIGestureRecognizer *recognizer;
	
	// Tap Gesture (for re-orienting object)
	/*
     Create a tap recognizer and add it to the view.
     Keep a reference to the recognizer to test in gestureRecognizer:shouldReceiveTouch:.
     */	
	recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFromGestureRecognizer:)];
	
	[self.view addGestureRecognizer:recognizer];
	self.tapRecognizer                          = (UITapGestureRecognizer *)recognizer;
	self.tapRecognizer.numberOfTapsRequired     = 2;
	recognizer.delegate                         = self;
	[recognizer release];
	
	// Pan Gesture (for rotation and tilt)
	recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotateAndTiltFromGestureRecognizer:)];
	self.panRecognizer                          = (UIPanGestureRecognizer *)recognizer;
	[self.view addGestureRecognizer:panRecognizer];
	panRecognizer.delegate                      = self;
	[recognizer release];
	
	// Pinch Gesture (for zoom)
    //	recognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self.view action:@selector(handleZoomFromGestureRecognizer:)];
    //	self.pinchRecognizer                        = (UIPinchGestureRecognizer *)recognizer;
    //	//	[self gestureRecognizer:pinchRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:panRecognizer];
    //	[self.view addGestureRecognizer:pinchRecognizer];
    //	pinchRecognizer.delegate                    = self;
    //	[recognizer release];
}

- (void)handleTapFromGestureRecognizer:(UITapGestureRecognizer *)recognizer
{
	self.translationX                             = INITIAL_ROTATION;
	rotation                                        = INITIAL_ROTATION;
	rotationIncrement                               = 0.0;
	tilt                                            = INITIAL_TILT;
	tiltIncrement                                   = 0.0;   
    
    [self animateMasterViewToInitial];
	
//	[self printTilt];
//	[self printRotation];
}



- (void)handleRotateAndTiltFromGestureRecognizer:(UIPanGestureRecognizer *)recognizer
{
    //	NSLog(@"\n\nJust panned!\n\n");
	
	// CGPoint translation note:
	// Lay-out of iPhone/iPad screen coordinate system
	// 
	//  +------------------------------------> X
	//  |
	//  |
	//  |            ^
	//  |            |
	//  |           (-)
	//  |            |
	//  |    <-(-)--   --(+)->
	//  |            |
	//  |           (+)
	//  |            |
	//  |            v
	//  |
	//  v
	// 
	//  Y
	
	CGPoint translation         = [recognizer translationInView:self.view];
    CGFloat totalTranslation    = abs(translation.x) + abs(translation.y) + 0.0001;
	
	CGPoint velocity = [recognizer velocityInView:self.view];
	
	if (abs( velocity.x) > 30 || abs( velocity.y) > 30 )
	{
		self.rotationIncrement  = translation.x * (  M_PI / ( 50.0 * 180.0 ) );
        self.translationX       = translation.x / totalTranslation;

		self.tiltIncrement      = -translation.y * (  M_PI / ( 80.0 * 180.0 ) );
        translationY            = -translation.y / totalTranslation;
	}
	
    [self transformMasterView];
}



#pragma mark -
#pragma mark UIGestureRecognizerDelegate
/*
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)pinchRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)panRecognizer
{
	return YES;
}
*/


@end
