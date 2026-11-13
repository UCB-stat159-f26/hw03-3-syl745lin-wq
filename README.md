# tenniscareer

`tenniscareer` retrieves career match records from Tennis Abstract and plots
a player's age against the age difference between the player and the opponent.
Point colors distinguish wins from losses.

## Installation

Install the package from the course GitHub repository using an account with
access to the repository.

```r
devtools::install_github("UCB-stat159-f26/hw03-3-syl745lin-wq")
```

## Usage

```r
library(tenniscareer)

serena <- get_career_matches("Serena Williams")
head(serena)
plot_career_matches(serena)

nadal <- get_career_matches("Rafael Nadal")
plot_career_matches(nadal)
```

`get_career_matches()` needs an internet connection. The age difference is
the player's age minus the opponent's age, in years. Positive values mean
the player was older than the opponent.

## Offline tests

After installing the package, run this command from the repository root.

```bash
Rscript tests/career-matches.R
```

The tests use local JavaScript examples to check both formats of opponent age data.

## Personal Reflection

In HW2, I learned how to reproduce the existed Serena Williams's Professional Matches scatter plot showing her wins and losses in the past games, and I learned the workflow for making changes, add environment, add and edit Makefile, add files and folders to git, then add commits and push the folders and files to github repository. In HW3, I learned how to make that workflow into an R package by making the player name an nput and writing the two functions that users call. An important detail in this homework  was that Tennis Abstract provides an opponent's birth date in the women's data and an age in years in the men's data which provides their ages. I tested both formats using local examples. I also installed the package with `R CMD INSTALL .` and loaded it with `library(tenniscareer)` to check that both functions worked after installation.
