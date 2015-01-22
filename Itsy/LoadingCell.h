//
//  LoadingCell.h
//  Itsy
//
//  Created by Michael Cornell on 1/21/15.
//  Copyright (c) 2015 Michael Cornell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
+(CGFloat)cellHeight;
@end
