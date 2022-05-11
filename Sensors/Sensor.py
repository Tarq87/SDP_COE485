from gpiozero import DistanceSensor
from time import sleep,time,ctime
import requests

counter = 0
sensor = DistanceSensor(echo=18, trigger=17)
while True:
    Dis=sensor.distance
    t=time()
    print('Distance: ',Dis, '                   time',ctime(t) )
    if (Dis<0.2):
        
        td=ctime(t)
        payload={"td": td}
        print('Passenger Exit the bus: ',Dis, '   time  :',ctime(t))
        r= requests.post('https://db730626-6988-4ac5-afec-67b96f419fab.mock.pstmn.io/cv/qw',json=payload)
        print (r.text)
    sleep(0.4)