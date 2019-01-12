# jekyll-action
A GitHub Action to build and publish Jekyll sites to GitHub Pages

Out-of-the-box Jekyll with GitHub Pages allows you to leverage a limited, white-listed, set of gems. Complex sites requiring custom ones or non white-listed ones (AsciiDoc for intstance) used to require a continuous integration build in order to pre-process the site.

## Usage

### Create a Jekyll site
If you repo doesn't already have one, create a new Jekyll site:  `jekyll new sample-site`. See [the Jekyll website](https://jekyllrb.com/) for more information. In this repo, we have created a site within a `sample_site` folder within the repository because the repository's main goal is not to be a website. If it was the case, we would have created the site at the root of the repository.

### Create a `Gemfile`
As you are using this action to leverage specific Gems, well, you need to declare them! In the sample below we are using [the Jekyll AsciiDoc plugin](https://github.com/asciidoctor/jekyll-asciidoc)

```Ruby
source 'https://rubygems.org'

gem 'jekyll', '~> 3.1.0'
gem 'coderay', '~> 1.1.0'

group :jekyll_plugins do
  gem 'jekyll-asciidoc', '~> 2.0.1'
end

```

### Configure your Jekyll site
Edit the configuration file of your Jekyll site (`_config.yml`) to leverage these plugins. In our sample, we want to leverage AsciiDoc so we added the following section:

```yaml
asciidoc: {}
asciidoctor:
  base_dir: :docdir
  safe: unsafe
  attributes:
    - idseparator=_
    - source-highlighter=coderay
    - icons=font
```

Note that we also renamed `index.html` to `index.adoc` and modified this file accordingly in order to leverage AsciiDoc.

### Use the action

```js
action "Jekyll Action" {
  uses = "helaili/jekyll-action@master"
  env = {
    SRC = "sample_site"
  }
  secrets = ["GITHUB_TOKEN"]
}
```
