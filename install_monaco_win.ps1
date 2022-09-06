mkdir -Force ~/.fonts
Set-Location ~/.fonts

Invoke-WebRequest -OutFile monaco.ttf https://github.com/taodongl/monaco.ttf/raw/master/monaco.ttf
./monaco.ttf
