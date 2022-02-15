# map_Gap_2_Tidy
**Mapping Gapminder.org Data Sets with the Tidyverse -- Keeping it Simple as Possible.**

1. [Updating ggplot::map_data('world')](https://rpubs.com/Thom_JH/world_map2) :: Making of `world_map2`. 
2. [Using world_map2](https://rpubs.com/Thom_JH/using_world_map2) ::  Case studies using `world_map2`. 

<hr />

If we want to do simple [Choropleth maps](https://en.wikipedia.org/wiki/Choropleth_map) in the Tidyverse, and so likely using `ggplot2::map_data("world")`, we might get a result like this when our mapping data and Global Studies data have name mismatches or missing information:

![fail_bad](https://user-images.githubusercontent.com/12042357/129316416-d6fdceeb-8d83-4521-8737-255afc89373b.png)

The white spaces for Afghanistan and various nations in Africa and Southeast Asia are unnecessarily confusing. Missing data does not mean these nations were replaced by ocean or otherwise ceased to exist.

### Fail Gracefully
Instead, we want to fail gracefully. NA cases should be displayed: knowing that we have no data for certain nations is both important and useful. The following would better serve:

![fail_better](https://user-images.githubusercontent.com/12042357/129316825-81e82867-661e-4564-9d5c-38f6512ff38c.png)

Our updated version, `world_map2`, both allows for graceful failure when data is missing, and contains the standard ISO country codes: [Alpha-2 code](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2), [Alpha-3 code](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3), and [Numeric code](https://en.wikipedia.org/wiki/ISO_3166-1_numeric).

A markdown document [Using world_map2](https://rpubs.com/Thom_JH/using_world_map2) offers examples in Tidying and mapping Global Studies data sets with [world_map2](https://github.com/Thom-J-H/map_Gap_2_Tidy/blob/main/world_map2_project.rda).  The same document is also archived here.


### Greater Interoperability
So we no longer need to rely on name matching if our statistical data uses the ISO country codes as identifiers.  The markdown document explaining the making of `world_map2` is archived here at GitHub and [published at RPubs](https://rpubs.com/Thom_JH/world_map2). The updated data set is available here.

Thank you for reading! Please feel free to improve [world_map2](https://github.com/Thom-J-H/map_Gap_2_Tidy/blob/main/world_map2_project.rda).

TJ Haslam

2021-08-13

<hr />

Reports @ RPubs:

1. [Updating ggplot::map_data('world')](https://rpubs.com/Thom_JH/world_map2) :: Making of `world_map2`. 

2. [Using world_map2](https://rpubs.com/Thom_JH/using_world_map2) ::  Case studies using `world_map2`. 



<p xmlns:dct="http://purl.org/dc/terms/" xmlns:vcard="http://www.w3.org/2001/vcard-rdf/3.0#">
  <a rel="license"
     href="http://creativecommons.org/publicdomain/zero/1.0/">
    <img src="https://licensebuttons.net/p/zero/1.0/88x31.png" style="border-style: none;" alt="CC0" />
  </a>
  <br />
  To the extent possible under law,
  <a rel="dct:publisher"
     href="https://github.com/Thom-J-H/map_Gap_2_Tidy">
    <span property="dct:title">Thomas Joseph Haslam</span></a>
  has waived all copyright and related or neighboring rights to
  <span property="dct:title">Mapping Global Studies Data with the Tidyverse</span>.
This work is published from:
<span property="vcard:Country" datatype="dct:ISO3166"
      content="US" about="https://github.com/Thom-J-H/map_Gap_2_Tidy">
  United States</span>.
</p>
