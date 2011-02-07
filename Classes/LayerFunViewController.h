//
//  LayerFunViewController.h
//  LayerFun
//
//  Created by Anonymous Apple Employee for Jim Hillhouse on 6/9/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LayerFunViewController : UIViewController 
{
	IBOutlet UIView			*masterView;
	IBOutlet UIView			*pictureView;
	IBOutlet UIView			*backgroundView;
	IBOutlet UIImageView	*pictureImageView;
}

- (void)animate;

@end

