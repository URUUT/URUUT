#URUUT New Workflow/Process#

From here on out, we'll be using a git branching workflow (again) and not directly working on, or committing to, master.

A good example and description can be found [here][1].       
***
##The basic workflow goes like this:##
![](https://www.atlassian.com/git/workflows/pageSections/00/contentFullWidth/0/tabs/01/pageSections/07/contentFullWidth/0/content_files/file0/document/git-workflow-feature-branch-1.png "Git Branching Workflow")

Create a new branch with descriptive name  
`git checkout -b madas-feature`

Do some work implementing feature  

Add Files and Commit  
`git status`  
`git add <some-file>`  
`git commit -m "Some descriptive message of what was implemented"`

Push branch to origin  
`git push -u origin madas-feature`  

From here you just continue to work and repeat the add/commit/push process until you feel the feature is done.  

When you feel the feature is done, you will now go to [bitbucket][2] to create a pull-request and add reviewers (atleast Chad).  
***

##New Testing Requirements##  
Now that we have launched and the feature addition will be slower, we will need to ensure that we are writing tests for everything we do.  I've included the following gems to the bundle and expect to start moving to a more TDD style of coding.

* Rspec
* Cucumber
* Factory Girl
* Jasmine
* Capybara

Use these gems to start writing **tests first**.  

I will be going through the styles, JS, and other portions of code to reduce unused code and consolidate things to their correct locations over the next few weeks to help with maintainability.  Going forward, there are some rule that we need to adhere to:  

* I expect the rails asset pipeline to be used correctly from here on out, meaning all JS is written in CoffeeScript and saved in a .js.coffee file in the assets/javascript folder, no more JS in views.  
  
* No more inline styles.  All styles need to be added to the appropriate stylesheets in scss format and let rails compile accordingly.  Don't worry about going back through code and removing existing inline styles, that is already being handled.

* Ensure we are writing **unit tests for JS** and paying attention to JS performance while writing to help with page load times.  





[1]: https://www.atlassian.com/git/workflows#!workflow-feature-branch
[2]: https://bitbucket.org/chaddy81/crowdfundproject-dev/pull-request/new
