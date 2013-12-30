
#import "GameScene.h"
#import "AppDelegate.h"


@implementation GameScene

// Helper class method that creates a Scene.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameScene *layer = [GameScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id)init {
    
    self = [super init];
    if(self) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
        background = [CCSprite spriteWithFile:kBGTABULEIRO1];
        background.anchorPoint = ccp(0,0);
        [self addChild:background];
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_Default];
        
        movableSprites = [[NSMutableArray alloc] init];
        NSArray *images = [NSArray arrayWithObjects:kPIECER, kPIECEG, kPIECEY, kPIECEB, nil];
       
        
        for(int i = 0; i < images.count; ++i) {
            NSString *image = [images objectAtIndex:0];
            CCSprite *sprite = [CCSprite spriteWithFile:image];
            sprite.position = ccp(AREA_A1_X1 + (i * 56), AREA_A1A6A2_Y);
            [self addChild:sprite];
            [movableSprites addObject:sprite];
        }
        
        for(int i = 0; i < images.count; ++i) {
            NSString *image = [images objectAtIndex:1];
            CCSprite *sprite = [CCSprite spriteWithFile:image];
            sprite.position = ccp(AREA_A2_X2 - (i * 56), AREA_A1A6A2_Y);
            [self addChild:sprite];
            [movableSprites addObject:sprite];
        }
 
        for(int i = 0; i < images.count; ++i) {
            NSString *image = [images objectAtIndex:2];
            CCSprite *sprite = [CCSprite spriteWithFile:image];
            sprite.position = ccp(AREA_A1_X1 + (i * 56), AREA_A3A5A4_Y);
            [self addChild:sprite];
            [movableSprites addObject:sprite];
        }
        
        for(int i = 0; i < images.count; ++i) {
            NSString *image = [images objectAtIndex:3];
            CCSprite *sprite = [CCSprite spriteWithFile:image];
            sprite.position = ccp(AREA_A2_X2 - (i * 56), AREA_A3A5A4_Y);
            [self addChild:sprite];
            [movableSprites addObject:sprite];
        }
        
    }
    
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    
    return self;
}

- (void)selectSpriteForTouch:(CGPoint)touchLocation {
    CCSprite * newSprite = nil;
    for (CCSprite *sprite in movableSprites) {
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {
            newSprite = sprite;
            break;
        }
    }
    if (newSprite != selSprite) {
        [selSprite stopAllActions];
        [selSprite runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
        CCRotateTo * rotLeft = [CCRotateBy actionWithDuration:0.1 angle:-4.0];
        CCRotateTo * rotCenter = [CCRotateBy actionWithDuration:0.1 angle:0.0];
        CCRotateTo * rotRight = [CCRotateBy actionWithDuration:0.1 angle:4.0];
        CCSequence * rotSeq = [CCSequence actions:rotLeft, rotCenter, rotRight, rotCenter, nil];
        [newSprite runAction:[CCRepeatForever actionWithAction:rotSeq]];
        selSprite = newSprite;
    }
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];
    return TRUE;
}

- (CGPoint)boundLayerPos:(CGPoint)newPos {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGPoint retval = newPos;
    retval.x = MIN(retval.x, 0);
    retval.x = MAX(retval.x, -background.contentSize.width+winSize.width);
    retval.y = self.position.y;
    return retval;
}

