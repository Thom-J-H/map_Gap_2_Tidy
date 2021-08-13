# map_Gap_2_Tidy
Mapping Gapminder.org Data Sets with the Tidyverse -- Keeping it Simple as Possible.


If we want to do a simple [Choropleth maps](https://en.wikipedia.org/wiki/Choropleth_map) in the Tidyverse, and so likely using `ggplot2::map_data("world")`, we might get a result like this when our mapping data and Global Studies data have name mismatches or missing information:

![fail_bad](https://user-images.githubusercontent.com/12042357/129316416-d6fdceeb-8d83-4521-8737-255afc89373b.png)


Instead, we want to fail gracefully. NA cases should be displayed: knowing that we have no data for certain nations is both important and useful. The following would better serve:

![fail_better](https://user-images.githubusercontent.com/12042357/129316825-81e82867-661e-4564-9d5c-38f6512ff38c.png)

Our updated version, `world_map2`, both allows for graceful failure when data is missing, and contains the standard ISO country codes: [Alpha-2 code](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2), [Alpha-3 code](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3), and [Numeric code](https://en.wikipedia.org/wiki/ISO_3166-1_numeric).

So we no longer need to rely on name matching if our statistical data uses the ISO country codes as identifiers.  The markdown document explaining the making of `world_map2` is archived here at GitHub and [published at RPubs](https://rpubs.com/Thom_JH/world_map2). The updated data set is available here.

Thank you for reading,
TJ Haslam


