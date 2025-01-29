#Ping message
set ns [new Simulator]
set nf [open lab2.nam w]
$ns namtrace-all $nf
set tf [open lab2.tr w]
$ns trace-all $tf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n2 200Mb 10ms DropTail
$ns duplex-link $n1 $n2 200Mb 10ms DropTail
$ns duplex-link $n2 $n3 0.005Mb 10ms DropTail
$ns duplex-link $n3 $n4 200Mb 10ms DropTail
$ns duplex-link $n3 $n5 200Mb 10ms DropTail

set p1 [new Agent/Ping]
set p2 [new Agent/Ping]
set p3 [new Agent/Ping]
set p4 [new Agent/Ping]
set p5 [new Agent/Ping]

$ns attach-agent $n0 $p1
$ns attach-agent $n1 $p2
$ns attach-agent $n2 $p3
$ns attach-agent $n3 $p4
$ns attach-agent $n4 $p5

Agent/Ping instproc recv {from rtt} {
$self instvar node_
puts "node [$node_ id] received answer from $from with round trip time $rtt msec"
}

$ns connect $p1 $p5
$ns connect $p3 $p4
$ns connect $p2 $p5

proc finish { } {
global ns nf tf
$ns flush-trace 
close $tf
close $nf
exec nam lab2.nam &
exec echo "No of packets dropped" &
exec grep -c "^d" lab2.nam &
exit 0
}

set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set p1 [new Application/Traffic/CBR]

$p1 set packetsize_ 500
$p1 set interval_ 0.005
$p1 attach-agent $udp0
set null0 [new Agent/Null]

$ns attach-agent $n3 $null0
$ns connect $udp0 $null0

$ns at 0.1 "$p1 start"
$ns at 0.7 "finish"

$ns run
