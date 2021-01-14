
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mapselector

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of mapselector is to facilitate the process of giving all the
dashboards the same appearance\!

## Installation

Install `mapselector` directly from github:

``` r
remotes::install_github("ReseauBiodiversiteQuebec/mapselector")
```

## Workflow for creating a dashboard

The workflow actually relies on TWO github based resources: this one,
`mapselector` and another which serves to set up a project, called
`tableauproto`. Below are the steps for the whole process.

**tl;dr**: We have two github resources for managing the dashboards.

  - tableauproto is a github repo. It is a rudimentary golem app that
    needs customization. Its main goal is to share Guillaume’s custom JS
    and CSS. Begin your project by adding it as a remote called `proto`.
    Keep it up to date with `git pull proto`

  - mapselector is an R package hosted on github. Its job is to connect,
    via functions, the custom CSS and the Shiny code. Install it with
    `remotes::install_github("ReseauBiodiversiteQuebec/mapselector")`
    and keep it up to date that way. We’ll try to keep the version
    numbers changing when there is a change you need; but if something
    doesn’t make sense then message Andrew or Guillaume.

### Step 1 : Begin with `tableauproto`

Create a new folder for your project. NOTE because we’re creating golem
apps, it’s important to use a valid R package name for the project. This
means no dashs `-` or underlines `_`. so `montableau` and NOT
`mon_tableau`. (Here I’m assuming that your tableau is called
“montableau”.)

    mkdir montableau

start a git repository

    git init

add
[`tableauproto`](https://github.com/ReseauBiodiversiteQuebec/tableauproto)
as a remote. Here I am deliberately giving this remote the
unconventional name `proto`, because it’s not your main remote:

    git remote add proto https://github.com/ReseauBiodiversiteQuebec/tableauproto.git

pull in the template from `tableauproto`

    git pull proto

this template is NOT an Rstudio project, but you should make it one now.
Go to `New Project > Existing Directory` and choose `montableau/`

### Step 2: create your main github repo

Create a github repo called `montableau`

add your new github repo as the `origin` remote:

    git remote add origin https://github.com/ReseauBiodiversiteQuebec/montableau.git

### Step 3: get started avec `golem`

I don’t have space here to give a good intro to the golem framework, but
here is a [link to the docs](https://engineering-shiny.org/)

In the file `dev/01_start.R`, edit any of the code you want: your name,
the package name, and add the github URL.

### Step 4 : install mapselector

`tableauproto` is already a golem app, and as such it declares a minimal
set of dependencies. One of these is `mapselector`. Install it (see
above).

Mapselector also contains an example of how to use its functions. To see
this, read the file `app_ui.R` in the mapselector source. [Here is a
link](https://github.com/ReseauBiodiversiteQuebec/mapselector/blob/main/R/app_ui.R)

### Step 5: write functions, modules

In many of our previous shiny apps, the `app.R` file holds a lot of data
processing etc. In golem, all of this needs to be placed in functions,
which are in turn called in `app_server.R` , etc. For many tasks, this
will be a relatively simple transformation.

However, if you have a data processing step that you think is useful to
everyone, please add it to `mapselector` so that everyone can use it
without rewriting it\!

If you have a UI approach that you think works really well, consider
creating a module and also adding *that* to `mapselector`\! Everyone
(should) have write access to this repo. Feel free to create a branch
and/or message Andrew.
