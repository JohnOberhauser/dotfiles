result="$(okshellctl lock check)"

echo $result

if [ $result = "locked" ]; then
  systemctl suspend
fi