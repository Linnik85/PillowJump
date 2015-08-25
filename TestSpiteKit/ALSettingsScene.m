//
//  ALSettingsScene.m
//  PillowJump
//
//  Created by Линник Александр on 17.03.14.
//  Copyright (c) 2014 Alex Linnik. All rights reserved.
//

#import "ALSettingsScene.h"
#import "ALStartScene.h"

@interface ALSettingsScene() <UITextFieldDelegate>

@property (nonatomic, retain) UISwitch* soundSwitch;
@property (nonatomic, retain) UISwitch* vibrateSwitch;
@property (nonatomic, retain) UITextField* playerNameTextField;

@property (nonatomic, retain) SKLabelNode* soundTitle;
@property (nonatomic, retain) SKLabelNode* vibrateTitle;
@property (nonatomic, retain) SKLabelNode* playerNameTitle;

@property (strong, nonatomic) SKSpriteNode* backMenuButton;


@property (assign, nonatomic) NSUserDefaults* userDefaults;

@end

@implementation ALSettingsScene


-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        
        self.userDefaults = [NSUserDefaults standardUserDefaults];
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"settingsBackground"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        [self addSoundTitle];
        [self addVibrateTitle];
        [self addPlayerNameTitle];
        [self addBackMenuButton];
        
            }
    return self;
}


-(void)didMoveToView:(SKView *)view{
    
    self.soundSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame)+50, CGRectGetMidY(self.frame)-26, 100, 100)];
    [self.soundSwitch addTarget: self action: @selector(flipMusicAndSound) forControlEvents:UIControlEventValueChanged];
    self.soundSwitch.tintColor =[UIColor blackColor];
    [self.view addSubview: self.soundSwitch];
    
    self.vibrateSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame)+50, CGRectGetMidY(self.frame)+50, 100, 100)];
    [self.vibrateSwitch addTarget: self action: @selector(flipMusicAndSound) forControlEvents:UIControlEventValueChanged];
    self.vibrateSwitch.tintColor =[UIColor blackColor];
    [self.view addSubview: self.vibrateSwitch];
    
    self.playerNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame)+20, CGRectGetMidY(self.frame)-115, 280.0, 40.0)];
    self.playerNameTextField.delegate = self;
    self.playerNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.playerNameTextField.returnKeyType = UIReturnKeyDone;
    self.playerNameTextField.placeholder =@"Enter Name";
    self.playerNameTextField.font = [UIFont systemFontOfSize:22];
    self.playerNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.playerNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.playerNameTextField setKeyboardType:UIKeyboardTypeDefault];
    [self.playerNameTextField setBackgroundColor:[UIColor whiteColor]];
    self.playerNameTextField.textAlignment = NSTextAlignmentCenter;
    
    if ([self.userDefaults objectForKey:@"name"] && ![[self.userDefaults objectForKey:@"name"] isEqualToString:@"Player"]) {
        self.playerNameTextField.text = [self.userDefaults objectForKey:@"name"];
    }
    
    [self.view addSubview: self.playerNameTextField];
    
    
    long soundDefaults = [self.userDefaults integerForKey:@"sound"];
    long vibrateDefaults = [self.userDefaults integerForKey:@"vibrate"];
    
    
    if (soundDefaults == 1) {
        [self.soundSwitch setOn:YES animated:YES];
    }
    else {
        [self.soundSwitch setOn:NO animated:YES];
    }
    
    if (vibrateDefaults == 1) {
        [self.vibrateSwitch setOn:YES animated:YES];
    } else{
        [self.vibrateSwitch setOn:NO animated:YES];
    }

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
        [self.vibrateSwitch removeFromSuperview];
        [self.soundSwitch removeFromSuperview];
        [self.playerNameTextField removeFromSuperview];
        
         SKTransition* transition = [SKTransition crossFadeWithDuration:0.6];
        [self.scene.view presentScene:menu transition:transition];
        
    }else{
        
        SKTexture* texture = [SKTexture textureWithImageNamed:@"menuButton"];
        SKAction* changeTextureMenuButton = [SKAction setTexture:texture];
        [self.backMenuButton runAction:changeTextureMenuButton];
        
    }
}

#pragma mark UITextFieldDelegate

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    
    if (self.playerNameTextField.text.length == 0) {
        
        [self.userDefaults setObject:@"Player" forKey:@"name"];
    } else{
    
    [self.userDefaults setObject:self.playerNameTextField.text forKey:@"name"];
    }
    [textField resignFirstResponder];
    return YES;
}



#pragma mark Initialization methods

-(void) addSoundTitle{
    
    self.soundTitle = [SKLabelNode labelNodeWithFontNamed:@"Times New Roman"];
    [self.soundTitle setText:@"Sound"];
    [self.soundTitle setFontSize:24];
    self.soundTitle.fontColor =[UIColor colorWithRed:0/255.0f green:102/255.0f blue:51/255.0f alpha:1.0f];
    [self.soundTitle setPosition:CGPointMake(CGRectGetMidX(self.frame)-50, CGRectGetMidY(self.frame)+2)];
    [self addChild:self.soundTitle];

    
}

-(void) addVibrateTitle{
    
    self.vibrateTitle = [SKLabelNode labelNodeWithFontNamed:@"Times New Roman"];
    [self.vibrateTitle setText:@"Vibrate"];
    [self.vibrateTitle setFontSize:24];
    self.vibrateTitle.fontColor =[UIColor colorWithRed:0/255.0f green:102/255.0f blue:51/255.0f alpha:1.0f];
    [self.vibrateTitle setPosition:CGPointMake(CGRectGetMidX(self.frame)-50, CGRectGetMidY(self.frame)-75)];
    [self addChild:self.vibrateTitle];
    
    
}

-(void) addPlayerNameTitle{
    
    self.playerNameTitle = [SKLabelNode labelNodeWithFontNamed:@"Times New Roman"];
    [self.playerNameTitle setText:@"Player Name"];
    [self.playerNameTitle setFontSize:24];
    self.playerNameTitle.fontColor =[UIColor colorWithRed:0/255.0f green:102/255.0f blue:51/255.0f alpha:1.0f];
    [self.playerNameTitle setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+150)];
    [self addChild:self.playerNameTitle];
    
    
}

-(void) addBackMenuButton{
    
    
    self.backMenuButton = [SKSpriteNode spriteNodeWithImageNamed:@"menuButton"];
    self.backMenuButton.position = CGPointMake(70, CGRectGetMinY(self.frame)+50);
    self.backMenuButton.name = @"backMenuButton";
    [self addChild:self.backMenuButton];
}

#pragma Actions Methods

-(void) flipMusicAndSound{
    
    if (self.vibrateSwitch.on) {
        [self.userDefaults setInteger:1 forKey:@"vibrate"];
    }
    else {
        [self.userDefaults setInteger:0 forKey:@"vibrate"];
    }
    
    if (self.soundSwitch.on) {
        [self.userDefaults  setInteger:1 forKey:@"sound"];
    }
    else {
        [self.userDefaults  setInteger:0 forKey:@"sound"];
    }
    
    
}

@end
