/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/

#import "AR_EAGLView.h"
#import "ARViewController.h"
//#import "OverlayViewController.h"

// This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView
// subclass.  The view content is basically an EAGL surface you render your
// OpenGL scene into.  Note that setting the view non-opaque will only work if
// the EAGL surface has an alpha channel.
@class OverlayViewController;
@interface EAGLView : AR_EAGLView<MPMediaPlayback>
{
    
    OverlayViewController *overlay;
    ARViewController *ARVIEW;
   
    
}

+(void)SetBoolVal;

@end
