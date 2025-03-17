# Earthquake Tracker App

The **Earthquake Tracker App** is a Flutter-based application that fetches and displays real-time earthquake data from the USGS Earthquake API. The app offers dynamic filtering options, location-based data retrieval, and seamless navigation to map details for specific earthquake events.

## Features
- 📋 **Dynamic Earthquake List:** Fetches earthquake data based on customizable query parameters.
- 🗓️ **Date Range Selection:** Users can set a start date and end date using a date picker widget.
- 📈 **Magnitude Filter:** Adjust the minimum magnitude filter for the earthquake list.
- 🌍 **Radius Filter:** Control the search radius with a convenient slider widget.
- 📍 **Location-Based Search:** Fetch earthquake data near your current location (with location permission).
- 🗺️ **Map Navigation:** Clicking on an earthquake item opens its location in Google Maps using the `url_launcher` plugin.

## Dependencies
The app leverages the following Flutter packages:

- [`http`](https://pub.dev/packages/http) - For making network requests to the USGS Earthquake API.
- [`provider`](https://pub.dev/packages/provider) - For state management across widgets.
- [`url_launcher`](https://pub.dev/packages/url_launcher) - To launch URLs for map navigation.
- [`geolocator`](https://pub.dev/packages/geolocator) - For obtaining the user's current location.
- [`intl`](https://pub.dev/packages/intl) - For formatting dates in the UI.
- [`flutter_slidable`](https://pub.dev/packages/flutter_slidable) - For enhanced list interactions (if used).

## Usage
### Settings Page
Adjust the desired query parameters like:
- **Start Date**  
- **End Date**  
- **Minimum Magnitude**  
- **Maximum Radius**  

### Location Access
Grant location access for personalized results.

### View Details
Tap on any earthquake entry to open its location on Google Maps.

## API Reference
The app retrieves data from the following address:
https://earthquake.usgs.gov/fdsnws/event/1/query

## Screenshots
<p align="center">
  <img src="https://github.com/user-attachments/assets/530286b6-3240-4cc9-81ac-6942e982b9f7" width="24%">
  <img src="https://github.com/user-attachments/assets/67fd8094-f51c-4386-89c6-844b933b3c6b" width="24%">
  <img src="https://github.com/user-attachments/assets/daa46601-1494-4a67-8b98-57bbad1c320c" width="24%">
  <img src="https://github.com/user-attachments/assets/370304bc-a419-4245-8380-cc9ff530428d" width="24%">
</p>


