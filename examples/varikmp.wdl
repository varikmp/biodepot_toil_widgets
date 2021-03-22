workflow write_simple_file
{
	call write_file
}

task write_file
{
	String message
	command { echo ${message} > varikmp.wdl.txt }
	output { File test = "varikmp.wdl.txt" }
}
