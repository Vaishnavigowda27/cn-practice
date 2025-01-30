# Implement 3 nodes point to point network with duplex link between them . Set the queue size, vary the bandwidth and find the number of packets dropped.
set ns [new Simulator]
set tf [open lab1.tr w]
$ns trace-all $tf
set nf [open lab1.nam w]
$ns namtrace-all $nf

proc finish { } {
global ns nf tf
$ns flush-trace
close $nf
close $tf
exec nam lab1.nam &
exec echo "Total number of packets dropped" &
exec grep -c "^d" lab1.tr &
exit 0
}
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

$ns duplex-link $n0 $n1 1Mb 10ms DropTail 
$ns duplex-link $n1 $n2 1Mb 10ms DropTail

$ns queue-limit $n0 $n1 10
$ns queue-limit $n1 $n2 10

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n2 $sink
$ns connect $tcp $sink

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $tcp

$ns at 0.0 "$cbr start"
$ns at 2.0 "finish"
$ns run
