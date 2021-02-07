# mapselector

<!-- badges: start -->

[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

<!-- badges: end -->

The goal of mapselector is to facilitate the process of giving all the dashboards the same appearance!

### quick reminder!

if you have a data processing step that you think is useful to everyone, please add it to `mapselector` so that everyone can use it without rewriting it!

If you have a UI approach that you think works really well, consider creating a module and also adding *that* to `mapselector`! Everyone (should) have write access to this repo. Feel free to create a branch and/or message Andrew.

## Installation

Install `mapselector` directly from github:

``` r
remotes::install_github("ReseauBiodiversiteQuebec/mapselector",ref="main")
```

## Workflow for creating a dashboard

The workflow actually relies on TWO github based resources: this one, `mapselector` and another which serves to set up a project, called `tableauproto`. Below are the steps for the whole process.

**tl;dr**: We have two github resources for managing the dashboards.

-   tableauproto is a github repo. It is a rudimentary golem app that needs customization. Its main goal is to share Guillaume's custom JS and CSS. Begin your project by adding it as a remote called `proto`. Keep it up to date with `git pull proto`

-   mapselector is an R package hosted on github. Its job is to connect, via functions, the custom CSS and the Shiny code. Install it with `remotes::install_github("ReseauBiodiversiteQuebec/mapselector")` and keep it up to date that way. We'll try to keep the version numbers changing when there is a change you need; but if something doesn't make sense then message Andrew or Guillaume.

### Step 1 : Begin with `tableauproto`

Create a new folder for your project. NOTE because we're creating golem apps, it's important to use a valid R package name for the project. This means no dashs `-` or underlines `_`. so `montableau` and NOT `mon_tableau`. (Here I'm assuming that your tableau is called "montableau".)

    mkdir montableau

start a git repository

    git init

add [`tableauproto`](https://github.com/ReseauBiodiversiteQuebec/tableauproto) as a remote. Here I am deliberately giving this remote the unconventional name `proto`, because it's not your main remote:

    git remote add proto https://github.com/ReseauBiodiversiteQuebec/tableauproto.git

pull in the template from `tableauproto`

    git pull proto

this template is NOT an Rstudio project, but you should make it one now. Go to `New Project > Existing Directory` and choose `montableau/`

### Step 2: create your main github repo

Create a github repo called `montableau`

add your new github repo as the `origin` remote:

    git remote add origin https://github.com/ReseauBiodiversiteQuebec/montableau.git

### Step 3: get started avec `golem`

I don't have space here to give a good intro to the golem framework, but here is a [link to the docs](https://engineering-shiny.org/)

In the file `dev/01_start.R`, edit any of the code you want: your name, the package name, and add the github URL.

### Step 4 : install mapselector

`tableauproto` is already a golem app, and as such it declares a minimal set of dependencies. One of these is `mapselector`. Install it (see above).

Mapselector also contains an example of how to use its functions. To see this, read the file `app_ui.R` in the mapselector source. [Here is a link](https://github.com/ReseauBiodiversiteQuebec/mapselector/blob/main/R/app_ui.R)

### Step 5: write functions, modules

In many of our previous shiny apps, the `app.R` file holds a lot of data processing etc. In golem, all of this needs to be placed in functions, which are in turn called in `app_server.R` , etc.

### What you need to edit

-   `dev/01_start.R` especially the function `golem::fill_desc`

-   copy the `app_ui` function from `mapselector` . Here is a link to the [most recent version](https://github.com/ReseauBiodiversiteQuebec/mapselector/blob/main/R/app_ui.R#L7)

-   copy the `app_server` function from `mapselector`. Here is a link to the [most recent version](https://github.com/ReseauBiodiversiteQuebec/mapselector/blob/main/R/app_server.R#L7)

-   **edit the main page:** in `app_ui` you are able to modify the main page of the app. This is where you define:

    -   The Title. Here you need to change two things:

        -   In `app_ui`, modify the argument `title` of `dash_title` In the app, this will appear on the top of the screen.

            ``` r
            app_ui <- function(request) {
              tagList(
                golem_add_external_resources(),
                tableau_de_bord(
                  dash_title(title = "Analyse de raréfaction"), 
            ```

        -   in `golem_add_external_resources`, modify the value of `app_title` . In the app, this is the name of the browser tab

            ``` r
              tags$head(
                favicon(ext = 'png'),
                bundle_resources(
                  path = app_sys('app/www'),
                  app_title = 'mapselector'
                )
            ```

    -   The content of the **sidebar**:

        -   the badge text, and what it displays (or delete the badge altogether)

        -   Any widgets you define, with values available all throughout the app

    -   The main display. By default this has two tabs: one, a map of Quebec, one for "Data Download" (as of Jan 2020 this is a placeholder). You can add or subtract any tabs you want.

        -   convenience functions for the main display are:

            -   `tab_map` to make the generic map of the *Provinces naturelles du Quebec*

            -   `tab_gen` which could make any tab with any title (by default the "Download Data" tab)

-   **edit the server function:** this is where you define what happens when users interact with the main display

    -   `output$map` is by default the rendered leaflet map, but could be anything

    -   `chosen_region` could also be anything, by default it is the region of the map users click on

    -   **the tabs in the pop-up Modal:** this is a key part, since most apps will have interesting results shown in these modals.

        -   edit the modal by supplying arguments to `mod_modal_make_server`

        -   The modals display information in tabs. Add as many tabs as you want as arguments to `mod_modal_make_server`. Wrap each tab in `tabPanel` (a `shiny` function)

        -   Contents of `tabPanel` are flexible. You can the following ([see examples in mapselector](https://github.com/ReseauBiodiversiteQuebec/mapselector/blob/main/R/app_server.R#L12)):

            -   A simple html element like `div()`

            -   A `render*({})` function

            -   a function you write yourself
