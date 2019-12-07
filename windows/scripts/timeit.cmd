@echo OFF

set start_time=%TIME%

call %*

set end_time=%TIME%

echo "Start: %start_time%"
echo "Ended: %end_time%"