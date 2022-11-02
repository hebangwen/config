Set-ExecutionPolicy  -ExecutionPolicy ByPass -Scope Process

$ipv4 = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "WLAN").IPAddress
Write-Output "WLAN IP Address: $ipv4"

# ipv4=`ifconfig eth0.1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1 }'`


Write-Output "Start to connect to portal..."
$stu_id = ""
$stu_pwd = ""

if ($stu_id -eq "") {
    $stu_id = Read-Host -Prompt "Student id is empty, please enter your student id"
}

if ($stu_pwd -eq "") {
    $stu_pwd = Read-Host -Prompt "Password is empty, please entry your password" -AsSecureString
}

$URI = "http://10.1.1.1:801/eportal/portal/login"
# $URI = "http://10.1.1.1:801/eportal/portal/logout"
$Parameters = @{
    callback = "dr1004"
    login_method = "1"
    user_account = ",0,$stu_id"
    user_password = $stu_pwd
    # user_account = "drcom"
    # user_password = "123"
    wlan_user_ip = $ipv4
    wlan_user_ipv6 = ""
    wlan_user_mac = "000000000000"
    wlan_ac_ip = ""
    wlan_ac_name = ""
    jsVersion = "4.1.3"
    terminal_type = "1"
    lang = "en"
    v = "9748"
}

Write-Output $Parameters

$UA = "user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36"

$response = Invoke-WebRequest -UserAgent $UA -Uri $URI -Body $Parameters -UseBasicParsing
while (($null -eq $response)) {
    $response = Invoke-WebRequest -UserAgent $UA -Uri $URI -Body $Parameters -UseBasicParsing
}

Write-Output "Portal response: $response"

# TODO: 判断是否成功登录

$result = Test-Connection -ComputerName 10.147.20.2

while ($null -eq $result) {
    $result = Test-Connection -ComputerName 10.147.20.2
}

foreach ($pingResponse in $result) {
    $latency = $pingResponse.ResponseTime
    Write-Output "latency: ${latency}ms"
}

cmd /c "pause"
