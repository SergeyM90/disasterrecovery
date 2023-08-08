# disasterrecovery
Домашнее задание по тему "Disaster recovery и Keepalived". Сергей Миронов-SYS-20.

# Задание 1  
Дана схема для Cisco Packet Tracer, рассматриваемая в лекции.  
На данной схеме уже настроено отслеживание интерфейсов маршрутизаторов Gi0/1 (для нулевой группы)  
Необходимо аналогично настроить отслеживание состояния интерфейсов Gi0/0 (для первой группы).  
Для проверки корректности настройки, разорвите один из кабелей между одним из маршрутизаторов и Switch0 и запустите ping между PC0 и Server0.  
На проверку отправьте получившуюся схему в формате pkt и скриншот, где виден процесс настройки маршрутизатора.  

# Решение  

Получившаяся схема pkt:  
https://github.com/SergeyM90/disasterrecovery/blob/main/hsrp.pkt  

При связности сети между роутерами и свичами сигнал идет от PC0 из сети 192.168.0.0/24 в сторону сервера через роутер 1 а в обратную сторону из сети 192.168.1.0/24 через роутер 2:  

Для этого на интерфейсах роутеров зеркально настроен параметр standby priority 100 и 105  

![cisco_connected](https://github.com/SergeyM90/disasterrecovery/assets/84016375/b0d0b672-c76c-4aae-aa89-86a52b5b500e)

При обрыве связи между одним из роутеров и свичом все пакеты идут через оставшийся роутер.  

![cisco_disconnect](https://github.com/SergeyM90/disasterrecovery/assets/84016375/0e99f464-59dc-4fba-8779-f53a37135fd9)

Команды на роутере:  

![cisco_packet_tracer](https://github.com/SergeyM90/disasterrecovery/assets/84016375/08876882-4f97-4d34-a07a-03e7cada2996)


# Задание 2
Запустите две виртуальные машины Linux, установите и настройте сервис Keepalived как в лекции, используя пример конфигурационного файла.
Настройте любой веб-сервер (например, nginx или simple python server) на двух виртуальных машинах
Напишите Bash-скрипт, который будет проверять доступность порта данного веб-сервера и существование файла index.html в root-директории данного веб-сервера.
Настройте Keepalived так, чтобы он запускал данный скрипт каждые 3 секунды и переносил виртуальный IP на другой сервер, если bash-скрипт завершался с кодом, отличным от нуля (то есть порт веб-сервера был недоступен или отсутствовал index.html). Используйте для этого секцию vrrp_script
На проверку отправьте получившейся bash-скрипт и конфигурационный файл keepalived, а также скриншот с демонстрацией переезда плавающего ip на другой сервер в случае недоступности порта или файла index.html

# Решение

Конфигурация на которой в итоге выполнил домашнее задание:  
CentOS 7, Keepalived v1.3.5, nginx/1.20.1  

На скриншоте:  
Сверху - BACKUP сервер в дебаг режиме с выводом логов в консоль /usr/sbin/keepalived -l -D -n  

Внизу слева - страница в браузере с адресом VIP сервера, страница выводится со второй машины.  

Внизу справа - консоль второй машины.  

На сетевом интерфейсе enp0s3 висит адрес VIP, после перемещения файла index.html - этот адрес удаляется с интерфейса, а в логах бэкап сервера видна смена статуса.  

![1 (1)](https://github.com/SergeyM90/disasterrecovery/assets/84016375/82ed753b-bed4-459a-9dd6-88094518538c)

Конфигурация keepalived MASTER:

[keepalived.conf](https://github.com/SergeyM90/disasterrecovery/blob/main/keepalived.conf)

Скрипт проверки наличия файла и открытого порта:

https://github.com/SergeyM90/disasterrecovery/blob/main/check.sh
https://github.com/SergeyM90/disasterrecovery/blob/main/check.sh
