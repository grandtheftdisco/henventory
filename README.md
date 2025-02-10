# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
# henventory

# Development Workflow

## Creating PR
1. Ensure your `main` branch is up to date with `origin/main`.
1. Create a new branch with the naming structure `<author-name>/<feature-name>`, for example a feature to add a nested form for adding egg entries the branch name may be `amanda/nested-egg-entry-creation`.
1. Do work, committing frequently, until the feature work is complete. Work should be complete enough to be deployed to production without further work. Hidden or feature-flagged incomplete work is ok.
1. Open a pull-request on github against the `main` branch.
1. Include the following in the description:
    - A brief description of the work and/or a link to the issue within the issue tracking software
    - Instructions for any external changes needed to run the feature.
    - Screenshots and/or a video of the feature working. Screenshots are typically enough, but for more complex things like animations or difficult to reproduce scenarios, videos are helpful
    - Any additional notes that will help the reviewer, this could be notes on extra tricky bits of code or justification for architecture decisions that may not be obvious.
1. Tag a reviewer in the PR.
1. Submit PR.
1. Wait for feedback, addressing any requested changes or other comments.
1. Once approved, ensure the merge button has the `Squash and merge` option selected, and merge.

## Reviewing PR
1. When tagged in a PR you should try to complete the review within a few hours, or up to 24 hours at most, or communicate with the author when that's not possible.
1. Pull the branch onto your local machine, run and manually test the changes to ensure everything work as expected.
1. In Github, leave line-by-line review notes. There are many different reasons to leave a note on some code, each review comment should have an emoji to help communicate the intent of the note, following this [code review emoji guide](https://github.com/erikthedeveloper/code-review-emoji-guide).
1. If there are any changes that must be changed before merge, select `Request changes` and submit the review.
1. repeat this process until all issues are resolved.
1. Check the `Approve` option and submit the review.

