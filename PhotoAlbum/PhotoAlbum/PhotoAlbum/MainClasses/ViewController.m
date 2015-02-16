

#import "ViewController.h"
#import "CollectionViewController.h"
#import "PHViewController.h"
#import "UIImage+Crop.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@interface ViewController (){
    UIBarButtonItem *addButtonItem;
    UIBarButtonItem *bjbuttonItem;
    UIBarButtonItem *doneButtonItem;
}
-(void)addButtonClicked:(id)sender;
-(void)clickbjbutton:(id)sender;
-(void)doneButtonClicked:(id)sender;

@end

@implementation ViewController

@synthesize albumNames;
@synthesize items;
@synthesize datas;
@synthesize albumIds;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Albums";
    self.navigationController.navigationBar.tintColor=[UIColor grayColor];
    self.navigationController.title=@"Alan's Albums";
    self.tableView.backgroundColor=[UIColor whiteColor];
    
    addButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClicked:)];
    addButtonItem.tintColor=[UIColor blackColor];
    bjbuttonItem=[[UIBarButtonItem alloc]initWithTitle:@"None" style:UIBarButtonItemStyleBordered target:self action:@selector(clickbjbutton:)];
    doneButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonClicked:)];
    doneButtonItem.tintColor=[UIColor blackColor];
    self.navigationItem.leftBarButtonItem=addButtonItem;
    self.navigationItem.rightBarButtonItem=self.editButtonItem;
    self.editButtonItem.tintColor=[UIColor blackColor];
    
    items=[[NSMutableArray alloc]init];
    albumIds=[[NSMutableArray alloc] init];
    albumNames=[[NSMutableArray alloc] init];
    datas=[[NSMutableArray alloc] init];
    
    self.hidesBottomBarWhenPushed=YES;
    //self.navigationController.toolbarHidden=YES;
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.222/alan/album_mng.php"]];
    [request setPostValue:@"index" forKey:@"action"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)addButtonClicked:(id)sender{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"New Album" message:@"Enter a name for this album" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        UITextField *txt=[alertView textFieldAtIndex:0];
        NSString *newAlbumName=txt.text;
        if ([newAlbumName isEqualToString:@""]) {
            newAlbumName=@"New Album";
        }
 
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"default.jpg"]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.222/alan/album_mng.php"]];
        NSData* img_data = UIImageJPEGRepresentation(image, 50);
        [request setData:img_data withFileName:@"xxx.png" andContentType:@"image/jpeg" forKey:@"image"];
        [request setPostValue:@"insert" forKey:@"action"];
        [request setPostValue:newAlbumName forKey:@"name"];
        [request setDelegate:self];
        [request startAsynchronous];
        
        [albumNames addObject:newAlbumName];

        //NSIndexPath *indexpath=[NSIndexPath indexPathForRow:[items count]-1 inSection:0];
        //[self.tableView insertRowsAtIndexPaths:@[indexpath] withRowAnimation:(UITableViewRowAnimationFade)];
    }
}
-(void)clickbjbutton:(id)sender{
    [self setEditing:YES animated:YES];
}
-(void)doneButtonClicked:(id)sender{
    [self setEditing:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]){
        return 80.0f;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
//    cell.detailTextLabel.text=@"detail";
    NSString *fileName = [items objectAtIndex:indexPath.row];
    cell.textLabel.text = [albumNames objectAtIndex:indexPath.row];
    
    NSString *imageURL = [NSString stringWithFormat:@"http://192.168.1.222/alan/albums/%@",fileName];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    cell.imageView.image = [UIImage returnImage:image withSize:CGSizeMake(80, 80)];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

NSInteger row=0,seco=0;
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        row=indexPath.row;
        seco=indexPath.section;
        UIActionSheet *actio=[[UIActionSheet alloc]initWithTitle:@"Are you sure want to delete the album?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Album" otherButtonTitles:nil];
        [actio showInView:self.view];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSIndexPath *index=[NSIndexPath indexPathForRow:row inSection:seco];
    if (buttonIndex==0) {
        [items removeObjectAtIndex:row];
        [albumNames removeObjectAtIndex:row];
        [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.222/alan/album_mng.php"]];
        [request setPostValue:[albumIds objectAtIndex:row] forKey:@"id"];
        [request setPostValue:@"delete" forKey:@"action"];
        [request setDelegate:self];
        [request startAsynchronous];
        
        [albumIds removeObjectAtIndex:row];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [items exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    sb=[items objectAtIndex:indexPath.row];
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.itemSize=CGSizeMake(90, 90);
    CollectionViewController *coll=[[[CollectionViewController alloc]initWithCollectionViewLayout:layout] autorelease];
    //coll.items2=items;
    coll.albumViewController=self;
    coll.selectedAlbumTableViewIndex=indexPath.row;
    [self.navigationController pushViewController:coll animated:YES];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    if (request.responseStatusCode == 200) {
        NSString *str =[request responseString];
          // NSLog(@"%@",str);
        if ([str rangeOfString:@"insert"].location != NSNotFound){
            NSDictionary* dict = [str JSONValue];
            datas = (NSMutableArray*)dict;
            [albumIds addObject:[datas valueForKey:@"maxid"]];
            [items addObject:[datas valueForKey:@"imagename"]];
            [self.tableView reloadData];
            NSLog(@"%@",[datas valueForKey:@"action"]);
        }
        else if ([str rangeOfString:@"delete"].location != NSNotFound){
            NSDictionary* dict = [str JSONValue];
            datas = (NSMutableArray*)dict;
            NSLog(@"%@",[datas valueForKey:@"action"]);
        }
        else {
            NSDictionary* dict = [str JSONValue];
            datas = (NSMutableArray*)dict;
       
            int n=0;
            NSMutableArray *values;
            while (n < [datas count]) {
                values = [datas objectAtIndex:n];
                [items addObject:[values valueForKey:@"filename"]];
                [albumNames addObject:[values valueForKey:@"name"]];
                [albumIds addObject:[values valueForKey:@"id"]];
                n++;
            }
            [self.tableView reloadData];
           // NSLog(@"%@",albumIds);
           // NSLog(@"%@",albumNames);
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection error", nil) message:NSLocalizedString(@"messageConnectionError", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection error", nil) message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}

//Array
//(
// [name] => image.png
// [type] => image/jpeg
// [tmp_name] => E:\wamp\tmp\phpA561.tmp
// [error] => 0
// [size] => 667011
// )

@end
