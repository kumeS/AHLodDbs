##' @title Proxy settings
##'
##' @param Locations a character vector
##'
##' @description This function provides the proxy settings.
##'
##' @author Satoshi Kume
##' @export ProxySet
##'
##' @examples \dontrun{
##'
##' ProxySet(Locations = "OECU")
##'
##' }
##'

ProxySet <- function(Locations){

switch(Locations,
      "OECU" = m <- 1,
      m <- 0
      )

if(m == 1){
proxy_url = "http://wwwproxy.osakac.ac.jp:8080"
Sys.setenv("http_proxy" = proxy_url)
Sys.setenv("https_proxy" = proxy_url)
Sys.setenv("ftp_proxy" = proxy_url)
}

}

