/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/

// Subclassed from AR_EAGLView
#import "EAGLView.h"
#import "Teapot.h"
#import "Texture.h"

//#import <QCAR/Renderer.h>
#import "Renderer.h"

#import "QCARutils.h"
#import "AppDelegate.h"
#import "OverlayViewController.h"


#define RealSteelURL @"http://182.71.230.252/download/RealSteel.mp4"
#define TransformURL @"http://182.71.230.252/download/transformer.mp4"
#define JournyURL @"http://182.71.230.252/download/Journey to the Center of the Earth - Official Trailer (HD).mp4"
#define TangleURL @"http://182.71.230.252/download/Tangled - Official Trailer [HD].mp4"


#ifndef USE_OPENGL1
#import "ShaderUtils.h"
#endif

namespace {
    // Teapot texture filenames
    const char* textureFilenames[] = {
        "TextureTeapotBrass.png",
        "TextureTeapotBlue.png",
        "TextureTeapotRed.png"
    };

    // Model scale factor
    const float kObjectScale = 3.0f;
}


@implementation EAGLView


 BOOL boolval=NO;
- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
	if (self)
    {
        // create list of textures we want loading - ARViewController will do this for us
        int nTextures = sizeof(textureFilenames) / sizeof(textureFilenames[0]);
        for (int i = 0; i < nTextures; ++i)
            [textureList addObject: [NSString stringWithUTF8String:textureFilenames[i]]];
    }
    return self;
}

- (void) setup3dObjects
{
   
    // build the array of objects we want drawn and their texture
    // in this example we have 3 targets and require 3 models
    // but using the same underlying 3D model of a teapot, differentiated
    // by using a different texture for each
    
    for (int i=0; i < [textures count]; i++)
    {
        Object3D *obj3D = [[Object3D alloc] init];

        obj3D.numVertices = NUM_TEAPOT_OBJECT_VERTEX;
        obj3D.vertices = teapotVertices;
        obj3D.normals = teapotNormals;
        obj3D.texCoords = teapotTexCoords;
        
        obj3D.numIndices = NUM_TEAPOT_OBJECT_INDEX;
        obj3D.indices = teapotIndices;
        
        obj3D.texture = [textures objectAtIndex:i];

        [objects3D addObject:obj3D];
        
    }
    
    if (NUM_TEAPOT_OBJECT_VERTEX==824) {
    }
   
   
}


// called after QCAR is initialised but before the camera starts
- (void) postInitQCAR
{ 
    // These two calls to setHint tell QCAR to split work over multiple
    // frames.  Depending on your requirements you can opt to omit these.
    QCAR::setHint(QCAR::HINT_IMAGE_TARGET_MULTI_FRAME_ENABLED, 1);
    QCAR::setHint(QCAR::HINT_IMAGE_TARGET_MILLISECONDS_PER_MULTI_FRAME, 25);
    
    // Here we could also make a QCAR::setHint call to set the maximum
    // number of simultaneous targets                
    // QCAR::setHint(QCAR::HINT_MAX_SIMULTANEOUS_IMAGE_TARGETS, 2);
}

// modify renderFrameQCAR here if you want a different 3D rendering model
////////////////////////////////////////////////////////////////////////////////
// Draw the current frame using OpenGL
//
// This method is called by QCAR when it wishes to render the current frame to
// the screen.
//
// *** QCAR will call this method on a single background thread ***
- (void)renderFrameQCAR
{// NSLog(@"\n\n\n\n\n EAGLView renderFrameQCAR \n\n\n\n\n");
    
   
    [self setFramebuffer];
    
    // Clear colour and depth buffers
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Render video background and retrieve tracking state
    QCAR::State state = QCAR::Renderer::getInstance().begin();
    QCAR::Renderer::getInstance().drawVideoBackground();
    
   
    if (QCAR::GL_11 & qUtils.QCARFlags) {
        
        
        glEnable(GL_TEXTURE_2D);
        glDisable(GL_LIGHTING);
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnableClientState(GL_NORMAL_ARRAY);
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    }
    
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
   
    
    for (int i = 0; i < state.getNumActiveTrackables() && boolval==NO; ++i) {
        // Get the trackable
        const QCAR::Trackable* trackable = state.getActiveTrackable(i);
       // QCAR::Matrix44F modelViewMatrix = QCAR::Tool::convertPose2GLMatrix(trackable->getPose());
        
        // Choose the texture based on the target name
        int targetIndex = 0; // "stones"
        
      
        
        if (!strcmp(trackable->getName(), "chips"))
        {
            targetIndex = 1;
            
        }
        else if (!strcmp(trackable->getName(), "Journey4star"))
        {
            boolval=TRUE;
          
            NSUserDefaults *udf1=[NSUserDefaults standardUserDefaults];
            NSString *strUrlPath=[NSString stringWithFormat:@"%@",JournyURL];
            [udf1 setObject:strUrlPath forKey:@"Key4VideoURL"];
            
            [udf1 setInteger:1 forKey:@"Key4Video"];
            
            break;
        }
        else if (!strcmp(trackable->getName(), "Tangle3star"))
        {
            boolval=TRUE;
            
            NSUserDefaults *udf1=[NSUserDefaults standardUserDefaults];
            NSString *strUrlPath=[NSString stringWithFormat:@"%@",TangleURL];
            [udf1 setObject:strUrlPath forKey:@"Key4VideoURL"];
            
            [udf1 setInteger:1 forKey:@"Key4Video"];
            
            break;
        }
        else if (!strcmp(trackable->getName(), "realsteel"))
        {
            boolval=TRUE;
         
            NSUserDefaults *udf1=[NSUserDefaults standardUserDefaults];
            NSString *strUrlPath=[NSString stringWithFormat:@"%@",RealSteelURL];
            [udf1 setObject:strUrlPath forKey:@"Key4VideoURL"];
            
            [udf1 setInteger:1 forKey:@"Key4Video"];
            
            
            break;
        }
        else if (!strcmp(trackable->getName(), "Transform"))
        {
            boolval=TRUE;
          
            NSUserDefaults *udf1=[NSUserDefaults standardUserDefaults];
            
            NSString *strUrlPath=[NSString stringWithFormat:@"%@",TransformURL];
            [udf1 setObject:strUrlPath forKey:@"Key4VideoURL"];
            [udf1 setInteger:1 forKey:@"Key4Video"];
            
            
            break;
        }
        
              
    }
  
    
  
    QCAR::Renderer::getInstance().end();
  
    if (boolval==TRUE) {
         
    }
    else
    {
        boolval=FALSE;
        
        [self presentFramebuffer];
    }
       
           
   
}

   
+(void)SetBoolVal
{
boolval=NO;
     NSUserDefaults *udf1=[NSUserDefaults standardUserDefaults];
    [udf1 setInteger:0 forKey:@"Key4Video"];
}

 
@end
