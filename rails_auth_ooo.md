## Co.muse Rails Auth Code Along

### Generate New Rails Project
[ ] 1. `rails new comuse-rails-auth --no-test-framework`

### AUTH SET UP
[ ] 2. Generate model + migration `rails g model User email password_digest name image_url bio:text  --no-test-framework`
[ ] 3. Add `has_secure_password` in your new `User` model
[ ] 4. Uncomment `bcrypt` in your Gemfile.
[ ] 5. Add seed data to seeds.rb file to begin implementing and testing auth. Run `rake db:seed`.
[ ] 6. Confirm `bcrypt` is salting the user's password by looking at your your seed data in `rails console`

### IMPLEMENTING SIGN UP
Goal: A form to create a user account

[ ] Sign Up Controller: `rails g controller Registration`
  [ ] User sign up
    [ ] Create routes for `registrations_controller`: `resources :registrations, only: [:new, :create]`
    [ ] Run `rails routes` in terminal to see the newly created routes for `POST` and `GET`
    [ ] Go to `RegistrationsController` to write comments/pseudo code of what each controller action will do  
    [ ] Create route methods in `RegistrationsController`
      - For rendering the login form:
      ```ruby
      # creating a new user instance for login form
      def new
        @user = User.new
        # loads a form for User object
      end

      # accepts params data "posted" from login form
      def create
        # create new user instance with the params hash send from form
      end
      ```
      - Create form for signing user up (add `new.html.erb` to registrations folder)
      **QUESTION:** We will get an error if we don't give this form helper the url of the `registrations_path(@user)`. Why?
      ```HTML
      <h1>Sign Up!</h1>
      <%= form_for(@user, url: registrations_path(@user))  do |f| %>
        <%= f.label :name %>
        <%= f.text_field :name %>

        <%= f.label :email %>
        <%= f.email_field :name %>

        <%= f.label :password %>
        <%= f.password_field :password %>

        <%= f.label :image_url %>
        <%= f.text_field :image_url %>

        <%= f.label :bio %>
        <%= f.text_field :bio %>

        <%= f.submit "Sign Up"
      <% end %>
      ```
      **ANSWER:** Let's look at the `rails routes`. `new_registration_path` points to the page that renders the form. `registrations_path` is the route for _posting_ form data and will point to our `create` route. You can inspect the form in the browser and see the form `action` is pointing to `/registrations`.

      - Plan out `create` route
      ```ruby
      # accepts params data "posted" from login form
      def create
        # create new user instance with the params hash send from form
        # if @user.save (all user inputs are valid)
          # add a key/value pair of user_id to session hash
        # else (user validations fail)
          # redirect back to sign up form
      end
      ```
      - Add validations to User model
        [ ] Presence: `validates :email, presence: true`
        [ ] Uniqueness: `validates :email, uniqueness: true`
      - Build out `create` route
      ```ruby
      # accepts params data "posted" from login form
      def create
        # create new user instance with the params hash send from form
        @user = User.new(params[:user_id])
        if @user.save # (all user inputs are valid)
          # add a key/value pair of user_id to session hash
          session[:user_id] = @user.id
          redirect_to user_path(@user)
        else # (user validations fail)
          # redirect back to sign up form
          render :new
        end
      end
      ```
      **NOTE:** We will get a `ForbiddenAttributesError`. Why?
      **ANSWER:** We need strong params so we're not creating our user with more information than we require. We should let certain information into our application to protect it.
      - Refactor to leverage "strong params" -> `User.new(user_params)`
      ```ruby
      private
      def user_params
        params.require(:user).permit(:email, :password, :name, :bio, :image_url)
      end
      ```
      - Notice the bytes of the cookie before signing up then after signing up it got bigger because we've added information to our sessions hash
      - If we put a `binding.pry` or `byebug` in our user's `show` route then we can see what our session hash looks like. There's a TON of information in there because Rails deals with cookies and sessions differently than in Sinatra. `session[:user_id]` is how we see the key value pair we added to the session hash.


### IMPLEMENTING LOG IN
Goal: A form to log in a user with their email and password

[ ] SessionsController: `rails g controller Sessions`

  [ ] User login
    [ ] Create routes for `sessions_controller`: `resources :registrations, only: [:new, :create, :destroy]`
      - `:new`: login form
      - `:create`: _posting_ data from login form
      - `:destroy`: destroying the `session`
    [ ] Run `rails routes` in terminal to see the newly created routes for `GET`, `POST`, and `DELETE`
    [ ] We can borrow some logic from our `RegistrationsController` for building out our routes in `SessionsController`
    ```ruby
    # renders/points to login form
    def new
      @user = User.new
      # new instance for login form
    end

    # here we're creating a session
    def create
      # want to find a user by their email
      @user = User.find_by(email: params[:user][:email])
      if @user # if user is found
        # add a key/value pair of user_id to session hash
        session[:user_id] = @user.id
        redirect_to user_path(@user)
      else # if user is not found
        # redirect back to sign up form
        render :new
      end
    end
    ```
    [ ] Create form for logging in user (add `new.html.erb` to sessions folder)
    ```HTML
    <h1>Log In!</h1>
    <%= form_for(@user, url: sessions_path(@user)) do |f| %>

      <%= f.label :email %>
      <%= f.email_field :name %>

      <%= f.label :password %>
      <%= f.password_field :password %>

      <%= f.submit "Log In"
    <% end %>
    ```
    [ ] Finish building out create route to authenticate user
    ```ruby
    # here we're creating a session
    def create
      # want to find a user by their email
      @user = User.find_by(email: params[:user][:email])
      if @user && @user.authenticate(params[:user][:password]) # if user is found and authenticated
        # add a key/value pair of user_id to session hash
        session[:user_id] = @user.id
        redirect_to user_path(@user)
      else # if user is not found
        # redirect back to sign up form
        render :new
      end
    end
    ```

  [ ] User log out


### IMPLEMENTING USER PROFILE
[ ] Create `UsersController`
[ ] Create `show` route
[ ] Create `show.erb`

### IMPLEMENTING AUTHORIZATION
[Rails Authentication Lecture](https://youtu.be/cvGSQcXu8pg)(38:00)

### AUTH HELPER METHODS
[ ] `is_logged_in?`
[ ] `current_user`
[ ] `authenticate_user!`: if a user is not logged in, redirect them to the log in page
