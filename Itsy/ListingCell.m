//
//  ListingCell.m
//  Itsy
//
//  Created by Michael Cornell on 1/21/15.
//  Copyright (c) 2015 Michael Cornell. All rights reserved.
//

#import "ListingCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "ItsyStyles.h"
@implementation ListingCell

- (void)awakeFromNib {
    self.containerView.layer.cornerRadius = 5;
    self.containerView.layer.masksToBounds = YES;
    
    self.titleLabel.font = Sanchez(17);
    self.titleLabel.textColor = itsyBlack;
    
    self.favLabel.font = Sanchez(17);
    self.favLabel.textColor = itsyBlack;
    
    self.titleContainer.backgroundColor = [itsyWhite colorWithAlphaComponent:.65];
    self.favContainer.backgroundColor = [itsyWhite colorWithAlphaComponent:.65];
    
    self.backgroundColor = [UIColor clearColor];
    self.containerView.backgroundColor = itsyWhite;
    self.listingImage.backgroundColor = itsyWhite;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected){
        self.containerView.backgroundColor = [UIColor colorWithRed:.95 green:.8 blue:.8 alpha:1];
    }
    else {
        self.containerView.backgroundColor = [UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1];
    }
}

-(void)setupWithListing:(Listing*)listing {
    self.favLabel.text = [NSString stringWithFormat:@"%lu",listing.favorers];
    self.titleLabel.text = listing.title;    
    [self.listingImage setImageWithURL:listing.imgURL placeholderImage:[UIImage imageNamed:@"ScreenShot"]];
    
}

+(CGFloat)cellHeight {
    return 330;
}

@end
