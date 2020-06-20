#!/bin/bash
echo "Let's install cjdns"
sudo apt-get install nodejs git build-essential python2.7

#Скачаем cjdns из github
cd ~/'Рабочий стол'/'Bash labs'
git clone https://github.com/cjdelisle/cjdns.git cjdns
cd cjdns

#Компилируем
./do
#Дождитесь сообщения Build completed successfully, type ./cjdroute to begin setup., и как только оно появится — действуйте дальше:

#Установка
#Запустим cjdroute без параметров для отображения информации и доступных опций:
echo "=================================="
./cjdroute

#Убедитесь, что у вас всё установлено корректно.
answer=$(echo LANG=C cat /dev/net/tun )

#Если ответ: cat: /dev/net/tun: File descriptor in bad state,то всё отлично!
#Если ответ: cat: /dev/net/tun: No such file or directory,то просто создайте его:

if [[ "$answer" == "cat: /dev/net/tun: No such file or directory" ]]
then sudo mkdir /dev/net ; sudo mknod /dev/net/tun c 10 200 && sudo chmod 0666 /dev/net/tun
else echo "Everything is ok"
fi

answer=$(echo cat /dev/net/tun)
if [[ "$answer" == "cat: /dev/net/tun: Permission denied" ]]
then echo "Ask your provider to turn on TUN\TAP protocol"
fi

#Если ответ: cat: /dev/net/tun: Permission denied, вы скорее всего используете виртуальный сервер (VPS) на основе технологии виртуализации OpenVZ. Попросите своего провайдера услуг включить TUN/TAP устройство, это стандартный протокол, ваш провайдер должен быть в курсе.

#Генерируем новый файл с настройками
./cjdroute --genconf >> cjdroute.conf

#Запускаем cjdns
echo "RUN cjdns"
sudo ./cjdroute < cjdroute.conf

#wait 20 seconds
sleep 20

#Остановка cjdns
echo "STOP cjdns"
sudo killall cjdroute
