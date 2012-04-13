mcmcplot <- function(mcmcout, parms=NULL, regex=NULL, random=NULL, leaf.marker="[\\[_]", dir=tempdir(), filename="MCMCoutput", extension="html", title=NULL, heading=NULL, col=NULL, lty=1, xlim=NULL, ylim=NULL, style=c("gray", "plain"), greek=FALSE){
    ## This must come before mcmcout is evaluated in any other expression
    if (is.null(title))
        title <- paste("MCMC Plots: ", deparse(substitute(mcmcout)), sep="")

    style <- match.arg(style)

    ## Turn off graphics device if interrupted in the middle of plotting
    current.devices <- dev.list()
    on.exit( sapply(dev.list(), function(dev) if(!(dev %in% current.devices)) dev.off(dev)) )

    ## Convert input mcmcout to mcmc.list object
    if (!(is.mcmc(mcmcout) | is.mcmc.list(mcmcout)))
        mcmcout <- as.mcmc(mcmcout)
    if (!is.mcmc.list(mcmcout))
        mcmcout <- mcmc.list(mcmcout)

    nchains <- length(mcmcout)
    if (is.null(col)){
        col <- mcmcplotsPalette(nchains)
    }
    htmlfile <- HTMLInitFile(dir, filename, extension, BackGroundColor="#736F6E", Title=title, useLaTeX=FALSE, useGrid=FALSE, CSSFile="")
    if (!is.null(heading))
        cat("<h1 align=center>", heading, "</h1>", sep="", file=htmlfile, append=TRUE)

    ## Select parameters for plotting
    if (is.null(varnames(mcmcout))){
        warning("Argument 'mcmcout' did not have valid variable names, so names have been created for you.")
        varnames(mcmcout) <- varnames(mcmcout, allow.null=FALSE)
    }
    parnames <- parms2plot(varnames(mcmcout), parms, regex, random, leaf.marker, do.unlist=FALSE)
    if (length(parnames)==0)
        stop("No parameters matched arguments 'parms' or 'regex'.")
    np <- length(unlist(parnames))

    HTML('<div id="toc">')
    for (group.name in names(parnames)) {
        HTML(sprintf('<p class="toc_entry"><a href="#%s">%s</a></p>', group.name, group.name))
    }
    HTML('</div>')

    htmlwidth <- 640
    htmlheight <- 480
    for (group.name in names(parnames)) {
        HTML(sprintf('<center><h2><a name="%s">Plots for %s</a></h2></center>', group.name, group.name))
        for (p in parnames[[group.name]]) {
            pctdone <- round(100*match(p, unlist(parnames))/np)
            cat("\r", rep(" ", getOption("width")), sep="")
            cat("\rPreparing plots for ", group.name, ".  ", pctdone, "% complete.", sep="")
            gname <- paste(p, ".png", sep="")
            png(file.path(dir, gname), width=htmlwidth, height=htmlheight)
            mcmcplot1(mcmcout[, p, drop=FALSE], col=col, lty=lty, xlim=xlim, ylim=ylim, style=style, greek=greek)
            dev.off()
            HTMLInsertGraph(gname, file=htmlfile, WidthHTML=htmlwidth, HeightHTML=htmlheight)
        }
    }
    cat("\r", rep(" ", getOption("width")), "\r", sep="")
    HTMLEndFile(htmlfile)
    full.name.path <- paste("file://", htmlfile, sep="")
    browseURL(full.name.path)
    invisible(full.name.path)
}
