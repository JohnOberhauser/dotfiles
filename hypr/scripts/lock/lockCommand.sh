result="$(okshellctl lock check)"

echo $result

if [ $result = "unlocked" ]; then
  okshellctl lock activate
fi