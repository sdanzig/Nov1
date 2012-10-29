//
//  View.m
//  Nov1
//
//  Created by Scott Danzig on 10/27/12.
//  Copyright (c) 2012 Scott Danzig. All rights reserved.
//

#import "View.h"
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define textYPos(areaPos) (areaPos+(textAreaHeight-actualTextHeight)/2.0)

@implementation View

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Set background to light brown
        self.backgroundColor = UIColorFromRGB(0xD8C7A9);
        clapboardOpen = true;
        textSize = 18.0;
        labelFont = @"KannadaSangamMN-Bold";
        infoFont = @"ChalkboardSE-Regular";
        numberFont = @"Courier-Bold";
        CGSize textBounds = [@"Production" sizeWithFont:[UIFont fontWithName:labelFont size:textSize]];
        actualTextHeight = textBounds.height * 0.4;
        bodyMargin = 10;       
        viewWidth = self.bounds.size.width;
        viewHeight = self.bounds.size.height;
        bodyWidth = 3.0 * viewHeight / 5.0;
        bodyHeight = (7.0 / 8.0) * (3.0 * viewWidth / 5.0);
        stickWidth = bodyWidth;
        stickHeight = (1.0 / 8.0) * (3.0 * viewWidth / 5.0);
        colorBlockWidth = stickWidth / 11.0;
        textAreaWidth = bodyWidth - (bodyMargin * 2);
        textAreaHeight = bodyHeight / 6;
        CGSize numberBounds = [@"16G" sizeWithFont:[UIFont fontWithName:numberFont size:textSize * 2]];
        CGFloat actualNumHeight = numberBounds.height * 0.4;
        numberYPos = ((textAreaHeight*2) - actualNumHeight) / 2 + (textAreaHeight * 3);
        
        //Initialize sound
        NSURL *crack   = [[NSBundle mainBundle] URLForResource: @"crack"
                                                withExtension: @"caf"];
        
        // Create a system sound object representing the sound file.
        AudioServicesCreateSystemSoundID ((CFURLRef)CFBridgingRetain(crack), &soundFileObject);
        [self setMultipleTouchEnabled:YES];
    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!clapboardOpen) {
        NSLog(@"touch!");
        [self setNeedsDisplay];
//        [self performSelector: @selector(setNeedsDisplay) withObject: nil afterDelay: 1.0];
    }
}

bool clapboardOpen;

// Helper methods to draw info values
- (void)drawBodyInfoText:(NSString *)text withContext:(CGContextRef)c andYPos:(CGFloat)yPos
{
    [self drawBodyInfoText:text withContext:c andXPos:bodyMargin andYPos:yPos];
}

- (void)drawBodyInfoText:(NSString *)text withContext:(CGContextRef)c andXPos:(CGFloat)xPos andYPos:(CGFloat)yPos
{
    CGContextSetRGBFillColor(c, 0.8, 0.8, 1.0, 1.0);
    CGContextSelectFont(c, [infoFont UTF8String], textSize, kCGEncodingMacRoman);
    CGContextShowTextAtPoint(c, xPos, yPos, [text UTF8String], [text length]);
}

// Helper methods to draw scene and take numbers
- (void)drawBodyNumberText:(NSString *)text withContext:(CGContextRef)c andXPos:(CGFloat)xPos
{
    CGContextSetRGBFillColor(c, 1.0, 1.0, 0.0, 1.0);
    CGContextSelectFont(c, [numberFont UTF8String], textSize * 2, kCGEncodingMacRoman);
    CGContextShowTextAtPoint(c, xPos, numberYPos, [text UTF8String], [text length]);
}

- (void)drawNumberWithLabel:(NSString *)labelString andValue:(NSString *)valueString andXPos:(CGFloat)xPos withContext:(CGContextRef)c
{
    CGFloat labelOffset = [self drawBodyLabelText:labelString withContext:c andXPos:xPos andYPos:textYPos(textAreaHeight*4)];
    CGSize valueBounds = [valueString sizeWithFont:[UIFont fontWithName:numberFont size:textSize * 2]];
    [self drawBodyNumberText:valueString withContext:c andXPos:xPos+labelOffset+(textAreaWidth/2-labelOffset-valueBounds.width)/2];
}

// Helper methods to draw labels
- (CGFloat)drawBodyLabelText:(NSString *)text withContext:(CGContextRef)c andYPos:(CGFloat)yPos
{
    return [self drawBodyLabelText:text withContext:c andXPos:bodyMargin andYPos:yPos];
}

- (CGFloat)drawBodyLabelText:(NSString *)text withContext:(CGContextRef)c andXPos:(CGFloat)xPos andYPos:(CGFloat)yPos
{
    CGContextSetRGBFillColor(c, 1.0, 1.0, 1.0, 1.0);
    CGContextSelectFont(c, [labelFont UTF8String], textSize, kCGEncodingMacRoman);
    CGContextShowTextAtPoint(c, xPos, yPos, [text UTF8String], [text length]);
    CGSize labelBounds = [text sizeWithFont:[UIFont fontWithName:labelFont size:18.0]];
    return labelBounds.width;
}

- (void)drawHorizontalSeparatorAtYPos:(CGFloat)yPos withContext:(CGContextRef)c
{
    CGContextMoveToPoint(c, bodyMargin, yPos);
    CGContextAddLineToPoint(c, bodyMargin + textAreaWidth, yPos);
    CGContextStrokePath(c);
}

