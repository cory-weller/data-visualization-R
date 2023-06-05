# Scatter plots


Scatter plots, for visualizing associations between two variables
```R
cars <- as.data.table(mtcars, keep.rownames=TRUE)
setnames(barplots.df, 'rn', 'car')

# Plot mpg (on y) as function of weight (on x)
ggplot(cars, aes(x=wt, y=mpg)) + geom_point()
ggplot(cars, aes(x=wt, y=mpg)) + geom_smooth()
ggplot(cars, aes(x=wt, y=mpg)) + geom_smooth() + geom_point(alpha=0.5, shape=21)

# Plot horsepower (on y) as function of mpg (on x)
ggplot(cars, aes(x=cyl, y=hp)) + geom_point()
```

## Addition additional dimensions
- shape
- color
- alpha
- line (outline)
- facet

# Faceted scatter plots