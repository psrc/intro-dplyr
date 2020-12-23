## Introduction to dplyr

dplyr is a powerful R-package to manipulate, clean and summarize data. It makes data exploration and data manipulation easy and fast in R.


###Overview
dplyr is a grammar of data manipulation, providing a consistent set of verbs that help you solve the most common data manipulation challenges:

From the [dplyr website] (https://dplyr.tidyverse.org/)
* mutate() adds new variables that are functions of existing variables
* select() picks variables based on their names.
* filter() picks cases based on their values.
* summarise() reduces multiple values down to a single summary.
* arrange() changes the ordering of the rows.
* These all combine naturally with group_by() which allows you to perform any operation “by group”. You can learn more about them in vignette("dplyr"). As well as these single-* table verbs, dplyr also provides a variety of two-table verbs, which you can learn about in vignette("two-table").
