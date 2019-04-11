# Windows Scripts

### Honeypot (blocks users who scan)
```
$port = $args[0]
Write "Listen on $port"

$listener = new-object System.Net.Sockets.TcpListener([System.Net.IPAddress]::any, $port)
$listener.ExclusiveAddressUse = $False
while ($True) {

    $listener.start()

    $client = $listener.AcceptTcpClient()
    $ip = $client.Client.RemoteEndPoint
       $ip = $ip.tostring()
       $ip = $ip.split(:)
       $ip = $ip[0]
       write $ip
       netsh advfirewall firewall add rule name=block-$ip dir=in remoteip=$ip protocol=any action=block
       netsh advfirewall firewall add rule name=block-$ip dir=out remoteip=$ip protocol=any action=block
    
      $client.Close()
    $listener.stop()
}      
```

### Add users

#### Domain users
```
Import-csv test.csv | ForEach-Object { New-ADUser -SamAccountName $_.SamAccountName -AccountPassword (ConvertTo-SecureString Pass123 -AsPlainText -force) -Name $_.Name -DisplayName $_.GivenName -Enabled $True -ChangePasswordAtLogon $False }

Import-CSV names.csv | ForEach-Object { New-ADUser -GivenName $_.First -AccountPassword (ConvertTo-SecureString Password123! -AsPlainText -force) -Surname $_.Last -DisplayName ($_.First + " " + $_.Last) -Name ($_.First + " " + $_.Last) -SamAccountName ($_.First[0] + $_.Last) -title $_.title -description $_.title -Enabled $True -ChangePasswordAtLogon $False }
```

OR

```
Import-Module ActiveDirectory 
$Users = Import-Csv .\test.csv
foreach ($User in $Users)  
{  
    $OU = $User.Path
    $Password = "Pass123" 
    $SAM =  $User.SamAccountName
    New-ADUser -Name $SAM -SamAccountName $SAM -DisplayName $user.GivenName -Surname $user.Surname -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $True -ChangePasswordAtLogon $False
} 
```

#### Local users (Powershell)
```
Import-CSV test.csv | ForEach-Object { net users $_.SamAccountName Pass123 /add }
```

OR

```
Import-CSV test.csv | ForEach-Object { New-ADUser -SamAccountName $_.SamAccountName -AccountPassword (ConvertTo-SecureString Pass123 -AsPlainText -force) -Name $_.Name -DisplayName $_.GivenName -ProfilePath $_.Path }
```

#### Local users (Batch)
```
for /F "tokens=1" %i in (test.csv) do net users %i pass123456789! /add
```
