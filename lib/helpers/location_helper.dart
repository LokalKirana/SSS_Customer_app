const GOOGLE_API_KEY = "AIzaSyD8OG3WpyZf2J8U2Iq6-itZnDLHC0vpa00";

class LocationHelper {
  static String generateLocationPreviewImage({
    double latitude,
    double longitude,
  }) =>
      'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
}
