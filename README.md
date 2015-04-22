MyOauth
===================
Лабораторная работа №2 по дисциплине РСОИ, студент Кириенко Дмитрий

Production: 
http://mysterious-sierra-9325.herokuapp.com/

----------
###Последовательность действий

Для получения данных необходимо:
1. Зарегистрировать/авторизовать пользователя на главной странице
2. Зарегистрировать приложение
3. Получить ```access_token```
4. Получить данные

----------
###Получение ```access_token```
Вначале необходимо получить ```code```, для этого нужно сделать **GET** запрос на ```/myoauth/auth``` с обязательными параметрами:

* ```client_id```  - должен совпадать с идентификатором, выданном приложению при его регистрации
* ```redirect_uri``` - адрес, на который будет перенаправлен ```code``` 
* ```response_type``` - необходимое значение - 'code'


Пример запроса:
http://mysterious-sierra-9325.herokuapp.com/myoauth/auth?client_id=fcfc3d7224ee0e13be2032dd1dc188828a62&redirect_uri=http://best.redire.ct&response_type=code

При успешном запросе и подтверждении приложения  будет произведен редирект:
http://best.redire.ct/?code=393e8c60b62f666222424695e0949207c40db665

При отклонении приложения будет произведен редирект:
http://best.redire.ct/?error=access_denied

Если неверно указан ```client_id``` или ```response_type``` :
``` json
{"error":"invalid_request"}
