# README #

This is a simple redmine plugin for materials and devices' fundamental management.

This plugin is open source and released under the terms of the GNU General Public License v2 (GPL).

## What is this repository for? ##

### Quick summary ###

This is a simple redmine plugin for materials and devices' fundamental management.

For basic account management of device, equipment, books or other items. 

Record the material's usage or storage information instead of manual management.

future's version planning:

update the material's last status and other properties according to the lifecycle' update.

begin to write the test case for strong code.

lifecycle's activity streams

### Version ###
0.1.6
compatible with 3.4.x, also with 3.3.x and 3.2.x


0.1.5

fixed the bug that exporting to csv didn't work

added field_material(warehouse)_name to avoid using the globle locale key

fixed the bug that importing csv didin't work 

0.1.4

optmized the field for date and time format selection 

0.1.3

added locale for Poland language

0.1.2

continue testing

add admin menu for plugin's setting

simple validation of the nested parent material

0.1.1

material's csv import/export supporting

0.1.0

fix the bug which only be set to blank on the selection's field

adjust the field's position for the normal tab order

0.0.9

fix the bug: the warehouse is disable to be selected

0.0.8

basic functional test

0.0.7

basic unit test

add the feature of life cycle's activity stream



0.0.6

material cycle supporting

inventory and warehouse supporting


0.0.5

begin supporting exporting csv (still not work)

fix bugs of db migration script using references type

test for running under 3.2.1. it works

0.0.4

comments feature

0.0.3

global search feature

activity stream feature

0.0.2

add top menu and global index

0.0.1

init

## How do I get set up? ##

### Summary of set up ###

1.Copy the plugin directory into the plugins directory (make sure the name is redmine_materials)

2.Install the required gems (in the Redmine root directory)

bundle install --without development test

3.Execute migration

rake redmine:plugins:migrate NAME=redmine_materials RAILS_ENV=production

4.Start Redmine

5.Add Categories

in administration menu visit the redmine_materials' plugin's configuration

### Uninstall ###

Rollback the migration

rake redmine:plugins:migrate  NAME=redmine_materials VERSION=0 RAILS_ENV=production

Delete the plugin directory (plugins/redmine_materials)