


- (void)panForTranslation:(CGPoint)translation {
    if (selSprite) {
        
        
        // From
        
        CCSprite *futureSprite;
        
        // Add the possible future offset of the Piece
        CGPoint futurePos = ccpAdd(selSprite.position, translation);
        selSprite.position = futurePos;
        
        // Assign the possible future Sprite to a new FutureSprite
        futureSprite = selSprite;
        
        // Create an opposite offset translation CGPoint
        CGPoint translationBack = translation;
        
        translationBack.x = - translationBack.x;
        translationBack.y = - translationBack.y;
        
        // Backwards selSprite to its original position as we now
        // have futureSprite with the possible future position
        futurePos = ccpAdd(selSprite.position, translationBack);
        selSprite.position = futurePos;
        futurePos = ccpAdd(selSprite.position, translation);
        
        
        // To:
        
        CCSprite *futureSprite;
        futureSprite = [[CCSprite alloc]init];
        
        
        CGPoint futurePos = ccpAdd(selSprite.position, translation);
        
        futureSprite.position = futurePos;
        
        futurePos = ccpAdd(selSprite.position, translation);
        
    // Area Checking

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
