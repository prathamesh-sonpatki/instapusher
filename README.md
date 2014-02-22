# Instapusher

Makes it easy to push to heroku.

## Installation

    gem install instapusher

## Setting up account

* Login at instapusher.com .
* visit http://instapusher.com/my/api_key and click on the link that says ".instapusher". Save this file at ~.

## Usage

In order to deploy your code first make sure that you are in the branch that you want to deploy. 
Then execute this command.

    instapusher

It detects project name and a branch from the git repo and starts deploying your project.

### Running background jobs and other rake tasks

Instapusher does not create workers on heroku for your project.
Background jobs or rake tasks should be run manually from the console.

``` sh
heroku run rake <TASK_NAME> --app <APP_NAME_GIVEN_BY_INSTAPUSHER>
```

For eg. to run delayed job workers

``` sh
heroku run rake jobs:work --app my-awesome-app-42-add-devise-authentication-ip
```

## Setup Instapusher server

You can provide the env variable `LOCAL` like:

    instapusher --local

To enable debug messages do

    instapusher --debug

Enable quick option as shown below. In the quick mode only code is
pushed. No migration is done. No config environment is set. So it is
much faster and it leaves the data intact.

    instapusher --quick

Pass host info like this

    INSTAPUSHER_HOST=instapusher.com instapusher

Also there are other env variables like `INSTAPUSHER_PROJECT` and `INSTAPUSHER_BRANCH`.

    INSTAPUSHER_HOST=instapusher.com INSTAPUSHER_PROJECT=rails INSTAPUSHER_BRANCH=master instapusher

ALSO you can pass your `api_key`

    API_KEY=xxxx instapusher

## What problem it solves

Here at BigBinary we create a separate branch for each feature we work
on. Let's say that I am working on `authentication with facebook`.
When I am done with the feature then I send pull request to my team
members to review. However in order to review the work all the team
members need to pull down the branch and fire up `rails server` and then
review.

We like to see things working. So we developed `instapusher` to push a
feature branch to heroku instantly with one command. Executing
`instapusher` prints a url and we put that url in the pull request so
that team members can actually test the feature.

## Here is how it works

Lets say that I am working with github project `nimbleshop` in a branch called
`76-facebook-authentication`. When I execute `instapusher` then the
application name under which it will be deployed to heroku will be
`nimbleshop-76-facebook-ip`.

`nimbleshop` is the name of the project.
`76-facebook` is the first 10 letters of the branch name.
`ip` is characters to mark the instance as temporal.

So in this case the url of the application will be
`http://nnimbleshop-76-facebook-ip.herokuapp.com` .

There are three special branches `master`, `staging` and `production`.
For these branches the url generated will be just the application name and the
branch name. For example if I execute `instapusher` from `staging`
branch then the heroku url will be
`http://nimbleshop-staging.herokuapp.com`.

## License

`instapusher` is released under MIT License.
