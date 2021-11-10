# AHLodDbs
Supplies AnnotationHub with some preprocessed tibble datasets of wikidata N-triple dump and other RDF datasets.
The original dataset is available in [Google Drive](https://drive.google.com/drive/folders/1jw96Cf2flGJLnKswcPf7XQ9Ia7vhU3Hv?usp=sharing).

## [Data source (GoogleDrive)](https://drive.google.com/drive/folders/1jw96Cf2flGJLnKswcPf7XQ9Ia7vhU3Hv?usp=sharing)

## Installation

1. Start R.app

2. Run the following commands in the R console.

```r
install.packages( "devtools" )
devtools::install_github( "kumeS/AHLodDbs" )
library( "AHLodDbs" )
```

An alternative way, type the code below in the R console window if you install Git command.

```r
system( "git clone https://github.com/kumeS/AHLodDbs.git" )
system( "R CMD INSTALL AHLodDbs" )
library( "AHLodDbs" )
```

## License
Copyright (c) 2021 Satoshi Kume released under the [Artistic License 2.0](http://www.perlfoundation.org/artistic_license_2_0).

## Authors

- Satoshi Kume

