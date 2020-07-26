echo "Checking page count ..."
pages=($(curl -s https://www.vulnhub.com/ | grep "page=" | sed 's/=/ /g' | sed 's/\"/ /g' | awk '{print $4}' | grep -v "<\|>" | sort -d))

#pick a random page number
random=$$$(date +%s)
selected=${pages[$random % ${#pages[@]}]}
boxlinks=($(curl -s https://www.vulnhub.com/?page=7 | grep "<h1><a href=\"/entry/" | sed 's/\"/ /g' | awk '{print $3}'))

#pick a random page box
echo "Picking a box from page $selected ..."
random=$$$(date +%s)
boxpage=${boxlinks[$random % ${#boxlinks[@]}]}
echo "Name: $(curl -s https://www.vulnhub.com$boxpage | grep "<h1 class=\"header-inline\"><a href=\"/entry/" | sed 's@<h1 class="header-inline"><a href="/entry/@@g' | sed 's@</a></h1>@@g' | sed s'/>/ /g' | cut -d" " -f2-)"
echo "Link: https://www.vulnhub.com$boxpage"
difficulty="$(curl -s https://www.vulnhub.com$boxpage | grep -i difficulty | sed 's/</ /g' | sed 's/>/ /g' | cut -d" " -f3- | awk 'NF{NF-=1};1' | head -n 1)"
if [ -z "$difficulty" ]; then
        echo "Difficulty: Unknown"
else
        echo "$difficulty"
fi
