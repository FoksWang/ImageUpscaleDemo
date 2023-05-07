# ImageUpscaleDemo

ImageUpscaleDemo is a SwiftUI iOS app that showcases real-time image upscaling and enhancement using Core Image filters, providing an interactive interface for fine-tuning and comparing results.

![ImageUpscaleDemo Screenshot](https://github.com/FoksWang/ImageUpscaleDemo/blob/main/Demo/ImageUpscaleDemo.png?raw=true)

## Demo

[![ImageUpscaleDemo Video](https://img.youtube.com/vi/IMAGE_UPSCALE_DEMO_VIDEO_ID/0.jpg)](https://github.com/FoksWang/ImageUpscaleDemo/raw/main/Demo/ImageUpscaleDemo.mp4)

Click on the image above to watch the video demo.

## Features

- Load images from URLs
- Integration of Kingfisher for image caching (optional)
- Apply various Core Image filters to enhance image quality:
  - Lanczos scale transform for upscaling
  - Noise reduction
  - Unsharp mask
  - Median filter
- Interactive sliders for adjusting filter parameters
- Compare original and enhanced images side by side

## Kingfisher Integration

Using Kingfisher in the Demo app is optional. The main purpose of introducing Kingfisher is for caching images. When the image is not in the cache, the app fetches the image from the provided URL and processes it. If the image is already in the cache, there's no need to read it remotely, speeding up the image enhancement process.

## Requirements

- iOS 15.0 or later
- Xcode 13.0 or later
- SwiftUI 3.0 or later

## Installation

1. Clone the repository:
```bash
    git clone https://github.com/FoksWang/ImageUpscaleDemo.git
```

2. Open `ImageUpscaleDemo.xcodeproj` with Xcode.

3. Run the app on a simulator or an iOS device.

## Usage

1. Replace the `imageUrl` in `ContentView` with a URL of your choice.

2. Press the "Adjust Image" button to reveal the filter adjustment sliders.

3. Adjust the sliders for noise level, sharpness, unsharp mask radius, and unsharp mask intensity to enhance the image quality.

4. Compare the original and enhanced images.

## Contributing

1. Fork the project.
2. Create a new branch (`git checkout -b featureBranch`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin featureBranch`).
5. Create a new Pull Request.

## License

ImageUpscaleDemo is available under the MIT License. See the `LICENSE` file for more information.
