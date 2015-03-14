# Documentation

The docs are automatically being generated using Travis CI.

## Overview

Every time a commit is pushed to GitHub, Travis CI starts a build.

When the main script has run and tests have passed, the `after_success` key in `travis.yml` launches the `./scripts/deploy_docs_to_gh_pages.sh`.

The script first checks to see if the tag matches `v[0-9]+,[0-9]+,[0-9]+)`:

- If it does **not** match: documentation is not rendered.
- If it does match: `gulp dgeni` is run and the output is pushed to the `gh-pages` branch.

## Configuration

To provide Travis CI with rights to deploy the newly generated documentation to GitHub, we need to provide it with a GitHub token that represents an account that has sufficient rights to push to the repository.

#### Step 1: create a GitHub token

To generate a new personal access token in GitHub, go to *Personal settings / Applications* and click on *Generate new token* in the *Personal access tokens* section of the page.

Give it an appropriate description such as "Documentation deployment token for router" so you can later identify the token again in case you no longer need it and want to remove it.

Finally copy the generated token that GitHub presents on your screen. It is important to copy it right now because it is only shown once and you'll have to regenerate a new one if you forget it.

#### Step 2: tell Travis to use the token

Travis offers a really convenient feature where it lets you define environment variables to customize the build process.

What's more is that it even lets you encrypt these variables so you can add sensitive information to `.travis.yml` without having to worry about others seeing the file.

To add encryped environment variables to your `.travis.yml` file, you can:

```sh
$ gem install travis
$ cd router
$ travis encrypt GITHUB_TOKEN=secret-token-from-step-1 --add
```

This will add a line to the `.travis.yml` file that looks like this:

```sh
secure: <encryped string>
```

When Travis runs the deployment script, it will decrypt the encrypted value and make it available as a regular environment variable so we can conveniently access the original GITHUB_TOKEN again from within the deployment script.

That's it! Save and commit the updated `.travis.yml` file.

## Deploying manually

If required, the documentation can also be generated and deployed to GitHub pages manually.

We now need to specify the GITHUB_TOKEN manually:

```sh
$ GITHUB_TOKEN=<github-token> ./scripts/deploy_docs_to_gh_pages.sh
```

## Change log

#### 2015-03-13

- initial version
