

#import <UIKit/UIKit.h>
#import "CollectionViewController.h"

@interface PhotosController : UIViewController<UIActionSheetDelegate>{
    NSString * picturename;
    IBOutlet UILabel *label;
    IBOutlet UIImageView *imageview;
    int s;
}

@property(nonatomic,assign,readwrite) CollectionViewController *photoCollectionViewController;
@property(nonatomic,assign,readwrite) int selectedPictureIndex;
@property(nonatomic,assign,readwrite) NSMutableArray *items3;
@property(nonatomic,assign,readwrite) NSMutableArray *datas;

-(void)filterButtonClicked:(id)sender;
-(void)deleteButtonClicked:(id)sender;
-(void)shareButtonClicked:(id)sender;
@end
