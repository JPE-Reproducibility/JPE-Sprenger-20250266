 /************************************************************************************************
 Master replication file for "Connecting Common Ratio and Common Consequence Preferences"   	   						 
 Purpose: Runs all code   
 Authors: McGranaghan, Nielsen, O'Donoghue, Somerville, and Sprenger    
 Required programs: estout, unique        
 Computing Environment: Macbook Pro Laptop, Apple M4 Pro, MacOS 26.2, 24 GB of memory, Stata MP 19.5
 Run time: 20 seconds				                                    
 Last edited: 01/19/2026                                                
***************************************************************************************************/
*(A) Paths + Settings
	local folder "Desktop/replication_files" // update based on local directory (e.g. Desktop/replication_files)
	global user  "`c(username)'"
	if "`c(os)'" == "Windows" {
		global dir "C:/Users/$user/`folder'"	
	}
	else if "`c(os)'" == "MacOSX" {
		global dir "/Users/$user/`folder'"
	}
	global stata   "$dir/stata"
	global rdata   "$dir/raw-data"
	global cdata   "$dir/cleaned-data"
	global tables  "$dir/tables"
	global figures "$dir/figures"
	
	* Log file 
	log using "$stata/master_log_file.log", replace
	
	* Set Directory
	cd "$stata"
		
	* Settings
	clear all
	scalar t1 = c(current_time) // start timer
	pause on
	set more off
	set seed 1213
	set scheme s1mono
	version 18
	
	* Install required programs
	foreach p in estout unique binscatter {
		cap which `p'
		if _rc {
			ssc install `p'
			}
	}
	
	
****************************************************************************************************
*(B) Clean and merge the raw data files
	
	* i) Clean the calls data 
	do "$stata/clean_data.do"
	

****************************************************************************************************
*(C) Make figures and tables

	* i) Make Tables from Main Text 
	do "$stata/makeTable2.do"

	* ii) Make Appendix Tables 
	do "$stata/makeAppendixTables.do"

	* iii) Make Figures from Main Text 
	do "$stata/makeFigures3-7.do"

	* iv) Make Appendix Figures 
	do "$stata/makeAppendixFigures.do"
	
	
****************************************************************************************************
*(D) Produce all stats from the text

	* Produce stats
	do "$stata/statsInText.do"

	* Delete temp data
	mi erase types
	mi erase types_canonical
	mi erase types_other
	mi erase types_posterior
	mi erase decomposition
    mi erase posterior_valuations
	mi erase cleaned_data_long
	
	* Stop timer and display run time
	scalar t2 = c(current_time)
	display (clock(t2, "hms") - clock(t1, "hms")) / 1000 " second(s)"

	* Close the log
	log close
