<div align="center">

<a href='http://rich-iannone.github.io/intendo/'><img src="man/figures/logo.svg" height="350px"/></a>

</div>

The **intendo** R package provides access to several synthetic but realistic analytics datasets. The four datasets available track the performance of the nonexistent *Super Jetroid* mobile game. These four datasets are interrelated and there is internal consistency between them. There are four sizes for each of these, which stem from player bases of different sizes. Each table, regardless of size, has a variant (`"faulty"`) containing errors and data inconsistencies.

These datasets, in all their variations, are useful for data practice (as with most datasets) and for testing or demonstrating data quality procedures.

With a focus on demonstrating data documentation, this package provide functions that generate data dictionaries for each variation of each dataset.

## Installation

You can install the development version of **intendo** from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("rich-iannone/intendo")
```
