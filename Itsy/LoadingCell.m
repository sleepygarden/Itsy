//
//  LoadingCell.m
//  Itsy
//
//  Created by Michael Cornell on 1/21/15.
//  Copyright (c) 2015 Michael Cornell. All rights reserved.
//

#import "LoadingCell.h"
#import "ItsyStyles.h"
@implementation LoadingCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.loadingLabel.font = Sanchez(17);
    self.loadingLabel.textColor = itsyBlack;
    self.backgroundColor = itsyOrange;
    [self.spinner startAnimating];
}

+(CGFloat)cellHeight {
    return 44;
}

@end
