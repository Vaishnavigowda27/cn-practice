# 9

set ns [new Simulator]
set tr [ open out.tr w ]
$ns trace-all $tr
set nam [ open out.nam w ]
$ns namtrace-all $nam
set n0 [$ns node]
set n1 [$ns node]
$ns duplex-link $n0 $n1 0.2Mb 200ms DropTail
set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n1 $sink
$ns connect $tcp $sink
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $tcp
$tcp set fid_ 1
$sink set fid_ 1
$cbr set packetSize_ 1000
$cbr set interval_ 0.2
$tcp set window_size_ 3
$ns at 0.0 "$cbr start"
$ns at 10.0 "finish"
proc finish {} {
    global ns tr nam
    $ns flush-trace
    close $tr
    close $nam
    exec nam out.nam &
    exit 0
}
$ns run