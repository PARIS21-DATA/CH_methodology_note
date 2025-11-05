
## CH_methodology_note — Bookdown quick guide

This repository contains the methodological note accompanying the Clearinghouse platform. It is build on the [bookdown package](https://bookdown.org/home/).

The following explains how to build this bookdown project locally and publish it to GitHub Pages.

### 1) Prerequisites

- R (>= 3.6) with `bookdown` installed and available in PATH for `Rscript`.
- git configured for this repository.
- The top-level book source is `index.Rmd`. The output folder is `docs/` (see `_bookdown.yml`).

Install bookdown in an R if not already installed:

```r
install.packages('bookdown')
```

### 2) Build locally 

Start an interactive R session and run:

```r
bookdown::render_book('index.Rmd')
```

Notes:
- The command writes output to `docs/` as configured. If you changed `_bookdown.yml`, confirm the `output_dir` value.

### 3) Preview the site

- Open the generated file: `docs/index.html` in your browser or within an R session: 

```r
browseURL('docs/index.html')
```

### 4) Publish to GitHub Pages (docs/ folder)

Push your changes to the `main` branch. Then set GitHub Pages in the repository Settings to: "Branch: main" and "Folder: /docs". The site will be published at the URL shown by GitHub Pages.




