# Lend Desk Coding Challenge

### Getting Started
```shell
$ git clone git@github.com:desoleary/lend-desk-coding-challenge-rails.git
$ cd lend-desk-coding-challenge-rails
$ bundle install
$ bin/rspec
$ bin/rake rswag:specs:swaggerize # Optionally re-generates API Docs
$ brew install redis # Optional
$ redis-server # runs redis server on port 6379
$ bin/rails s # Ensure you have OS redis installed and running under port 6379
$ open http://0.0.0.0:3000/api-docs # opens Swagger API Docs
```

### API Docs
- URL: http://0.0.0.0:3000/api-docs
- Regenerate API: `bin/rake rswag:specs:swaggerize`

### Cookie Storage
- JWT encode/decode is not involved
- Uses `JWT naming conventions` to demonstrate an approach for recording data related to calculating inactivity via `initiated_at` and `expires_at`
- `Encryption` used was to make use of `MessageEncryptor` which can be helpful in storing cookies that might span more than one or more services

### Validation Contracts
Introduced validation contracts via `dry-validation` library

### Model Layer (Redis backend)
- Uses `SimpleRedisOrm::ApplicationEntry` in order to simplify redis model storage interactions
- Attributes declared making use of dry-struct
- redis interactions encapsulated inside of RedisStore::Entry

### Services (Light Services)
Service layer introduced to promote re-use and focus on single responsibilities via action classes.

- Context obj returned from `Organizers` exposes the likes of `.success?` `.errors` `.params`
- `add_params` ~ adds key value pairs to context `params`
- `add_errors` ~ adds key value pairs to context `errors`
  - fails the context ensuring that subsequent actions do not get called

### Technicals

#### [LoginSessionCreateAction](app/services/login_session_create_action.rb)
- Adds `login_state` based on session entry added via Redis
- Caller adds value of `login_state` to `secure_session` cookie

#### [UserAuthAction](app/services/user_auth_action.rb)
- Checks username and password
- Error handling

#### [User](app/models/user.rb)
- Creates entry with encrypted password via `BCrypt::Password`
- redis key `user-<email>`

#### [LoginSession](app/models/login_session.rb)
- Stores `session token` as a simple SecureRandom.hex
- redis key `session-<random-hex>`

### TODO:
- Investigate why the need for `without_invalid_characters` via Swagger API calls
- Fix `BCrypt::Errors::InvalidHash:invalid hash` error encountered via Swagger API call `/users/sign_in` 
- Uncomment `CSRF` `protect_from_forgery` and fix Swagger API calls
- Hide the likes of below from organizer params/input
  - **password**
  - **password_confirmation**
- Implement reset password endpoints 
  - `POST /users/password` creates reset password token
  - `PUT /users/password` updates password when provided valid `token`
  - Ensure password is reset within a certain amount of time e.g. 6 hours
  - Send notification emails
- Implement `lock account` via max invalid credential attempts
- **logging** ~ remove any sensitive data
- **non api only**
  - Implement reset session after configured inactivity e.g. after 30 minutes
  - CAPTCHA on failed logins
- Implement rate limiting based client identifier e.g. max 1000 requests per hour
- Complete `CORS` configuration
- Ensure Redis interactions cannot be maliciously accessed via the likes of Cross Site Scripting`(XSS)`
- Run bundle audit prior via git remote push
