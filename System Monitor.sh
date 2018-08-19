#/bin/bash!
# 
# This script outputs the system information 
# every five minutes to a log file called
# "mySysMontor.log" located in the "home directory"
#
# Author p15237108 Blessing Alfred
#
#
 
time_obs()
{
      	date +"%D %X"
}

#FUNCTIONS

#Outputs the top cpu and ram using processes
cpu_ram_info()
{	echo "------------------------------------------------------------"
	echo "------------------------------------------------------------"
     	echo "TOP $num_of_cpu_prcs CPU PROCESSES RUNNING"  
     	ps -eo user,pcpu,comm,pid | sort -rk 2,2 | head -n $realnum 
     	echo "------------------------------------------------------------" 
     	echo "Top $num_of_cpu_prcs RAM PROCESSES RUNNING"
     	ps -eo user,pmem,comm,pid | sort -rk 2,2 | head -n $realnum
     	echo "------------------------------------------------------------"
     	echo "TOTAL NUMBER OF RUNNING PROCESSES" $(ps aux | wc -l)
     	echo "------------------------------------------------------------"
     	echo "MEMORY INFORMATION"
     	free   
     	echo "------------------------------------------------------------" 
}

#Shows the login information
login_info()
{
     	echo "LOGIN INFORMATION "
     	echo "Current user: $USER"
     	if [ $(id -u) = "0" ]; then
     	   	echo "User id: " $(id -u) ", user has super user access"
     	else
		echo "User id: " $(id -u) ", user does not have super user access"
     	fi
     	echo "------------------------------------------------------------"
     	echo "Login Information and number of users"
     	uptime #gives info of users currently logged on
	echo "Last login: " $(last -n 3)
     	echo "------------------------------------------------------------"
     
}

#shows removable device information 
devices_info()
{
     #Show removable files information
     	echo "REMOVABLE DEVICES"
     	removables=$(df | grep media)
     	rcount=$(df | grep media | wc -l)
     
     	if [ $rcount != "0" ]; then
        	echo "removable devices present"
        	echo "$removables"
       	else
        	echo "removable devices not present"
       	fi
     	echo "------------------------------------------------------------"
     
     
}

#shows the size(free and used) of the disk
disk_usage()
{
     	echo " DISK USAGE STATISTICS "
     	#print in GigaByte and include file system type
     	df -Th
     	echo "------------------------------------------------------------"
     	echo "Amount of space used by current user directory: " $(du -hs ~ | cut -d"/" -f 1)
     	echo "Total number of files in home directory" $(find /home -type f | wc -l)
     	echo "Total number of directories and sub directories in the home folder" $(find /home -type d | wc -l)
     	echo "------------------------------------------------------------"
     
}

#shows network information- interface, throughput, connections and ip address
network_info()
{    
     	#Displays information about the different network interfaces.
     	echo "NETWORK INTERFACE INFORMATION"
     	#used the below because using "ifconfig" requires root permissions.
     	netstat -i
     	echo "------------------------------------------------------------"
     	echo "Overall incoming and outgoing throughput"
     	echo "" $(netstat -ie | grep "RX bytes" | cut -d")" -f 1) ")"
     	echo "" $(netstat -ie | grep "TX bytes" | cut -d")" -f 2) ")"
     	echo "------------------------------------------------------------"
     	echo "Overall incomming and outgoing connections" $(netstat -tu | wc -l)
	echo "IP address: " $(netstat -ie | grep inet | grep Mask | cut -d":" -f 2 | cut -d" " -f 1)
     	echo "------------------------------------------------------------"
}

#shows the amount of open files
openfiles()
{    
     	echo "Total number of open files" $(lsof | wc -l)   
	echo "recently installed programs"
	cat /var/log/dpkg.log | grep install | tail -n 4
}

#contains other system information- processor, kernel, graphics
#boot_time_info()
#{
 #    	
  #	echo "Total number files mounted on the filesystem= " $(mount | wc -l)
   #  	echo "processor information= "
    # 	dmesg | grep processor | cut -d"]" -f 2
    #	echo "kernel version and OS information= "
     #	dmesg | grep -e version | grep Linux | cut -d"]" -f 2
     #	echo "Graphics memory information= "
     #	gra=$(dmesg | grep graphics | cut -d":" -f 2,3)
     #	if [ "$gra" = "" ]; then
	#	echo "No available graphics information"
     	#else
        #	echo "$gra"
     	#fi
     	#echo
#}

#needs root access (Administrator access needed)
#gets size of key system directories and recently modified system files
need_root()
{

     	echo "SIZE OF OTHER SYSTEM FOLDERS"
     	echo "/etc folder: " $(du -hs /etc/ | cut -d"/" -f 1)
     	echo "/root folder: " $(du -hs /root | cut -d"/" -f 1)
     	echo "/boot folder: " $(du -hs /boot | cut -d"/" -f 1)
     	echo "/bin folder: " $(du -hs /bin | cut -d"/" -f 1)
     	echo "/dev folder: " $(du -hs /dev | cut -d"/" -f 1)
     	echo "------------------------------------------------------------"
     	echo "Show recently modified system files within the last five minutes"
     	find -H / -amin -5 | head -n 3
     	echo "------------------------------------------------------------"
}

