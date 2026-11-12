datacache <- new.env(hash=TRUE, parent=emptyenv())

sstranscriptcluster <- function() showQCData("sstranscriptcluster", datacache)
sstranscriptcluster_dbconn <- function() dbconn(datacache)
sstranscriptcluster_dbfile <- function() dbfile(datacache)
sstranscriptcluster_dbschema <- function(file="", show.indices=FALSE) dbschema(datacache, file=file, show.indices=show.indices)
sstranscriptcluster_dbInfo <- function() dbInfo(datacache)

sstranscriptclusterORGPKG <- "org.Ssalar.eg"
sstranscriptclusterORGANISM <- "Salmo salar"

.onLoad <- function(libname, pkgname)
{
    ## Connect to the SQLite DB
    dbfile <- system.file("extdata", "sstranscriptcluster.sqlite", package=pkgname, lib.loc=libname)
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
        
    packageStartupMessage(AnnotationDbi:::annoStartupMessages("sstranscriptcluster.db"))
}

.onUnload <- function(libpath)
{
    dbFileDisconnect(sstranscriptcluster_dbconn())
}

