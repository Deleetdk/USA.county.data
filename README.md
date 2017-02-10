# USA.county.data

This package contains a large dataset with data for counties in the United States. This came comes from several sources, see [this paper](https://openpsych.net/paper/12). The electoral data is from [the New York Times](http://www.nytimes.com/elections/results/president). The variable names are not pretty, but they should be self-explanatory for most purposes. There are some errors with a few counties, but there are good data for ~3100 counties. Note that Alaska has no counties and as such is included as a state. It has no data for 2008-2012.

## Installation
Install it from github with:
  
```{r}
devtools::install_github("deleetdk/USA.county.data")
```

## Usage
To use:

```{r}
data(USA_county_data)
```

rds and csv files [are also provided](https://github.com/Deleetdk/USA.county.data/tree/master/Scrape%20and%20tidy%20code/data).
