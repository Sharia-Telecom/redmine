# Redhopper plugin

Kanban boards for Redmine, inspired by *Jira Agile* (formerly known as *Greenhopper*), but following its own path.

Compatibility and more info on Redmine's [plugins page](http://www.redmine.org/plugins/redhopper).

Available translations: `bg`, `de`, `en`, `es`, `fr`, `pt-BR`.

## Wait. But why?

Yep, we are building yet another Kanban plugin for Redmine. The difference this time is the **extensive use of Redmine core concepts** (issues, trackers, workflow, etc.) instead of building everything from scratch.

No need to define columns, your issue statuses are good enough. No need to define allowed transitions, your workflow already does it. Get a useful board in seconds. We believe this is the only way to **achieve fast adoption** for teams already using Redmine like us.

## How does it work?

1. Install the plugin (ref: [Redmine's documentation](http://www.redmine.org/projects/redmine/wiki/Plugins#Installing-a-plugin))
  - Download latest [stable version](https://framagit.org/infopiiaf/redhopper/tags)
  - **IMPORTANT** Make sure the plugin directory name is exactly `redhopper` (and not `redhopper-1.0.6` nor `redhopper-1.0.6-90f004bb629d38f21c6bb7db034e4040d42d9389` for example)
  - Move the plugin to the `plugins` folder in redmine's root folder
  - Install the missing gems with `bundle install` (within redmine's root folder and not redhopper's one)
  - Run the migrations of the plugin: `RAILS_ENV=production bundle exec rake redmine:plugins:migrate NAME=redhopper`
2. Activate the *Kanbans* module in your project configuration.
3. Eventually, activate additional features in Redmine Administration/Plugins/Redhopper Settings.

### *Out-of-the-box* behaviour

Inside a project, you now have a new tab called *Kanbans*. This view displays all the issue statuses in columns, sorted according to your settings in Redmine administration. All the visible issues for the current user are listed within the column matching their status.

From now on, the best way to interact with your issues is by right-clicking them. Change its status or assigned person, go to the *Edit issue* view… Using the same contextual menu as the *Issues* view, your **workflow and user rights are preserved**.  
*NB : it is the main reason why drag'n'drop between issue statuses hasn't been implemented yet. It works well enough to focus on other features.*

All the kanbans (card-shaped issues) summarize its issue : id, subject, notes and attachments count, assigned person… Things you like to know in a glance.

## What else does it do?

### Fine-grained relative prioritisation

As an agile team member, I hate enum-based priority (urgent, high, normal, low…). I need to know what the next thing to do is without ambiguity. When two items have *high* priority, which one should I take?

With relative prioritisation, all I know is that this issue should be done before that one and after this one. No two issues can have the exact same priority. To achieve that, you sort your kanbans thanks to up and down arrow, or drag'n'drop. The top-most kanban is the next thing to do.

### Only necesary and/or open columns

Your workflow is built upon your trackers. All your *bugs* will follow the same path of *allowed workflow transitions* for this tracker. All your *user stories* will follow the same path of *allowed workflow transitions* for this tracker.

Based on your project's trackers and their transitions, Redhopper computes the minimal set of issue statuses to display. Therefore, your board is not polluted by statuses used by unused trackers, but only shows the necessary yet sufficient columns for your project.

With the same purpose – unclutter your workspace – Redhopper can hide columns matching *closed* issue statuses. Once an issue is *closed*, no need to see it anymore. May it rest in piece as archive.

### Obvious blockers

Every flow impediment should receive special treatment: blinking, glowing, bouncing, highlighted, whatever, but visible at first sight. We decided to spare ourself the tiresomeness of the former solutions, and gave the blocked issues a eye-candy red background.

As usual, Redhopper looks for a **built-in concept**, "blocks" relations, to mark a kanban as blocked, and links to the blocking issue (highlighted in yellow).

Besides the built-in blocking system, Redhopper adds the notion of **self-blocked issue**. An issue can be marked as blocked by its last comment, really useful when one just want to ask for a confirmation before completing a task for instance.

## What's next?

We've got tons of ideas, like :
* Setting **WIP limits** and highlighting broken limits ;
* Filtering issues with *saved queries* ;
* Defining and displaying **definitions of done** ;
* Stacked status for parallel or alternative operations ;
* **Flow analytics** : cumulative flow diagram, lead time…

To be honest, we've got some code quality improvements to do too. Redhopper is a good example of protoduction ([item 22](http://blog.codinghorror.com/new-programming-jargon/)), a pet project going into the wild. Expect some refactoring to land someday, or push yours ;-)

### How to contribute?

As we're not making a living out of this plugin, we improve it when we have some time to spare. Licensed under the [AGPLv3 terms](LICENSE.txt), code contributions are welcomed!

**Code isn't the only valuable contribution**. Feedbacks, issues, translations, user guides… Just step in and enjoy the free software way of building great commons.

Contact and detailed information in the [Contribution Guide](CONTRIBUTING.md).
