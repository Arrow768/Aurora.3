/// When a query has been created but not started
#define DB_QUERY_NEW 1
/// When a query has been queued up for execution/is being executed
#define DB_QUERY_STARTED 2
/// When a query is finished executing
#define DB_QUERY_FINISHED 3
/// When there was a problem with the execution of a query.
#define DB_QUERY_BROKEN 4
