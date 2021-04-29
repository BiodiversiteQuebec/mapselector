# mapselector

<!-- badges: start -->

[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

<!-- badges: end -->

The goal of mapselector is to facilitate the process of giving all the dashboards the same appearance!

### quick reminder!

test 
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

### Step 1 : create a new `golem` app

#### Begin with a golem template

`golem::create_golem` or Rstudio \> File \> New Project... and choose the golem template.

NOTE golem apps are also R packages, so it's important to use a valid R package name for the project. This means no dashs `-` or underlines `_`. so `montableau` and NOT `mon_tableau`. (Here I'm assuming that your tableau is called "montableau".)

#### start a git repository

    git init

#### create your main github repo

Create a github repo called `montableau`

add your new github repo as the `origin` remote:

    git remote add origin https://github.com/ReseauBiodiversiteQuebec/montableau.git

### Get started avec `golem`

Rather than give a complete intro to the golem framework, here is a [link to the docs](https://engineering-shiny.org/) Here is a guideline to what *I* think are key points for our workflow:

#### edit the "start" script

Golem tries to facilitate your workflow with some "development scripts". these are stored in the `dev` folder.

In the file `dev/01_start.R`, edit the following:

``` r
golem::fill_desc(
  pkg_name = "mapselector", # The Name of the package containing the App 
  pkg_title = "Map selector module for Shiny", # The Title of the package containing the App 
  pkg_description = "Its a simple module to make a map for Shiny, plus a few helper functions to help you use a map as a selector in your Shiny App.", # The Description of the package containing the App 
  author_first_name = "Andrew", # Your First Name
  author_last_name = "MacDonald", # Your Last Name
  author_email = "a.a.m.macdonald@gmail.com", # Your Email
  repo_url = "https://github.com/ReseauBiodiversiteQuebec/mapselector" # The URL of the GitHub Repo (optional) 
)     
```

This formats your package Description for you.

Edit and run this line:

``` r
## Set {golem} options ----
golem::set_golem_options(golem_version = "0.3.0")
```

I also set up MIT licence, code of conduct, and a badge for my project.

Edit and run this line to get the Official COLEO project favicon!

``` r
golem::use_favicon("https://raw.githubusercontent.com/ReseauBiodiversiteQuebec/rcoleo/master/pkgdown/favicon/favicon-32x32.png") # path = "path/to/ico". Can be an online file. 
```

Other things are optional. When you're done, commit and move on to `dev/02_dev.R`

#### edit 02_dev.R -- getting to work

There are four things I do here:

creating raw data files

creating vignettes

creating module and function files

adding packages to the description

Of all of these, only one is **essential** if you want to make an Approved Tableau De Bord:

``` r
usethis::use_dev_package(package = "mapselector", remote = "ReseauBiodiversiteQuebec/mapselector")
```

of course, remember to *Install ⭐⭐⭐MAPSELECTOR* *⭐⭐⭐*yourself! instructions up there :point_up:

### get the server and ui from *⭐⭐⭐MAPSELECTOR* *⭐⭐⭐*

mapselector is also a simple example of a dashboard. the `app_ui.R` and `app_server.R` files are therefore good examples that you can modify for yourself.

-   copy the `app_ui` function from `mapselector` . Here is a link to the [most recent version](https://github.com/ReseauBiodiversiteQuebec/mapselector/blob/main/R/app_ui.R#L7)

    -   `mapselector:::copy_mapselector_app_ui()` will copy the github version over your own

-   copy the `app_server` function from `mapselector`. Here is a link to the [most recent version](https://github.com/ReseauBiodiversiteQuebec/mapselector/blob/main/R/app_server.R#L7)

    -   `mapselector:::copy_mapselector_app_server()` will copy the github version over your own

### editing the ui

here is the mapselector `app_ui` file:

``` r
app_ui <- function(request) {
  tagList(
    marcel(filename = "marcel.md"),
    golem_add_external_resources(),
    tableau_de_bord(
      dash_title(title = "Bonjour Quebec"), 
      dash_sidebar(
        badge(),
        textInput("name", "What's your name?"),
        mod_modal_helpbutton_ui("info1", "Jargon")
      ), 
      dash_tabs(
        #maybe a little strange, but here we pass in the UI of a modal and the id that defines it.
        tab_map(title = "Map", id = "map", outputFunction = mod_map_select_ui),
        tab_map(title = "Site Map", id = "sitemap", outputFunction = mod_map_select_ui),
        tab_map(title = "Ouranos", id = "ouranos_map", outputFunction = mod_map_select_ui),
        tab_gen())
    )
  )
}
```

-   edit marcel -- if using. Make sure that `marcel.md` is placed in `inst/app/www`

-   `dash_title` set the title

-   If you're using a sidebar, provide any widgets to `dash_sidebar`

-   define what text goes in your badge with `badge()`. you can also turn it off with `badge(use_badge = FALSE)`

-   If you ever want a help icon :information_source: next to a title, wrap that title in `mod_modal_helpbutton_ui` . give this help button an id (the first argument. in the example it is `"info1"`. Then on the server side, write:

    ``` r
      mod_modal_observeEvent_tutorial_server("info1",
                                             title_text = "title for help",
                                             md_file = "demo_help.md")  
    ```

    note that the id is the same. whatever text you want to appear goes in a markdown file, and is saved in `inst/app/www` just like `marcel.md`

-   `dash_tabs` makes the tabs and gives them the right CSS class. you just need to provide the tabPanels you want.

-   `tab_map` is an minimal wrapper around tabPanel. give it the tab title, the id of any module that does the plotting, and the name of the module ui function that makes the plot

### edit the server

The server function is bigger because it does all the R computation. here is a quick look at a few details:

``` r
  # help modules ------------------------------------------------------------
  
  mod_modal_observeEvent_tutorial_server("info1",
                                         title_text = "title for help",
                                         md_file = "demo_help.md")  
  
```

any help button text goes here

``` r
  # server function to create the map and capture what is clicked
  got_clicked <- mod_map_select_server("map",
                                       what_to_click = "shape",
                                       fun = make_leaflet_map,
                                       # these are arguments to make_leaflet_map
                                       mapdata = mapselector::CERQ,
                                       label = TRUE,
                                       region_name = "NOM_PROV_N")
```

This shows a handy pattern: a module server that does two useful things. First, it creates a map. Second, it saves the value of whatever is clicked to a reactive input. see `?mod_map_select_server()`

You can trigger a modal to pop up when you click using

``` r
  mod_modal_make_server("modal_make_ui_1", 
                        # this reactive value is passed inside the module
                        # note you but the reactive value here, not its value, 
                        # which you would get with chosen_region()
                        region = got_clicked,
                        # give the title that you want for the modal
                        title_format_pattern = "Visualization for %s",
                        # here place all the tabs you want in your final modal! 
                        ## this can be a function which returns a reactive output 
                        tabPanel(title = "Visualization",
                                 # see mapselector::ipso_zoo for an example
                                 ipso_zoo(color = I("red"))
                        )
```

### put it all together

this is a good example of doing FOUR interesting server-side operations: the workflow for downloading site observations and displaying them.

``` r
  # download sites
  downloaded_sites <- rcoleo::download_sites_sf()  

  # plot sites
  got_clicked_site <- mod_map_select_server("sitemap",
                                            what_to_click = "marker", 
                                            fun = plot_rcoleo_sites,
                                            # argument to plot_rcoleo_sites
                                            rcoleo_sites_sf = downloaded_sites)
  
  # react to the site clicked with a calculation
  mod_observation_display_server("siteobs", 
                                 site = downloaded_sites, 
                                 region = got_clicked_site)

  # display a modal to respond to the clicked site
  mod_modal_make_server("modal_make_ui_2", 
                        # this reactive value is passed inside the module
                        region = got_clicked_site,
                        # give the title that you want for the modal
                        title_format_pattern = "Visualization for %s",
                        tabPanel(title = "ou suis-je",
                                 renderText({paste("tu est sur", got_clicked_site())})
                        ),
                        tabPanel(title = "Observations",
                                 mod_observation_display_ui("siteobs")
                        )
  )
```

Here we:

1.  download all the site information
2.  pass this to a module that plots them and returns the reactive value of the user clicking one
3.  react to this click with a calculation -- in this case, downloading the observations for that site
4.  output the results to a modal. Note that the modal server takes a list of tabPanels, and one of these contains `mod_observation_display_ui`. this is the output that matches the information downloaded and formatted by `mod_observation_display_server`

### write functions, modules

In many of our previous shiny apps, the `app.R` file holds a lot of data processing etc. In golem, all of this needs to be placed in functions, which are in turn called in `app_server.R` , etc.

You can go back to `02_dev` to create either using `golem::add_module` or `golem::add_utils`

### What you need to edit

-   `dev/01_start.R` especially the function `golem::fill_desc`

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
