# How to contribute

Redhopper is free software and welcomes any feedback or contribution so do not hesitate to contact us.

Feel free to improve this contribution guide.

## Provide feedback

1. You can email us at **redhopper (at) infopiiaf.fr** (French and English spoken);
2. Open an issue on [Framagit](https://git.framasoft.org/infopiiaf/redhopper) (which uses [Gitlab CE](https://about.gitlab.com/features/#community)).

And let's talk about it!

## Provide code

There are two ways to provide code for Redhopper, the first one being the preferred one:
1. Fork the project on [Framagit](https://git.framasoft.org/infopiiaf/redhopper) and propose a [merge request](https://git.framasoft.org/help/gitlab-basics/add-merge-request.md);
2. Send a git patch to **redhopper (at) infopiiaf.fr** (French and English spoken).

Either way, please try to stick to the following rules.

### Prerequisites

We recommend you develop and test the plugin within a test instance of Redmine.

To be able to work on the tool (`RAILS_ENV=development`):
0. install Redmine: [how to install Redmine](http://www.redmine.org/projects/redmine/wiki/RedmineInstall)
0. install Redhopper: [how to install the plugin](https://git.framasoft.org/infopiiaf/redhopper#how-does-it-work)
0. in order to see if everything is ok, in Redmine root directory:
    0. run the tests: `bundle exec rake redmine:plugins:test NAME=redhopper`
    0. start Redmine: `bundle exec rails server`

Now you can work on improving Redhopper.

### Provide tests

Your patch will have more chance to be included within the tool if your improvement is well tested. If you find yourself lost, do not hesitate to tell us.

At this moment, you should already know how to run the tests, but in case you forgot what you've just read ;-)
```
bundle exec rake redmine:plugins:test NAME=redhopper
```

### CSS

#### SASS

Unfortunately Redmine does not use SASS (yet) but we use it to develop Redhopper. If you want to perform modifications on the CSS, you will **have to** run the SASS compiler after modifying the SASS file. To do so, just run in **Redmine** directory:
```
bundle exec sass --watch plugins/redhopper/assets/stylesheets:plugins/redhopper/assets/stylesheets
```
This way, the `sass` executable will watch for every changes in `.sass` files and compile the matching CSS file. Don't forget to commit both the SASS and CSS files when you're happy with your work.

_N.B.: Redmine copies plugins' assets at startup, so you have to **restart Redmine** to be sure each of your changes have been pulled in._

#### Conventions

We're (mostly) using CSS conventions inspired by [SMACSS](https://smacss.com/book/categorizing), [BEM](https://en.bem.info/method/definitions/) and [SUIT CSS](http://suitcss.github.io/). It relies on a few principles :

0. Style CSS classes, not HTML elements or IDs;
0. Make a clear distinction between a UI component, its states and subcomponents:
 * `.Component`: capitalized noun;
 * `.Component.is-active`: `is-` prefixed + adjective;
 * `.Component-subcomponent`: `-` suffixed + lowercase noun;
0. An HTML element may be a component and a subcomponent :
 * the _component_ class is for cosmetics;
 * the _subcomponent_ class is for positioning.

For instance, a kanban board might use classes like `KanbanBoard`, `KanbanBoard-column`, `Column`, `Column-kanban`, `Kanban`, `Kanban.is-blocked`…
