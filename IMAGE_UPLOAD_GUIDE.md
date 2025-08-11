# Image Upload Guide for CarsNan App

## Service Banner Images (Multiple carousel images shown at the top of service details)
Place these images in organized folders under: `assets/images/services/banners/`

### General Wash Service (3 images):
- `assets/images/services/banners/general/banner1.png` - Main banner for General Wash service
- `assets/images/services/banners/general/banner2.png` - Second image showing washing process
- `assets/images/services/banners/general/banner3.png` - Third image showing finished result

### Premium Wash Service (3 images):
- `assets/images/services/banners/premium/banner1.png` - Main banner for Premium Wash service  
- `assets/images/services/banners/premium/banner2.png` - Second image showing foam wash
- `assets/images/services/banners/premium/banner3.png` - Third image showing interior detailing

### Luxury Wash Service (3 images):
- `assets/images/services/banners/luxury/banner1.png` - Main banner for Luxury Wash service
- `assets/images/services/banners/luxury/banner2.png` - Second image showing paint protection
- `assets/images/services/banners/luxury/banner3.png` - Third image showing leather conditioning

**Recommended size:** 400x250 pixels (landscape orientation)

### Image Carousel Features:
- **Multiple Images**: Each service has 3 banner images that users can browse through
- **Navigation**: Users can tap left/right areas or swipe to navigate between images
- **Dot Indicators**: White dots at the bottom show current image position
- **Smooth Transitions**: Images transition smoothly with animation
- **Auto-fit**: If images are missing, beautiful gradient backgrounds with service icons are shown
- **Organized Structure**: Images are now organized in service-specific folders for better management

## Service Item Images (Small cards in "What's Included" section)
Place these images in: `assets/images/service_items/`

### General Wash Service Items:
- `exterior_wash.jpg` - Image showing exterior car washing
- `interior_vacuum.jpg` - Image showing interior vacuuming
- `tire_check.jpg` - Image showing tire inspection
- `basic_inspection.jpg` - Image showing basic car inspection

### Premium Wash Service Items:
- `foam_wash.jpg` - Image showing foam washing process
- `interior_detail.jpg` - Image showing detailed interior cleaning
- `engine_clean.jpg` - Image showing engine bay cleaning
- `wax_polish.jpg` - Image showing car waxing/polishing
- `oil_change.jpg` - Image showing oil change service

### Luxury Wash Service Items:
- `full_detailing.jpg` - Image showing complete car detailing
- `paint_protection.jpg` - Image showing paint protection application
- `leather_care.jpg` - Image showing leather seat conditioning
- `premium_wax.jpg` - Image showing premium wax application
- `engine_detail.jpg` - Image showing detailed engine cleaning
- `tire_polish.jpg` - Image showing tire polishing

**Recommended size:** 120x80 pixels (landscape orientation)

## Image Formats
- Supported formats: `.jpg`, `.jpeg`, `.png`, `.webp`
- For best performance, use `.jpg` for photos and `.png` for images with transparency

## After Adding Images
1. Add your images to the respective folders
2. Run `flutter clean && flutter pub get` to refresh assets
3. Hot restart the app to see your new images

## Fallback Behavior
If an image is not found, the app will automatically show:
- A gradient background with appropriate colors for each service type
- Relevant icons based on the service item type

## Notes
- Make sure image file names match exactly (case-sensitive)
- Keep image file sizes reasonable (under 500KB each) for better app performance
- Use high-quality images for better user experience
