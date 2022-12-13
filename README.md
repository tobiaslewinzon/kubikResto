# kubikResto

## iOS code challenge

### Building instructions:
- Clone or download as zip
- run 'pod install'
- Individual tests files found in /KubikResto/KubikRestoTests

## Description of choices and potential difficulties.

### The implementation of CoreData to store images temporarily
- Given the chance that the JSON returns hundreds of Restaurants, I thought that storing image data in CoreData is the safest way to avoid UI lagginess when scrolling.
- Besides encapsulating the image in an object that can hold other important properties such as the downloadStatus string.

### The implementation of a background thread and a dispatch group to download images
- The background thread will allow for image API calls to happen asyncronycally without lagging the UI. The implementation of the dispatch group allows for performing uploads in a sequence ensuring the previous one is finished before moving to the next one.

### The implementation of CoreData to store UUIDs of favorited places.
- Relying on a storage option that persists between sessions and allows saving of custom objects. In the future, the RestaurantFavorite object is scalable onto anything, like for example bookmarking a Restaurant so the whole object is available offline.

### The addition of loading spinners and placeholder images
- I think it's basic UX, even of a simple app like this, to inform the user of the status of thumbail downloads. By pulling to refresh the user can appreciate how the work is done in the background while the view refreshes automatically.

### Pod OHHTTPStubs to fake Unit Tests calls
- My favorite library to fake API calls. Very easy to use and powerfull tool that allows the dev to return custom responses with fixed data such as JSONs or JPEG images. The library automatically intercepts calls on the background, so once the conditions are set, the test can just call the service in question normally.