#
#Logging
#

#log to .html omitting function that requires administrator rights
html_log()
{
     	cat <<- _E0L_
     		<html>
		<head>
		<title> ::::::::::::SYSTEM MONITOR. TIME OF OBSERVATION: $(time_obs):::::::::::::::::::::::: </title>
		</head>
		<body>
			<h1> System Monitor </h1>
			<p> Time of observation: $(time_obs)</p>
			<pre>$(cpu_ram_info)</pre>
     			<pre>$(login_info)</pre>
     			<pre>$(devices_info)</pre>
     			<pre>$(disk_usage)</pre>
     			<pre>$(network_info)</pre>
     			<pre>$(openfiles)</pre>
     			
		</body>
     		</html>    
	_E0L_
}

#log to .html including function that requires administrator rights
root_html_log()
{
     	cat <<- _E0L_
     		<html>
		<head>
		<title> ::::::::::::SYSTEM MONITOR. TIME OF OBSERVATION: $(time_obs):::::::::::::::::::::::: </title>
		</head>
		<body>
			<h1> System Monitor </h1>
			<p> Time of observation: $(time_obs)</p>
			<pre>$(cpu_ram_info)</pre>
     			<pre>$(login_info)</pre>
     			<pre>$(devices_info)</pre>
     			<pre>$(disk_usage)</pre>
     			<pre>$(network_info)</pre>
     			<pre>$(openfiles)</pre>
			<pre>$(need_root)</pre>
		</body>
     		</html>    
	_E0L_
}

#log to .log file omitting function that requires administrator rights
ord_log()
{
     	cat <<- _EOL_
		::::::::::::SYSTEM MONITOR. TIME OF OBSERVATION: $(time_obs)::::::::::::::::::::::::
		$(cpu_ram_info)
     		$(login_info)
     		$(devices_info)
     		$(disk_usage)
     		$(network_info)
     		$(openfiles)
     		
	_EOL_
}

#log to html including function that requires administrator rights
root_log()
{
     	cat <<- _EOL_
		::::::::::::SYSTEM MONITOR. TIME OF OBSERVATION: $(time_obs)::::::::::::::::::::::::
		$(time_obs)
 		$(cpu_ram_info)
     		$(login_info)
        	$(need_root)
     		$(devices_info)
     		$(disk_usage)
     		$(network_info)
     		$(openfiles)
     		
	_EOL_
}


#usage of parameters
usage(){
     	echo "usage: [[-w][-l][-h]]"
	echo "[-h] shows help"
	
}

_help(){
	echo "[-w] outputs to .html file"
	echo "[-l] outputs to .log file"
	
}

#function to choose between root .html and normal user
to_html(){

     	if [ $(id -u) = "0" ]; then
     		html_log >> mySysMonitoR.html
     	else
		html_log >> mySysMonitor.html
     	fi
}

#function to choose between root .log file and normal user
to_o_log(){
     	if [ $(id -u) = "0" ]; then
     		root_log >> mySysMonitoR.log
     	else
		ord_log >> mySysMonitor.log
     	fi
}

#
#MAIN
#
clear
#prompts the user to enter values for processes and interval of logging
echo "***************************************************"
echo "        mySysMonitor  ::::::::  ACTIVATED"
echo "***************************************************"
echo "       Read the documentation for more options"

#if -h is not entered as a parameter for help, it runs the program
#but if -h is entered it shows the help.
if [ "$1" != "-h" ]; then
	echo ""
	echo "Default value for number of cpu/ram processes is 6 "
	echo "Default value for time interval is 300seconds"
	echo ""
	echo -n "Enter the number of cpu/ram processes to monitor: "
	read num_of_prcs
	echo -n "Enter the time interval to print out the log (in seconds): "
	read interval
	realnum=0
	echo "working....................%%....."

	#if user enters nothing it checks and automatically put a fixed value
	#for processess, the fixed value is 6 which will output five top processes
	if [ "$num_of_prcs" != "" ]; then
	realnum=$(($num_of_prcs+1))
	else
	realnum=6
	fi
	#A while loop to run continuously run the script
	#
	while [ true ]; do
	
		if [ "$#" = "0" ]; then
		to_o_log
		else
		if [ "$1" != "" ]; then
     			case $1 in
			-w | --html )		
						to_html
						;;	
			-l | --log) 		to_o_log
						;;
			-h | --help)    	_help
						exit
						;;
			-wl | --htmlandlog)	to_o_log
				   		to_html
						;;
			-lw | --logandhtml)	to_html
				   		to_o_log
						;;
			* )			usage
						exit 1
     			esac
     		
		fi
		fi	
		if [ "$interval" != "" ]; then
			sleep $interval
		else
                	sleep 300s
		fi
	done
fi
if [ "$1" = "-h" ]; then
	echo $(_help)
fi























