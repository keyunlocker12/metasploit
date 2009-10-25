# $Id:$

## Meterpreter script that display local subnets
## Provided by Nicob <nicob [at] nicob.net>
## Ripped from http://blog.metasploit.com/2006/10/meterpreter-scripts-and-msrt.html

@@exec_opts = Rex::Parser::Arguments.new(
	"-h" => [ false,"Help menu." ]
)

@@exec_opts.parse(args) { |opt, idx, val|
	case opt
	when "-h"
		print_line("Get a list of local subnets based on the host's routes")
		print_line("USAGE: run get_local_subnets")
		puts @@exec_opts.usage
		raise "Usage"
	end
}

client.net.config.each_route { |route|
    # Remove multicast and loopback interfaces
    next if route.subnet =~ /^(224\.|127\.)/
    next if route.subnet == '0.0.0.0'
    next if route.netmask == '255.255.255.255'
    print_line("Local subnet: #{route.subnet}/#{route.netmask}")
}
