#!/bin/bash
if [ -n "$1" -a -n "$2" ] ; then
SV=$1
ID=$2
else
read -p "SERVER NUMBER (ex. 192.168.179.XX) :" SV
read -p "Data Object ID:" ID
fi

#SV=42
CHAR="UTF-8"
FILENAME="temp"
TYPE="csv"
API="https://192.168.179.$SV:8080/hyperdata8/dataobjects/$ID/download/sql/?fileName=$FILENAME&contentType=$TYPE&sql=SELECT%20*%20FROM%20DATA_OBJECT_ID&charset=$CHAR"


echo "";echo "**********GET AUTH TOKEN**********"echo "";
AUTH=`curl --location --request POST "http://192.168.179.$SV:28080/proauth/oauth/authenticate" \
--header 'Cookie: JSESSIONID=6gEODXYbO5Caisz1bKncfnvSKoocaOavYNL7arb9eP6pFF12pxui5BU4rRQz4Tgy.ZG9tYWluMS9Qcm9BdXRo' \
--form 'user_id=admin' \
--form 'password=admin' | jq '.dto.token' | tr -d '"'`
echo ""; 
echo "AUTH : $AUTH" ;echo ""; echo ""; echo ""; echo ""


ROWNUM=`curl --location --request GET "https://192.168.179.$SV:8080/hyperdata/web-service/dataobjects/$ID/?action=RowCount" --header "Authorization: $AUTH" --header 'userId: admin' --header 'Cookie: JSESSIONID=WtS9dFzXXlaNt0fOIGXJenhQkETttbWYYUbxOMOha4J1o1mHpgBbosOgotBqgEXl.ZG9tYWluMS9oeXBlcmRhdGE=' --insecure | jq '.dto.numRows' `
echo ""; echo "";echo "ROW NUM : $ROWNUM"; echo "";

echo "********************COLUMN LIST*********************"
echo ""
curl --location --request GET "https://192.168.179.$SV:8080/hyperdata/web-service/dataobjects/$ID/?action=Desc" --header "Authorization: $AUTH" --header 'userId: admin' --header 'Cookie: JSESSIONID=WtS9dFzXXlaNt0fOIGXJenhQkETttbWYYUbxOMOha4J1o1mHpgBbosOgotBqgEXl.ZG9tYWluMS9oeXBlcmRhdGE=' --insecure | jq -c '.dto.colInfoList'| jq -c '[.[] | .name]'
echo ""
echo ""
echo "************** csv Download Start**************"
TYPE="csv"
rm -rf temp.$TYPE
time curl --location --request GET "https://192.168.179.$SV:8080/hyperdata8/dataobjects/$ID/download/sql/?fileName=$FILENAME&contentType=$TYPE&sql=SELECT%20*%20FROM%20DATA_OBJECT_ID&charset=$CHAR" --header "Authorization: $AUTH" --header "userId: admin" -o temp.$TYPE --insecure

#time curl --location --request GET "http://192.168.179.42:8500/hyperdata8/dataobjects/$ID/download/sql/?fileName=$FILENAME&contentType=$TYPE&sql=SELECT%20*%20FROM%20DATA_OBJECT_ID&charset=$CHAR"\
#--header "Authorization: $AUTH" \
#--header "userId: admin" -o "temp.$TYPE"

echo "";echo "Down Loaded File Line Count : $(time cat temp.csv | wc -l)"
echo "DO's Line Count In Hyperdata API : $ROWNUM"
echo ""
echo "API REQUESTED Charset :$CHAR"
file -bi temp.$TYPE

echo ""
echo ""
echo "json"
echo "************** json Download Start**************"
TYPE="json"
rm -rf temp.$TYPE
time curl --location --request GET "https://192.168.179.$SV:8080/hyperdata8/dataobjects/$ID/download/sql/?fileName=$FILENAME&contentType=$TYPE&sql=SELECT%20*%20FROM%20DATA_OBJECT_ID&charset=$CHAR" --header "Authorization: $AUTH" --header "userId: admin" -o temp.$TYPE --insecure
echo "";echo "Down Loaded File Line Count : $(time cat temp.json | jq length)"
echo "DO's Line Count In Hyperdata API : $ROWNUM"
echo ""
echo ""
echo "API REQUESTED Charset :$CHAR"
file -bi temp.$TYPE

echo ""
echo "************** xml Download Start**************"
TYPE="xml"
rm -rf temp.$TYPE
time curl --location --request GET "https://192.168.179.$SV:8080/hyperdata8/dataobjects/$ID/download/sql/?fileName=$FILENAME&contentType=$TYPE&sql=SELECT%20*%20FROM%20DATA_OBJECT_ID&charset=$CHAR" --header "Authorization: $AUTH" --header "userId: admin" -o temp.$TYPE --insecure
echo "";echo "Down Loaded File Line Count : $(perl -nle "print s/<Row>//g" < temp.xml | awk '{total += $1} END {print total}')"
echo "DO's Line Count In Hyperdata API : $ROWNUM"

echo ""
echo "API REQUESTED Charset :$CHAR"
file -bi temp.$TYPE
echo ""

echo "************** xlsx Download Start**************"
TYPE="xlsx"
rm -rf temp.$TYPE
time curl --location --request GET "https://192.168.179.$SV:8080/hyperdata8/dataobjects/$ID/download/sql/?fileName=$FILENAME&contentType=$TYPE&sql=SELECT%20*%20FROM%20DATA_OBJECT_ID&charset=$CHAR" --header "Authorization: $AUTH" --header "userId: admin" -o temp.$TYPE --insecure

echo "";echo "Down Loaded File Line Count : $(time cat temp.xlsx | wc -l)"
echo "DO's Line Count In Hyperdata API : $ROWNUM"
echo ""
echo ""
echo "API REQUESTED Charset :$CHAR"
file -bi temp.$TYPE
