# Rails Campaign Manager
## Tech Stack
* Ruby (v3.4.8)
* Rails (v8.1)
* PostgreSQL (v18)
* Bundler (v4.0.10)
* RSpec-Rails (v8.0)
* Node.js (v24.14)
* ReactJS (v19.2.5)
* BootStrap CSS (v5.3.8)
* RuboCop (via rubocop-rails-omakase + rubocop-performance + rubocop-rspec)
* https://tools.keycdn.com as external API for user's IP information

## How to run locally
### Prerequisites
- Ruby 3.4.8 (`rbenv install 3.4.8`)
- PostgreSQL running locally (`brew services start postgresql`)
- Bundler

### Install dependencies
```bash
bundle install
npm install
```

### Setup database
```bash
rails db:create
rails db:migrate
rails db:seed
```

### Run the project
```bash
rails s
npm run build:watch
```

## Linting, tests, type checking and audits
### RuboCop
```bash
rubocop
rubocop -a  # auto-fix safe offenses
```

## Run test cases
```bash
rspec
```

## Application audits
```bash
brakeman --no-pager
bundler-audit
npm audit --audit-level=moderate
rails zeitwerk:check
```

## Usage

### Seed inputs
Once application is ready to use. For simple prefilled inputs, use the provided seeds.

Seed user is email: `demo@example.com` password: `demo123`

### Gathering Available Banner
`/publicbanner` - available unprotected URL for gathering available banners
* It has an option of passing IP for gathering IP information in order to display proper banner
* `/publicbanner/xxx.xxx.xxx.xxx`
* Example: `/publicbanner/195.110.64.205`
* The KeyCDN lookup now requires a `User-Agent` header in the format `keycdn-tools:https?://...`; use `KEYCDN_TOOLS_USER_AGENT` if you want to override the default value.

## API
The admin frontend now uses a versioned JSON API under `/api/v1`. It uses the same session cookie and CSRF token as the Rails app.

### Admin API
* GET `/api/v1/current_user` - returns the signed-in user
* GET `/api/v1/campaigns` - lists the signed-in user's campaigns
* POST `/api/v1/campaigns` - creates a campaign for the signed-in user
* DELETE `/api/v1/campaigns/:id` - deletes one of the signed-in user's campaigns
* GET `/api/v1/banners` - lists the signed-in user's banners
* POST `/api/v1/banners` - creates a banner for the signed-in user
* DELETE `/api/v1/banners/:id` - deletes one of the signed-in user's banners

### Campaign payload notes
* Use `banner_id` in JSON payloads instead of the legacy internal `banners_id` column name.
* Campaign time windows are optional, but if present they must include both `start_time` and `end_time`.
* Campaign time windows are validated on whole hours only, for example `09:00` and `17:00`.
* Overnight windows are supported. For example, `23:00` to `00:00` or `23:00` to `02:00`.
* If a time window crosses midnight, `end_date` must be later than `start_date`.
* Overnight windows are date-aware: the late-night portion uses the current campaign date, and the after-midnight portion continues from the previous active date.

## Original Assignment 
The assignment was to build a super simple advertising platform. This application handles marketing campaigns on the internet. We will have Campaigns that will have banners on them.

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
* Forget about the deployment of the application. Just having it work in a normal macOS or Linux laptop will do
* You can forget about styling the pages, too. Raw HTML with no flashy CSS is fine
* You can skip any part of the assignment if you feel it’s too complex or doesn’t make sense, as long as you give us a good reason for that. We are not going to use this code, we want to see how you work and think
