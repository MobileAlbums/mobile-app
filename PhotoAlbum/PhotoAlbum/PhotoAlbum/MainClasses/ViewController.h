

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController<UIAlertViewDelegate,UIActionSheetDelegate>{

    NSArray *sb;
}
@property(nonatomic,assign,readwrite) NSMutableArray *items;
@property(nonatomic,assign,readwrite) NSMutableArray *datas;
@property(nonatomic,assign,readwrite) NSMutableArray *albumNames;
@property(nonatomic,assign,readwrite) NSMutableArray *albumIds;
@end
