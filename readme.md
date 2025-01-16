# Giphy iOS Application

This is a Swift-based iOS application that integrates with the Giphy API to search and display GIFs. The project is designed with modern architecture, responsive UI, and robust error handling.

## Project Requirements

### Technical
- **Language:** Swift
- **Auto Search:** Search requests are performed after a brief delay when the user stops typing.
- **Infinite Scrolling:** Automatically loads more results when scrolling to the bottom of the list.
- **Networking Layer:** Built without using third-party libraries (e.g., Alamofire), utilizing `URLSession` for HTTP requests.
- **Comments:** Key sections of the code are documented for clarity and maintainability.
- **Orientation Support:** Supports both vertical and horizontal device orientations.
- **Error Handling:** Comprehensive handling of network errors and invalid data.
- **Unit Testing:** Includes unit tests for core functionality using `XCTest`.

### UI
- **Views:** Two main views sourcing data from the Giphy API (Trending and Search).
- **Grid Layout:** GIFs are displayed in a scrollable grid using `UICollectionView`.
- **Detailed View:** Tapping a GIF navigates to a detailed view with additional information.
- **Loading Indicators:** Visual indicators show loading status.
- **Error Display:** User-friendly error messages appear for failures.

## Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/giphy-app.git```

2. Create a secret-config.plist with your Giphy API key

## Example Code

1. Fetching Trending GIFs:
   ```bash
   let trendingGifs = try await imageService.fetchTrendingImages()
   ```

2. Searching GIFs:
   ```bash
   let searchResults = try await imageService.fetchBySearchQuery(prompt: "funny")
   ```
