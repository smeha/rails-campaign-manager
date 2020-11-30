## Installation and Environment Used
* Mac OSX Catalina
* Ruby through brew (the funky way now in Catalina)
  * ruby 2.7.2p137
* Rails 6.0.3.4
* PostgreSQL 13.1
* NodeJS v14.15.1 and Yarn 1.22.10 required for webpacker
* ReactJS 17.0.1
* BootStrap CSS 4.5.2

## Usage

For simple prefilled inputs, use test seeds provided by me: `rails db:seed`

### Unfinished API 
Requires csrf token, in order to check the logged in
* GET `/getuserid` - gets users ID
* POST `/newcampaign` - create new campaign 
* GET `/showcampaign` - displays all campaigns that belong to user
* DELETE `/deletecampaign/:id` - deletes specific campaign specified by ID
* POST `/newbanner` - create new banner 
* GET `/showbanner` - displays all banners that belong to user
* DELETE `/deletebanner/:id` - deletes specific banners specified by ID, attached campaigns will be deleted as well

## Planned Implementation
* Separate API instead of built in to controllers calls
  * Still can be used with crsf login token 
* Images/GIF/Videos need to be added to banner implementation
<br /><br /><br />
## Assignment 
For our test you will be building a super simple advertising platform! This is an application that handles marketing campaigns on the internet. We will have Campaigns that will have banners on them.

In order to be simple, campaigns will only need a name, a start date and an end date.

For the same simplicity, banners will only have a name and the actual text of the banner (no GIFs today).

It doesn't make sense for all campaigns to be displayed at any time of day. For example, campaigns that focus on sports are more effective in the afternoon. So the creator can select at what hours of the day the campaign should be showing banners.

We want that our internal users are able to administer the campaigns and banners in our web application. We don’t want the general public to have access to this.

Additionally, the server needs to provide the actual banners for the sites that are going to show them. For that, it will provide a custom, unprotected, URL, that will be called by the sites. On receiving this request, the application should look for an available banner to show, and, if available, return its text in the body of the response. If no banner is available, it should return a Not Found result. If several banners are available at the moment, it should perform a random selection among them, and return the selected one.

To be simple, the only criteria to decide if a banner is displayable is based on date and time. A campaign is active between the dates of start and end. And for campaigns that are only available in certain hours, that filter should be applied, too. Since not all places in the world have the same time of day we tend to use https://tools.keycdn.com/geo to find the time of day depending on the visitor's IP address.

Take into account that:
* Banners can belong to one or more campaigns
* When a campaign filters by time, we can assume that we will only manage display in complete hours. This means that we can say that it will be displayed at 1pm, 3pm and 7pm but not at 12:30 only.
* For the sake of simplicity, we don’t care about different days of the week. Time filters, if present, apply to all days.
* You can retrieve the date of time of an IP with a request like: https://tools.keycdn.com/geo?host=195.110.64.205 but feel free to use any other service if you prefer.

Expected results:
* A Ruby on Rails API-only application, providing the backend for the service described above.
* A JS standalone application that provides the admin interface connecting to the API (feel free to use any JS library or framework that you prefer).

Additional notes:
* We like clean, efficient code that your teammates will feel comfortable working with and improving
* We like tests
* Forget about the deployment of the application. Just having it work in a normal macOS or Linux laptop will do
* You can forget about styling the pages, too. Raw HTML with no flashy CSS is fine
* You can skip any part of the assignment if you feel it’s too complex or doesn’t make sense, as long as you give us a good reason for that. We are not going to use this code, we want to see how you work and think