- (void)panForTranslation:(CGPoint)translation {
    if (selSprite) {
        
        CCSprite *futureSprite;
        
        
        CGPoint futurePos = ccpAdd(selSprite.position, translation);
        selSprite.position = futurePos;
        
        futureSprite = selSprite;
        
        CGPoint translationBack = translation;
        
        translationBack.x = - translationBack.x;
        translationBack.y = - translationBack.y;
        
        futurePos = ccpAdd(selSprite.position, translationBack);
        selSprite.position = futurePos;
        futurePos = ccpAdd(selSprite.position, translation);
        

        //Check for areas
        // AREA_1
        if((selSprite.position.x <= AREA_A1_X2) && ((selSprite.position.y >=  AREA_A1_Y1) && ((selSprite.position.y <=  AREA_A1_Y2))))
           {
               if((selSprite.position.x + translation.x >= AREA_A1_X1) && ((selSprite.position.y + translation.y >=  AREA_A1_Y1) && (selSprite.position.y + translation.y <=  AREA_A1_Y2)) && (![self detectCollision:futureSprite]))
               {
                   selSprite.position = futurePos;
                   CGPoint newPos = ccpAdd(selSprite.position, translation);
                   selSprite.position = newPos;
               }
           }

        // AREA_2
        if((selSprite.position.x >= AREA_A2_X1) && ((selSprite.position.y >=  AREA_A1_Y1) && ((selSprite.position.y <=  AREA_A1_Y2))))
        {
            if((selSprite.position.x + translation.x < AREA_A2_X2) && ((selSprite.position.y + translation.y >=  AREA_A1_Y1) && (selSprite.position.y + translation.y <=  AREA_A1_Y2)) && (![self detectCollision:futureSprite]))
            {
                selSprite.position = futurePos;
                CGPoint newPos = ccpAdd(selSprite.position, translation);
                selSprite.position = newPos;
            }
        }
        
        // AREA_6
        if(((selSprite.position.x >= AREA_A6_X1) && ((selSprite.position.x <= AREA_A6_X2))) && (selSprite.position.y >  AREA_A6_Y1))
        {
            if(((selSprite.position.x + translation.x >= AREA_A6_X1) && ((selSprite.position.x + translation.x <= AREA_A6_X2))) && ((selSprite.position.y + translation.y >=  AREA_A6_Y1 - 1) && (selSprite.position.y + translation.y <=  AREA_A6_Y2)) && (![self detectCollision:futureSprite]))
            {
                selSprite.position = futurePos;
                CGPoint newPos = ccpAdd(selSprite.position, translation);
                selSprite.position = newPos;
            }
        }
        
        // AREA_7
        NSLog(@"x= %f, y= %f",selSprite.position.x, selSprite.position.y);
        if(((selSprite.position.x >= AREA_A7_X1) && ((selSprite.position.x <= AREA_A7_X2))) && ((selSprite.position.y <=  AREA_A7_Y1) && (selSprite.position.y >=  AREA_A7_Y2)))
        {
            if(((selSprite.position.x + translation.x >= AREA_A7_X1) && ((selSprite.position.x + translation.x <= AREA_A7_X2))) && ((selSprite.position.y + translation.y <=  AREA_A7_Y1 + 1) && (selSprite.position.y + translation.y >=  AREA_A7_Y2 - 1)) && (![self detectCollision:futureSprite]))
            {
                selSprite.position = futurePos;
                CGPoint newPos = ccpAdd(selSprite.position, translation);
                selSprite.position = newPos;
            }
        }
        
        // AREA_5
        if(((selSprite.position.x >= AREA_A5_X1) && ((selSprite.position.x <= AREA_A5_X2))) && ((selSprite.position.y >=  AREA_A5_Y1) && (selSprite.position.y <=  AREA_A5_Y2)))
        {
            if(((selSprite.position.x + translation.x >= AREA_A5_X1) && ((selSprite.position.x + translation.x <= AREA_A5_X2))) && ((selSprite.position.y + translation.y >=  AREA_A5_Y1) && (selSprite.position.y + translation.y >=  AREA_A5_Y1)) && (![self detectCollision:futureSprite]))
            {
                selSprite.position = futurePos;
                CGPoint newPos = ccpAdd(selSprite.position, translation);
                selSprite.position = newPos;
            }
        }
        
        // AREA_3
        if((selSprite.position.x <= AREA_A3_X2) && ((selSprite.position.y >=  AREA_A3_Y1) && ((selSprite.position.y <=  AREA_A3_Y2))))
        {
            if((selSprite.position.x + translation.x >= AREA_A3_X1) && ((selSprite.position.y + translation.y >=  AREA_A3_Y1) && (selSprite.position.y + translation.y <=  AREA_A3_Y2)) && (![self detectCollision:futureSprite]))
            {
                selSprite.position = futurePos;
                CGPoint newPos = ccpAdd(selSprite.position, translation);
                selSprite.position = newPos;
            }
        }
        
        // AREA_4
        if((selSprite.position.x >= AREA_A4_X1) && ((selSprite.position.y >=  AREA_A4_Y1) && ((selSprite.position.y <=  AREA_A4_Y2))))
        {
            if((selSprite.position.x + translation.x < AREA_A4_X2) && ((selSprite.position.y + translation.y >=  AREA_A4_Y1) && (selSprite.position.y + translation.y <=  AREA_A4_Y2)) && (![self detectCollision:futureSprite]))
            { //  && (![self futureSprite])
                selSprite.position = futurePos;
                CGPoint newPos = ccpAdd(selSprite.position, translation);
                selSprite.position = newPos;
            }
        }

        //NSLog(@"x= %f, y= %f",selSprite.position.x, selSprite.position.y);
    } else {
        //selSprite.position = futurePos;
        //CGPoint newPos = ccpAdd(self.position, translation);
        //self.position = [self boundLayerPos:newPos];
    }
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    [self panForTranslation:translation];
}

// Para detectar colisões

- (BOOL)detectCollision: (CCSprite*)sprite{
    // Detecta colisões
    BOOL result = FALSE;
   
    for (int i = 0; i < [movableSprites count]; i++)
    {
        CCSprite *toCollide = [movableSprites objectAtIndex:i];
        if(sprite==toCollide){
            continue;
        }
    
        if (CGRectIntersectsRect(sprite.boundingBox, toCollide.boundingBox)) {
            
            //handle collision
            NSLog(@"Collides");
            result = TRUE;
        }
        
    }
    return result;
}

- (void)dealloc
{
    [super dealloc];
    [movableSprites release];
    movableSprites = nil;
}

@end