- (void)drawRect:(CGRect)rect
{

    // Body of clapperboard
    CGContextRef c = UIGraphicsGetCurrentContext();
	CGContextBeginPath(c);
    CGFloat translationX = (viewWidth - stickHeight - bodyHeight) / 2.0;
    CGFloat translationY = (viewHeight - bodyWidth) / 2.0;
    
	CGContextTranslateCTM(c, translationX, translationY);
    CGContextRotateCTM(c, 90 * M_PI / 180);	//90 degrees clockwise
    
	CGContextScaleCTM(c, 1, -1);                               //make Y axis point up
    
	CGRect body = CGRectMake(0, 0, bodyWidth, bodyHeight);
	CGContextAddRect(c, body);
    CGContextSetRGBFillColor(c, 0.0, 0.0, 0.0, 1.0);
    CGContextSetShadow(c, CGSizeMake(10, -20), 5);
	CGContextFillPath(c);
    CGContextSetShadowWithColor(c, CGSizeMake(0,0),0.0,NULL);
    CGContextBeginPath(c);
    CGContextSetRGBStrokeColor(c, 1.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(c, 4.0);
    CGContextSetLineCap(c, kCGLineCapRound);
    
    [self drawHorizontalSeparatorAtYPos:textAreaHeight withContext:c];
    [self drawHorizontalSeparatorAtYPos:textAreaHeight*2 withContext:c];
    [self drawHorizontalSeparatorAtYPos:textAreaHeight*3 withContext:c];
    [self drawHorizontalSeparatorAtYPos:textAreaHeight*5 withContext:c];

    CGContextMoveToPoint(c, bodyWidth/2, textAreaHeight*3);
    CGContextAddLineToPoint(c, bodyWidth/2, textAreaHeight*5);
    CGContextStrokePath(c);

    //Placeholder text
    NSString *productionString = @"The Shining";
    NSString *sceneString = @"12G";
    NSString *takeString = @"4";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"MMMM dd, yyyy"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSString *directorString = @"Stanley Kubrick";
    NSString *cameraString = @"John Alcott";

    CGFloat labelOffset;
    labelOffset = [self drawBodyLabelText:@"Production: " withContext:c andYPos:textYPos(textAreaHeight*5)];
    [self drawBodyInfoText:productionString withContext:c andXPos:bodyMargin+labelOffset andYPos:textYPos(textAreaHeight*5)];
    
    [self drawNumberWithLabel:@"Scene" andValue:sceneString andXPos:bodyMargin withContext:c];
    [self drawNumberWithLabel:@"Take" andValue:takeString andXPos:bodyWidth/2+6 withContext:c];

    labelOffset = [self drawBodyLabelText:@"Date: " withContext:c andYPos:textYPos(textAreaHeight*2)];
    [self drawBodyInfoText:dateString withContext:c andXPos:bodyMargin+labelOffset andYPos:textYPos(textAreaHeight*2)];
    labelOffset = [self drawBodyLabelText:@"Director: " withContext:c andYPos:textYPos(textAreaHeight)];
    [self drawBodyInfoText:directorString withContext:c andXPos:bodyMargin+labelOffset andYPos:textYPos(textAreaHeight)];
    labelOffset = [self drawBodyLabelText:@"Camera: " withContext:c andYPos:textYPos(0)];
    [self drawBodyInfoText:cameraString withContext:c andXPos:bodyMargin+labelOffset andYPos:textYPos(0)];

    
    // Stick of clapperboard
    c = UIGraphicsGetCurrentContext();
	CGContextBeginPath(c);
    translationX += bodyHeight;
	CGContextTranslateCTM(c, 0, bodyHeight);
    
    CGContextBeginPath(c);
    if(clapboardOpen) {
        CGContextRotateCTM(c, 15.0 * M_PI / 180.0);	//15 degrees counterclockwise
    }
	CGRect stick = CGRectMake(0, 0, stickWidth, stickHeight);
    CGContextSetShadow(c, CGSizeMake(10, -20), 5);
	CGContextAddRect(c, stick);
    CGContextSetRGBFillColor(c, 0.0, 0.0, 0.0, 1.0);
	CGContextFillPath(c);
    CGContextSetShadowWithColor(c, CGSizeMake(0,0),0.0,NULL);
    unsigned int colors [] = {
        0xC0C0C0,
        0xC0C000,
        0x00C0C0,
        0x00C000,
        0xC000C0,
        0xC00000,
        0x0000C0
    };
    CGRect stickColorBlock;
    int i;
    for(i=0; i<sizeof(colors) / sizeof(unsigned int); i++) {
        stickColorBlock = CGRectMake(colorBlockWidth * (i+2.0), 0, colorBlockWidth, stickHeight);
        CGContextAddRect(c, stickColorBlock);
        CGContextSetFillColorWithColor(c, [UIColorFromRGB(colors[i]) CGColor]);
        CGContextFillPath(c);
    }
    

    // create playStickCrack function that plays a sound file of a clapboard noise
    // add touch handler that calls rotateStick, rotating down 15 degrees and calling playStickCrack

    if(!clapboardOpen) {
        AudioServicesPlaySystemSound(soundFileObject);
        [self performSelector: @selector(setNeedsDisplay) withObject: nil afterDelay: 1.0];
    }
    clapboardOpen = !clapboardOpen;
}

@end
