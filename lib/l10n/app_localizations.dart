import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Seyaha'**
  String get appTitle;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @companies.
  ///
  /// In en, this message translates to:
  /// **'Companies'**
  String get companies;

  /// No description provided for @historical.
  ///
  /// In en, this message translates to:
  /// **'Historical'**
  String get historical;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @tripPlans.
  ///
  /// In en, this message translates to:
  /// **'Trip Plans'**
  String get tripPlans;

  /// No description provided for @searchDestinations.
  ///
  /// In en, this message translates to:
  /// **'Search destinations…'**
  String get searchDestinations;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @browseByCategory.
  ///
  /// In en, this message translates to:
  /// **'Browse by Category'**
  String get browseByCategory;

  /// No description provided for @popularThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Popular This Week'**
  String get popularThisWeek;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get addToFavorites;

  /// No description provided for @myFavorites.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get myFavorites;

  /// No description provided for @hiTraveller.
  ///
  /// In en, this message translates to:
  /// **'Hi, Traveller'**
  String get hiTraveller;

  /// No description provided for @signInForFullAccess.
  ///
  /// In en, this message translates to:
  /// **'Sign in for full access'**
  String get signInForFullAccess;

  /// No description provided for @whereToNext.
  ///
  /// In en, this message translates to:
  /// **'Where to next?'**
  String get whereToNext;

  /// No description provided for @discoverYour.
  ///
  /// In en, this message translates to:
  /// **'Discover Your'**
  String get discoverYour;

  /// No description provided for @dreamGetaway.
  ///
  /// In en, this message translates to:
  /// **'Dream Getaway'**
  String get dreamGetaway;

  /// No description provided for @trendingServices.
  ///
  /// In en, this message translates to:
  /// **'Trending Services'**
  String get trendingServices;

  /// No description provided for @ancientHistory.
  ///
  /// In en, this message translates to:
  /// **'Ancient History'**
  String get ancientHistory;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRange;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found.'**
  String get noResults;

  /// No description provided for @trips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get trips;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About Seyaha'**
  String get aboutApp;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @noFavoritesYet.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get noFavoritesYet;

  /// No description provided for @startExploringFavorites.
  ///
  /// In en, this message translates to:
  /// **'Start exploring and save your favorite places!'**
  String get startExploringFavorites;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @perPerson.
  ///
  /// In en, this message translates to:
  /// **'Per person'**
  String get perPerson;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @categoryHotels.
  ///
  /// In en, this message translates to:
  /// **'Hotels'**
  String get categoryHotels;

  /// No description provided for @categoryApartments.
  ///
  /// In en, this message translates to:
  /// **'Apartments'**
  String get categoryApartments;

  /// No description provided for @categoryTours.
  ///
  /// In en, this message translates to:
  /// **'Tours'**
  String get categoryTours;

  /// No description provided for @categoryCars.
  ///
  /// In en, this message translates to:
  /// **'Cars'**
  String get categoryCars;

  /// No description provided for @aiGuide.
  ///
  /// In en, this message translates to:
  /// **'Ask AI Guide'**
  String get aiGuide;

  /// No description provided for @askAI.
  ///
  /// In en, this message translates to:
  /// **'Ask about Egypt...'**
  String get askAI;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @trackManageTrips.
  ///
  /// In en, this message translates to:
  /// **'Track and manage your trips'**
  String get trackManageTrips;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @noUpcomingTrips.
  ///
  /// In en, this message translates to:
  /// **'No upcoming trips yet'**
  String get noUpcomingTrips;

  /// No description provided for @noPastTrips.
  ///
  /// In en, this message translates to:
  /// **'No past trips'**
  String get noPastTrips;

  /// No description provided for @noCancelledBookings.
  ///
  /// In en, this message translates to:
  /// **'No cancelled bookings'**
  String get noCancelledBookings;

  /// No description provided for @failedLoadBookings.
  ///
  /// In en, this message translates to:
  /// **'Failed to load bookings'**
  String get failedLoadBookings;

  /// No description provided for @exploreToStart.
  ///
  /// In en, this message translates to:
  /// **'Explore services to start your journey'**
  String get exploreToStart;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @tripDetails.
  ///
  /// In en, this message translates to:
  /// **'Trip Details'**
  String get tripDetails;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get checkIn;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check-out'**
  String get checkOut;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @assignedTraveler.
  ///
  /// In en, this message translates to:
  /// **'Assigned Traveler'**
  String get assignedTraveler;

  /// No description provided for @assignedToMe.
  ///
  /// In en, this message translates to:
  /// **'ASSIGNED TO ME'**
  String get assignedToMe;

  /// No description provided for @traveler.
  ///
  /// In en, this message translates to:
  /// **'Traveler'**
  String get traveler;

  /// No description provided for @discoverWorld.
  ///
  /// In en, this message translates to:
  /// **'Discover\nthe World'**
  String get discoverWorld;

  /// No description provided for @createAccountJourney.
  ///
  /// In en, this message translates to:
  /// **'Create an account to start your journey.'**
  String get createAccountJourney;

  /// No description provided for @signInAdventure.
  ///
  /// In en, this message translates to:
  /// **'Sign in to start your next adventure\nwith SeYaha.'**
  String get signInAdventure;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @registerAs.
  ///
  /// In en, this message translates to:
  /// **'Register as'**
  String get registerAs;

  /// No description provided for @traveller.
  ///
  /// In en, this message translates to:
  /// **'Traveller'**
  String get traveller;

  /// No description provided for @manager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get manager;

  /// No description provided for @tourGuide.
  ///
  /// In en, this message translates to:
  /// **'Tour Guide'**
  String get tourGuide;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company name'**
  String get companyName;

  /// No description provided for @companyDescription.
  ///
  /// In en, this message translates to:
  /// **'Company description'**
  String get companyDescription;

  /// No description provided for @companyAddress.
  ///
  /// In en, this message translates to:
  /// **'Company Address'**
  String get companyAddress;

  /// No description provided for @companyPhone.
  ///
  /// In en, this message translates to:
  /// **'Company Phone'**
  String get companyPhone;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @justBrowsing.
  ///
  /// In en, this message translates to:
  /// **'Just browsing? '**
  String get justBrowsing;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @findNextExperience.
  ///
  /// In en, this message translates to:
  /// **'Find your next unforgettable experience'**
  String get findNextExperience;

  /// No description provided for @couldNotLoadServices.
  ///
  /// In en, this message translates to:
  /// **'Could not load services'**
  String get couldNotLoadServices;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @desktopFiltersSoon.
  ///
  /// In en, this message translates to:
  /// **'Desktop filters coming soon'**
  String get desktopFiltersSoon;

  /// No description provided for @hotels.
  ///
  /// In en, this message translates to:
  /// **'Hotels'**
  String get hotels;

  /// No description provided for @apartments.
  ///
  /// In en, this message translates to:
  /// **'Apartments'**
  String get apartments;

  /// No description provided for @tours.
  ///
  /// In en, this message translates to:
  /// **'Tours'**
  String get tours;

  /// No description provided for @cars.
  ///
  /// In en, this message translates to:
  /// **'Cars'**
  String get cars;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @signInRequired.
  ///
  /// In en, this message translates to:
  /// **'Sign In Required'**
  String get signInRequired;

  /// No description provided for @signInRequiredMsg.
  ///
  /// In en, this message translates to:
  /// **'You need to create an account or sign in to perform this action.'**
  String get signInRequiredMsg;

  /// No description provided for @maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get maybeLater;

  /// No description provided for @askAiGuide.
  ///
  /// In en, this message translates to:
  /// **'Ask AI Guide'**
  String get askAiGuide;

  /// No description provided for @guestExplorer.
  ///
  /// In en, this message translates to:
  /// **'Guest Explorer'**
  String get guestExplorer;

  /// No description provided for @signInFullAccess.
  ///
  /// In en, this message translates to:
  /// **'Sign in for full access'**
  String get signInFullAccess;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @administrator.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get administrator;

  /// No description provided for @tourGuideLabel.
  ///
  /// In en, this message translates to:
  /// **'Tour Guide'**
  String get tourGuideLabel;

  /// No description provided for @travellerLabel.
  ///
  /// In en, this message translates to:
  /// **'Traveller'**
  String get travellerLabel;

  /// No description provided for @guestLabel.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guestLabel;

  /// No description provided for @guides.
  ///
  /// In en, this message translates to:
  /// **'Guides'**
  String get guides;

  /// No description provided for @dashboardOverview.
  ///
  /// In en, this message translates to:
  /// **'Dashboard Overview'**
  String get dashboardOverview;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}'**
  String welcomeBack(Object name);

  /// No description provided for @revenueStatus.
  ///
  /// In en, this message translates to:
  /// **'Revenue Status'**
  String get revenueStatus;

  /// No description provided for @revenueNote.
  ///
  /// In en, this message translates to:
  /// **'Estimated from confirmed bookings'**
  String get revenueNote;

  /// No description provided for @activeServices.
  ///
  /// In en, this message translates to:
  /// **'Active Services'**
  String get activeServices;

  /// No description provided for @totalBookings.
  ///
  /// In en, this message translates to:
  /// **'Total Bookings'**
  String get totalBookings;

  /// No description provided for @netRevenue.
  ///
  /// In en, this message translates to:
  /// **'Net Revenue'**
  String get netRevenue;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @addTrip.
  ///
  /// In en, this message translates to:
  /// **'Add Trip'**
  String get addTrip;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @accountPendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Account Pending Approval'**
  String get accountPendingApproval;

  /// No description provided for @accountUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Your company is currently under review. You will be able to post services once an admin approves your request.'**
  String get accountUnderReview;

  /// No description provided for @recentActivities.
  ///
  /// In en, this message translates to:
  /// **'Recent Activities'**
  String get recentActivities;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @noRecentBookings.
  ///
  /// In en, this message translates to:
  /// **'No recent bookings found.'**
  String get noRecentBookings;

  /// No description provided for @bookingLabel.
  ///
  /// In en, this message translates to:
  /// **'Booking: {title}'**
  String bookingLabel(Object title);

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String statusLabel(Object status);

  /// No description provided for @serviceReviews.
  ///
  /// In en, this message translates to:
  /// **'Service Reviews'**
  String get serviceReviews;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet.'**
  String get noReviewsYet;

  /// No description provided for @onService.
  ///
  /// In en, this message translates to:
  /// **'On: {title}'**
  String onService(Object title);

  /// No description provided for @companyLabel.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get companyLabel;

  /// No description provided for @addTripPlan.
  ///
  /// In en, this message translates to:
  /// **'Add Trip Plan'**
  String get addTripPlan;

  /// No description provided for @myTripPlans.
  ///
  /// In en, this message translates to:
  /// **'My Trip Plans'**
  String get myTripPlans;

  /// No description provided for @noDataAddFirst.
  ///
  /// In en, this message translates to:
  /// **'There is no data. Add your first trip plan!'**
  String get noDataAddFirst;

  /// No description provided for @editTrip.
  ///
  /// In en, this message translates to:
  /// **'Edit Trip'**
  String get editTrip;

  /// No description provided for @deleteTrip.
  ///
  /// In en, this message translates to:
  /// **'Delete Trip'**
  String get deleteTrip;

  /// No description provided for @deleteTripQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete Trip Plan?'**
  String get deleteTripQuestion;

  /// No description provided for @deleteTripConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"? This action cannot be undone.'**
  String deleteTripConfirm(Object title);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @tripDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Trip Plan deleted successfully'**
  String get tripDeletedSuccess;

  /// No description provided for @newTripPlan.
  ///
  /// In en, this message translates to:
  /// **'New Trip Plan'**
  String get newTripPlan;

  /// No description provided for @titleWithStar.
  ///
  /// In en, this message translates to:
  /// **'Title*'**
  String get titleWithStar;

  /// No description provided for @descriptionWithStar.
  ///
  /// In en, this message translates to:
  /// **'Description*'**
  String get descriptionWithStar;

  /// No description provided for @priceWithStar.
  ///
  /// In en, this message translates to:
  /// **'Price*'**
  String get priceWithStar;

  /// No description provided for @locationPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Location (e.g. Cairo)*'**
  String get locationPlaceholder;

  /// No description provided for @selectCategoryWithStar.
  ///
  /// In en, this message translates to:
  /// **'Select Category*'**
  String get selectCategoryWithStar;

  /// No description provided for @selectTourGuideOptional.
  ///
  /// In en, this message translates to:
  /// **'Select Tour Guide (Optional)'**
  String get selectTourGuideOptional;

  /// No description provided for @guideLabel.
  ///
  /// In en, this message translates to:
  /// **'Guide: {name}'**
  String guideLabel(Object name);

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// No description provided for @imageUrl.
  ///
  /// In en, this message translates to:
  /// **'Image URL'**
  String get imageUrl;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @allFieldsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields.'**
  String get allFieldsRequired;

  /// No description provided for @tripPlanUpdated.
  ///
  /// In en, this message translates to:
  /// **'Trip Plan updated successfully!'**
  String get tripPlanUpdated;

  /// No description provided for @tripPlanCreated.
  ///
  /// In en, this message translates to:
  /// **'Trip Plan created successfully!'**
  String get tripPlanCreated;

  /// No description provided for @pendingApprovalMsg.
  ///
  /// In en, this message translates to:
  /// **'Your company is pending admin approval. You cannot add services yet.'**
  String get pendingApprovalMsg;

  /// No description provided for @appointGuide.
  ///
  /// In en, this message translates to:
  /// **'Appoint Guide'**
  String get appointGuide;

  /// No description provided for @noGuidesFound.
  ///
  /// In en, this message translates to:
  /// **'No guides found in the system.'**
  String get noGuidesFound;

  /// No description provided for @certified.
  ///
  /// In en, this message translates to:
  /// **'Certified'**
  String get certified;

  /// No description provided for @messageGuide.
  ///
  /// In en, this message translates to:
  /// **'Message Guide'**
  String get messageGuide;

  /// No description provided for @chatWithGuide.
  ///
  /// In en, this message translates to:
  /// **'Chat with {name}'**
  String chatWithGuide(Object name);

  /// No description provided for @manageBookings.
  ///
  /// In en, this message translates to:
  /// **'Manage Bookings'**
  String get manageBookings;

  /// No description provided for @noBookingsYet.
  ///
  /// In en, this message translates to:
  /// **'There are no bookings yet.'**
  String get noBookingsYet;

  /// No description provided for @bookingIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Booking #{id}'**
  String bookingIdLabel(Object id);

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @assignGuide.
  ///
  /// In en, this message translates to:
  /// **'Assign Guide'**
  String get assignGuide;

  /// No description provided for @changeGuide.
  ///
  /// In en, this message translates to:
  /// **'Change Guide'**
  String get changeGuide;

  /// No description provided for @bookingConfirmedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed successfully'**
  String get bookingConfirmedSuccess;

  /// No description provided for @bookingRejectedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking rejected successfully'**
  String get bookingRejectedSuccess;

  /// No description provided for @guideAssignedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Tour guide assigned successfully'**
  String get guideAssignedSuccess;

  /// No description provided for @adminOverview.
  ///
  /// In en, this message translates to:
  /// **'Admin Overview'**
  String get adminOverview;

  /// No description provided for @addCompany.
  ///
  /// In en, this message translates to:
  /// **'Add Company'**
  String get addCompany;

  /// No description provided for @totalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get totalUsers;

  /// No description provided for @revenueOverview.
  ///
  /// In en, this message translates to:
  /// **'Revenue Overview'**
  String get revenueOverview;

  /// No description provided for @recentFeedback.
  ///
  /// In en, this message translates to:
  /// **'Recent Feedback'**
  String get recentFeedback;

  /// No description provided for @userManagement.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get userManagement;

  /// No description provided for @searchUsersHint.
  ///
  /// In en, this message translates to:
  /// **'Search users by name, email or role...'**
  String get searchUsersHint;

  /// No description provided for @noUsersRegistered.
  ///
  /// In en, this message translates to:
  /// **'No users registered yet.'**
  String get noUsersRegistered;

  /// No description provided for @noUsersFoundMatching.
  ///
  /// In en, this message translates to:
  /// **'No users found matching \"{query}\"'**
  String noUsersFoundMatching(Object query);

  /// No description provided for @errorLoadingUsers.
  ///
  /// In en, this message translates to:
  /// **'Error loading users: {error}'**
  String errorLoadingUsers(Object error);

  /// No description provided for @removeUser.
  ///
  /// In en, this message translates to:
  /// **'Remove User'**
  String get removeUser;

  /// No description provided for @removeUserConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {name}? This action cannot be undone.'**
  String removeUserConfirm(Object name);

  /// No description provided for @companyManagement.
  ///
  /// In en, this message translates to:
  /// **'Company Management'**
  String get companyManagement;

  /// No description provided for @pendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending Requests'**
  String get pendingRequests;

  /// No description provided for @allCompanies.
  ///
  /// In en, this message translates to:
  /// **'All Companies'**
  String get allCompanies;

  /// No description provided for @noPendingRequestsFound.
  ///
  /// In en, this message translates to:
  /// **'No pending requests found.'**
  String get noPendingRequestsFound;

  /// No description provided for @noCompaniesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No companies available.'**
  String get noCompaniesAvailable;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @historicalArticles.
  ///
  /// In en, this message translates to:
  /// **'Historical Articles'**
  String get historicalArticles;

  /// No description provided for @noArticlesYet.
  ///
  /// In en, this message translates to:
  /// **'No articles yet. Start by creating one!'**
  String get noArticlesYet;

  /// No description provided for @addArticle.
  ///
  /// In en, this message translates to:
  /// **'Add Article'**
  String get addArticle;

  /// No description provided for @deleteArticle.
  ///
  /// In en, this message translates to:
  /// **'Delete Article'**
  String get deleteArticle;

  /// No description provided for @deleteArticleConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this article?'**
  String get deleteArticleConfirm;

  /// No description provided for @createCompany.
  ///
  /// In en, this message translates to:
  /// **'Create Company'**
  String get createCompany;

  /// No description provided for @companyDetails.
  ///
  /// In en, this message translates to:
  /// **'Company Details'**
  String get companyDetails;

  /// No description provided for @registerServiceProviderHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the details to register a new service provider.'**
  String get registerServiceProviderHint;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @initialPassword.
  ///
  /// In en, this message translates to:
  /// **'Initial Password'**
  String get initialPassword;

  /// No description provided for @min6Chars.
  ///
  /// In en, this message translates to:
  /// **'Min 6 chars required'**
  String get min6Chars;

  /// No description provided for @createCompanyAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Company Account'**
  String get createCompanyAccount;

  /// No description provided for @companyCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Company created successfully!'**
  String get companyCreatedSuccess;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
