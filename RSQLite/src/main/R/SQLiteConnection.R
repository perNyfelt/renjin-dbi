#' Class SQLiteConnection (and methods)
#'
#' SQLiteConnection objects are created by passing [SQLite()] as first
#' argument to [DBI::dbConnect()].
#' They are a superclass of the [DBIConnection-class] class.
#' The "Usage" section lists the class methods overridden by \pkg{RSQLite}.
#'
#' @seealso
#' The corresponding generic functions
#' [DBI::dbSendQuery()], [DBI::dbGetQuery()],
#' [DBI::dbSendStatement()], [DBI::dbExecute()],
#' [DBI::dbExistsTable()], [DBI::dbListTables()], [DBI::dbListFields()],
#' [DBI::dbRemoveTable()], and [DBI::sqlData()].
#'
#' @keywords internal
#' @export
setClass("SQLiteConnection",
  contains = "JDBCConnection",
  slots = list(
    dbname = "character",
    loadable.extensions = "logical",
    flags = "integer",
    vfs = "character",
    ref = "environment"
  )
)
#' @rdname SQLiteConnection-class
#' @export
setMethod("dbQuoteIdentifier", c("SQLiteConnection", "character"), function(conn, x, ...) {
  if (any(is.na(x))) {
    stop("Cannot pass NA to dbQuoteIdentifier()", call. = FALSE)
  }
  x <- gsub("`", "``", x, fixed = TRUE)
  if (length(x) == 0L) {
    SQL(character())
  } else {
    # Not calling encodeString() here to keep things simple
    SQL(paste("`", x, "`", sep = ""))
  }
})

#' @rdname SQLiteConnection-class
#' @export
setMethod("dbQuoteIdentifier", c("SQLiteConnection", "SQL"), function(conn, x, ...) {
  SQL(x)
})

#' @rdname SQLiteConnection-class
#' @export
setMethod("show", "SQLiteConnection", function(object) {
  cat("<SQLiteConnection>\n")
  if (dbIsValid(object)) {
    cat("  Path: ", object@dbname, "\n", sep = "")
    cat("  Extensions: ", object@loadable.extensions, "\n", sep = "")
  } else {
    cat("  DISCONNECTED\n")
  }
})
