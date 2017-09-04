# Messenger plugin for Redmine

This plugin posts updates to issues in your Redmine installation to [Slack](https://slack.com/), [Rocket.Chat](https://rocket.chat/) or [Mattermost](https://about.mattermost.com/) channel.

[![Dependency Status](https://gemnasium.com/badges/github.com/AlphaNodes/redmine_messenger.svg)](https://gemnasium.com/github.com/AlphaNodes/redmine_messenger) ![Jenkins Build Status](https://pm.alphanodes.com/jenkins/buildStatus/icon?job=Devel-build-redmine-messenger)

## Features

* Post information to messenger channel
  * post issue updates
  * post private issue updates
  * display watchers
  * convert username to mentions
  * post wiki updates
  * post db entry (if redmine_db is installed) updates
  * post password (if redmine_passwords is installed) updates
  * post contact (if redmine_contacts is installed) updates
* overwrite messenger settings at project level
* parent project support (inherit messenger settings from parent project)
* multiple channel support (define one or more channels to deliver note)

## Screenshot

Mattermost output:

![screenshot](https://raw.githubusercontent.com/alphanodes/redmine_messenger/master/assets/images/screenshot_mattermost.png)

Redmine configuration:

![screenshot](https://raw.githubusercontent.com/alphanodes/redmine_messenger/master/assets/images/screenshot_redmine_settings.png)

## Prepare your messenger service

### Slack

Go to Slack documentation [Incoming Webhooks](https://api.slack.com/incoming-webhooks) for more information to set up Incoming WebHook

### Mattermost

Go to Mattermost documentation [Incoming Webhooks](https://docs.mattermost.com/developer/webhooks-incoming.html) for more information to set up Incoming WebHook

### Rocket.Chat

Go to Rocket.Chat documentation [Incoming WebHook Scripting](https://rocket.chat/docs/administrator-guides/integrations/) for more information to set up Incoming WebHook


## Requirements

* Redmine version >= 3.0.0
* Ruby version >= 2.1.5


## Installation

Install ``redmine_messenger`` plugin for `Redmine`

    cd $REDMINE_ROOT
    git clone git://github.com/alphanodes/redmine_messenger.git plugins/redmine_messenger
    bundle exec rake redmine:plugins:migrate RAILS_ENV=production

Restart Redmine (application server) and you should see the plugin show up in the Plugins page.
Under the configuration options, set the Messenger API URL to the URL for an
Incoming WebHook integration in your Messenger account and also set the Messenger
Channel to the channel's handle (be careful, this is not the channel's display name
visible to users, you can find each channel's handle by navigating inside the channel
and clicking the down-arrow and selecting view info).


## Uninstall

Uninstall ``redmine_messenger``

    cd $REDMINE_ROOT
    bundle exec rake redmine:plugins:migrate NAME=redmine_messenger VERSION=0 RAILS_ENV=production
    rm -rf plugins/redmine_messenger

Restart Redmine (application server)


## Credits

The source code is forked from

  - [redmine_rocketchat](https://github.com/phlegx/redmine_rocketchat)
  - [redmine_mattermost](https://github.com/altsol/redmine_mattermost)
  - [redmine-slack](https://github.com/sciyoshi/redmine-slack)

Special thanks to the original author and contributors for making this awesome hook for Redmine. This fork is just refactored to use Messenger-namespaced configuration options in order to use all hooks for Rocket.Chat, Mattermost AND Slack in a Redmine installation.
