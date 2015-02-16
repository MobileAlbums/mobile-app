

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface CollectionViewController : UICollectionViewController<UICollectionViewDelegate,UIActionSheetDelegate>{

}
@property(nonatomic,assign,readwrite) NSMutableArray *items2;
@property(nonatomic,assign,readwrite) NSMutableArray *pictureNames;
@property(nonatomic,assign,readwrite) ViewController *albumViewController;
@property(nonatomic,assign,readwrite) NSInteger selectedAlbumTableViewIndex;
@property(nonatomic,assign,readwrite) NSMutableArray *datas;
@property(nonatomic,assign,readwrite) NSMutableArray *pictureIds;

-(void)clickbutton:(id)sender;
-(void)clickaction:(id)sender;
-(void)clickcancel:(id)sender;
-(void)clickdelete:(id)sender;
-(void)clickaddto:(id)sender;
-(void)clickshare:(id)sender;
@end
