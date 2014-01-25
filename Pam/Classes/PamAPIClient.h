#import "AFIncrementalStore.h"
#import "AFRestClient.h"

@interface PamAPIClient : AFRESTClient <AFIncrementalStoreHTTPClient>

+ (PamAPIClient *)sharedClient;

@end
