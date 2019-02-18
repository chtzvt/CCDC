$port = $args[0]
Write "Listen on $port"

$listener = new-object System.Net.Sockets.TcpListener([System.Net.IPAddress]::any, $port)
$listener.ExclusiveAddressUse = $False
while ($True) {

    $listener.start()

    $client = $listener.AcceptTcpClient()
    $ip = $client.Client.RemoteEndPoint
       $ip = $ip.tostring()
       $ip = $ip.split(‘:’)
       $ip = $ip[0]
       write $ip
       netsh advfirewall firewall add rule name=block-$ip dir=in remoteip=$ip protocol=any action=block
       netsh advfirewall firewall add rule name=block-$ip dir=out remoteip=$ip protocol=any action=block
    
      $client.Close()
    $listener.stop()
}      