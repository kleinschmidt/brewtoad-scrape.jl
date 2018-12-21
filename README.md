# Brewtoad scraper

This is a Julia script to scrape a users brewtoad account.  Currently downloads

1. HTML for each recipe page
2. BeerXML for each recipe
3. Brew logs for each recipe (under `brewlogs/` in the recipe dir)

## Dependencies

* Your Brewtoad user id (the number after "users/" in your profile URL).
* [Julia](https://www.julialang.org/downloads) 1.0 or later
* Required packages are specifed in the [Project.toml]() file.  Install them by
  instantiating the environment (as shown below)

## To run

```bash
$ cd brewtoad-scrape

# install dependencies:
$ julia -e 'using Pkg; pkg"activate .; instantiate"'

$ julia --project=. scrape.jl <brewtoad-user-id>
```

## Warts

I wrote this before I found
[Cascadia.jl](https://github.com/Algocircle/Cascadia.jl), which sould seriously
streamline the selector/querying parts.

At some point brewtoad started returning 403: Forbidden responses to requests
from HTTP.jl (even with `User-Agent` set to something sensible), while still
serving pages normally for both a private browser window and `curl`.  So I
replaced all the `HTTP.request("GET", uri)` with ``String(read(`curl $uri`)``
because I was too lazy to figure out what was really going wrong.

## Scraped data

This repository also contains my own scraped data in `/recipes`
