# Getting Started with GCM

Follow these steps to properly configure your Titanium application to use GCM as the transport for Urban Airship push notifications.

*NOTE*

You will not need to make the changes to the AndroidManifest.xml that you see in the setup guide. This will be done for you automatically during the application build process.

## Step 1: Get your API Key from Google

1. Go to the [Google API Console](https://code.google.com/apis/console)
2. Create a project (note the Project Number -- you will need it in step 3 below)
3. Enable GCM (Google Cloud Messaging for Android)
4. Generate an API key
    - Click on the text where it says "Google Cloud Messaging for Android" in the image above.
    - This takes you to the Google APIs page.  Click on API Access.
    - Urban Airship takes care of API Access authorization for you, so you do not need to create an OAuth 2.0 client ID.
    - Click on "Create a new Server key..." to generate your API Key.
    - Do not specify any IP addresses in the form, and click "Create"
    - Copy your key for server apps

## Step 2: Setting things up with Urban Airship

Set the GCM API Key for your application in the Urban Airship console.

* Navigate to [http://go.urbanairship.com](http://go.urbanairship.com)
* Edit you application and enter the Android Package name and GCM Api Key that was just generated

## Step 3: Configure GCM Transport

Set the Urban Airship options in your airshipconfig.properties file to use the GCM transport.

* Set the "transport" option to "gcm"
* Set the "gcmSender" option to your Google API project number

<pre>
  transport = gcm
  gcmSender = 12345678901
</pre>

## Important Notes

* Device must be running Android 2.2 or higher that also have the Market application installed
* Device must have at least one logged in Google account. "Settings > Account & sync"

## GCM Documentation

* [UrbanAirship Getting Started: Android: GCM Push](https://docs.urbanairship.com/display/DOCS/Getting+Started%3A+Android%3A+GCM+Push)
* [Google's Cloud Messaging for Android](http://developer.android.com/google/gcm/index.html)


