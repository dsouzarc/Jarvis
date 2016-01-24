#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PVAttractionAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end