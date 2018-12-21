# Brewtoad scraper

This is a Julia script to scrape a users brewtoad account.  Currently downloads

1. HTML for each recipe page
2. BeerXML for each recipe

## Dependencies

* Your Brewtoad user id (the number after "users/" in your profile URL).
* [Julia](https://www.julialang.org/downloads) 1.0 or later
* Required packages are specifed in the [Project.toml]() file.  Install them by
  instantiating the environment (as shown below)

## To run

```bash
$ cd brewtoad-scrape

$ julia -e 'using Pkg; pkg"activate .; instantiate"'

$ julia --project=. scrape.jl <brewtoad-user-id>
```

## Scraped data

This repository also contains my own scraped data in `/recipes`
