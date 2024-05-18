sjh='*1*2'
sl1=$(echo ${sjh} | grep -o "[\\*][0-9]" | wc -l)
sl2=$(echo ${sjh} | grep -o "[0-9][\\*]\{1,\}$" | wc -l)
sl=$((${sl1}+${sl2}))
for i in $(seq ${sl1});do
eval sm${i}=$(($(echo ${sjh} | grep -o "[\*]\{1,\}[0-9]" | awk NR==${i}'{print $0}' | wc -m)-2))
done
for j in $(seq ${sl2});do
zh=$((${j}+${sl1}))
eval sm${zh}=$(($(echo ${sjh} | grep -o "[0-9][\\*]*$" | awk NR==${j}'{print $0}' | wc -m)-2))
done
sjha=$(echo ${sjh} | tr -s "*")
for i in $(seq $((${sl}+1)));do
res=$(echo ${sjha} | awk -v test=${i} -F "*" '{print $test}')
array[$((2*${i}-1))]=${res}
done
i=0
j=1
text () {
i=$((${i}+1))
for n in $(seq -w 0 $(eval echo "10^\${sm${i}}-1" | bc));do
array[$((2*${i}))]=${n}
if [[ ${n} -eq $(eval echo "10^\${sm${i}}-1" | bc) && ${j} -eq ${sl} ]];then
j=$((${j}-1))
i=$((${i}-1))
return
fi
if [ ${j} -lt ${sl} ];then
j=$((${j}+1))
text
fi
for k in ${array[@]};do
#echo ${k}
mix="${mix}${k}"
done
echo ${mix}
unset mix
done
}
text
