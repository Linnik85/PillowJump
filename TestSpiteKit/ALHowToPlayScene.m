//
//  ALHowToPlayScene.m
//  PillowJump
//
//  Created by Линник Александр on 21.03.14.
//  Copyright (c) 2014 Alex Linnik. All rights reserved.
//

#import "ALHowToPlayScene.h"
#import "ALStartScene.h"

@interface ALHowToPlayScene ()

@property (strong, nonatomic) SKSpriteNode* backMenuButton;

@end

@implementation ALHowToPlayScene

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        
        
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"settingsBackground"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        SKSpriteNode *rules = [SKSpriteNode spriteNodeWithImageNamed:@"howToPlay"];
        rules.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMaxY(self.frame)-188);
        [self addChild:rules];
        
        [self addBackMenuButton];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode* node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"backMenuButton"]) {
        
        SKTexture* texture = [SKTexture textureWithImageNamed:@"menuButton-selected"];
        SKAction* changeTexture = [SKAction setTexture:texture];
        [node runAction:changeTexture];
    }
    
    
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode* node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"backMenuButton"]) {
        
        ALStartScene* menu = [[ALStartScene alloc] initWithSize:CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))];
        
        SKTransition* transition = [SKTransition crossFadeWithDuration:0.6];
        [self.scene.view presentScene:menu transition:transition];
        
    }else{
        
        SKTexture* texture = [SKTexture textureWithImageNamed:@"menuButton"];
        SKAction* changeTextureMenuButton = [SKAction setTexture:texture];
        [self.backMenuButton runAction:changeTextureMenuButton];
        
    }
}


#pragma mark Initialization methods


-(void) addBackMenuButton{
    
    
    self.backMenuButton = [SKSpriteNode spriteNodeWithImageNamed:@"menuButton"];
    self.backMenuButton.position = CGPointMake(70, CGRectGetMinY(self.frame)+50);
    self.backMenuButton.name = @"backMenuButton";
    [self addChild:self.backMenuButton];
}

@end
