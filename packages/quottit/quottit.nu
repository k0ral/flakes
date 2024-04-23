#!/usr/bin/env nu

def ninjas [] {
  let base_url = "https://api.api-ninjas.com"
  ^http GET $"($base_url)/v1/quotes" $"Referer:($base_url)" $"Origin:($base_url)" | jq -r '.[] | .quote + " — " + .author'
}

def reddit [] {
  let sources = [
        "https://www.reddit.com/r/quotes/hot.json"
        "https://www.reddit.com/r/quotes/top.json?t=day"
        "https://www.reddit.com/r/quotes/top.json?t=week"
        "https://www.reddit.com/r/quotes/top.json?t=month"
        "https://www.reddit.com/r/quotes/top.json?t=year"
        "https://www.reddit.com/r/quotes/top.json?t=all"
      ]
  let source = $sources | shuffle | first

  ^http GET $source | jq -r ".data.children[].data.title" | shuffle | first
}

def quotable [] {
    ^http GET "https://api.quotable.io/quotes/random" | jq -r '.[] | .content + " — " + .author'
}

def quote-garden [] {
    ^http GET "https://quote-garden.onrender.com/api/v3/quotes/random" | jq -r '.data[] | .quoteText + " — " + .quoteAuthor'
}

def zenquote [] {
    ^http GET "https://zenquotes.io/api/random" | jq -r '.[] | .q + " — " + .a'
}

let i = random int 1..5
match $i {
  1 => ninjas,
  2 => reddit,
  3 => quotable,
  4 => quote-garden,
  5 => zenquote,
}
