datacache <- new.env(hash=TRUE, parent=emptyenv())

salmontranscriptcluster <- function() showQCData("salmontranscriptcluster", datacache)
salmontranscriptcluster_dbconn <- function() dbconn(datacache)
salmontranscriptcluster_dbfile <- function() dbfile(datacache)
salmontranscriptcluster_dbschema <- function(file="", show.indices=FALSE) dbschema(datacache, file=file, show.indices=show.indices)
salmontranscriptcluster_dbInfo <- function() dbInfo(datacache)

salmontranscriptclusterORGPKG <- "org.Ssalar.eg"
salmontranscriptclusterORGANISM <- "Salmo salar"

.onLoad <- function(libname, pkgname)
{
    ## Connect to the SQLite DB
    dbfile <- system.file("extdata", "salmontranscriptcluster.sqlite", package=pkgname, lib.loc=libname)
    assign("dbfile", dbfile, envir=datacache)
    dbconn <- dbFileConnect(dbfile)
    assign("dbconn", dbconn, envir=datacache)

    ## Create the OrgDb object
    sPkgname <- sub(".db$","",pkgname)
    db <- loadDb(system.file("extdata", paste(sPkgname,
      ".sqlite",sep=""), package=pkgname, lib.loc=libname),
                   packageName=pkgname)    
    dbNewname <- AnnotationDbi:::dbObjectName(pkgname,"ChipDb")
    ns <- asNamespace(pkgname)
    assign(dbNewname, db, envir=ns)
    namespaceExport(ns, dbNewname)
        
    packageStartupMessage(AnnotationDbi:::annoStartupMessages("salmontranscriptcluster.db"))
}

.onUnload <- function(libpath)
{
    dbFileDisconnect(salmontranscriptcluster_dbconn())
}

