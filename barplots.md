# Bar plots

`geom_bar` and a specific flavor of it, `geom_col` 

By default, both will create stacked bars. The bars can be unstacked by
using `position='dodge'`

`geom_bar()` for bar chart of frequencies of unique values in `x=COLUMNNAME`
`geom_col` for stacked bar chart of values where `x=COLUMNNAME_A, y=COLUMNNAME_B`

Most common  for bar charts separated by `x` and by some other factor like `color`
: `geom_bar(stat='identity', position='dodge')` 
(equivalent to)
`geom_col(position='dodge')`

```R
barplots.df <- as.data.table(mtcars, keep.rownames=TRUE)[c(1,6,10,20,32)]
setnames(barplots.df, 'rn', 'car')

ggplot(data = barplots.df, aes(x=car, y=mpg)) +
geom_bar()

ggplot(data = barplots.df, aes(x=car, y=mpg)) +
geom_col()

ggplot(data = barplots.df, aes(x=car, y=mpg)) +
geom_bar(stat='identity')

ggplot(data = barplots.df, aes(x=car, y=mpg)) +
geom_col()

ggplot(data = barplots.df, aes(x=car, y=mpg)) +
geom_col(position='dodge')

ggplot(data = barplots.df, aes(x=car, y=mpg)) +
geom_bar(stat='identity', position='dodge')
```

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

# Distributions
ggplot(cars, aes(x=cyl, y=hp)) + geom_boxplot()     # what happens?

ggplot(cars, aes(x=cyl, y=hp, group=cyl)) + geom_boxplot()

ggplot(cars, aes(x=factor(cyl), y=hp)) + geom_boxplot()

# Convert to factor before plotting and it can be called in x as-is
cars$cyl <- as.factor(cyl)
ggplot(cars, aes(x=cyl, y=hp)) + geom_boxplot()

ggplot(cars, aes(x=cyl, y=hp)) + geom_violin()
ggplot(cars, aes(x=cyl, y=hp)) + geom_beeswarm()
ggplot(cars, aes(x=cyl, y=hp)) + geom_jitter()

ggplot(cars, aes(x=mpg)) + geom_histogram()
ggplot(cars, aes(x=mpg)) + geom_histogram(binwidth=1)
ggplot(cars, aes(x=mpg)) + geom_histogram(bins=10)

# Add outline color
ggplot(cars, aes(x=mpg)) + geom_histogram(bins=10, color='black')

# Add fill color
myplot <- ggplot(cars, aes(x=mpg)) + geom_histogram(bins=10, color='black', fill='white')

# Add labels
myplot +
labs(x='Miles Per Galon', y='Frequency', title='Histogram of car Miles Per Galon (MPG)')

```

```R
cars.long <- melt(cars, measure.vars=c('mpg','cyl','disp','hp','drat','wt','qsec','vs','am','gear','carb'))
cars.long[, value := as.numeric(value)]

ggplot(cars.long[variable=='mpg'], aes(x=value)) + geom_histogram()
ggplot(cars.long[variable=='mpg'], aes(x=value)) + geom_histogram()

ggplot(cars.long, aes(x=factor(variable), y=value)) + geom_violin()
```