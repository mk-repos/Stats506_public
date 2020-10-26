/* ------------------------------------------------------------------------- *
 * An example SAS program for Stats 506.
 *
 * This file imports RECS data from:
 *   ./data/recs2009_public.csv
 *   http://www.eia.gov/consumption/residential/data/2009/index.cfm?view=microdata
 *
 * Then prints some basic information about the file.
 *
 * Author: James Henderson
 * Updated: October 17, 2020
 * ------------------------------------------------------------------------- *
*/
/* 79: --------------------------------------------------------------------- */

/* data library for reading/writing data: ---------------------------------- */
libname mylib '~/github/Stats506_F20/examples/sas/data/';

/* Create a data set recs referring to existing file: ---------------------- */
data recs; /* Question: what library is this in? */
 set mylib.recs2009_public_v4;  

proc contents data=recs;

proc print data=mylib.recs2009(obs=5);
 var DOEID;

proc print data=recs(obs=5);
 var DOEID;

run;

/* 79: --------------------------------------------------------------------- */   