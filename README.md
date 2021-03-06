MyOauth
===================
Лабораторная работа №2 по дисциплине РСОИ, студент Кириенко Дмитрий

Production: 
http://mysterious-sierra-9325.herokuapp.com/

----------
###Последовательность действий

Для получения данных необходимо:
1. Зарегистрировать/авторизовать пользователя на главной странице ;
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
{
  "error":"invalid_request"
}
```
----------

После получения ```code``` необходимо сделать **POST** запрос на ```/myoauth/token``` с обязательными параметрами:

* ```code``` - был получен на предыдущем шаге
* ```client_id``` - должен соответствовать ```client_id```, который использовался для получения ```code```
* ```client_secret``` - выдавался в паре с ```client_id``` при регистрации приложения  
* ```redirect_uri``` - адрес на который будет перенаправлен ответ
* ```grant_type``` -  необходимое значение - 'grant_type'

Пример запроса:
http://mysterious-sierra-9325.herokuapp.com/myoauth/token?client_id=fcfc3d7224ee0e13be2032dd1dc188828a62&redirect_uri=best.redire.ct&grant_type=grant_type&code=688ad5315bb79b9c9dd60ea4d853e29125e07dd7&client_secret=a4db93fcc214cd99bf46a53236012f8d53b9b016cbf3258dbaa6351531f0b3002ba8f839fb89eeac74f796068c5728e5e5e5

Ответ:

```json
{       
  "access_token":"9d2a755a78292c3d1bcf749f47f5925332297080",
  "expires_in":"120",
  "token_type":"Bearer",
  "refresh_token":"5d64c0cb1b6a4b3ae0c595e809d9720a8a25b9ad"
}
```
Если неверно указан ```code``` :
```json
{
  "error":"invalid_request",
  "error_description":"code is invalid"
}
```

Если неверно указан ```client_id``` :
```json
{
  "error":"invalid_request",
  "error_description":"client_id is invalid"
}
```

Если неверно указан ```grant_type``` :
```json
{
  "error":"invalid_request"
}
```

Если неверно указан ```client_secret``` :
```json
{
  "error":"invalid_request",
  "error_description":"client_secret is invalid"
}
```
----------

###Получение ```refresh_token```
Для получения ```refresh_token``` необходимо сделать **POST** запрос на ```/myoauth/token/refresh``` с обязательными параметрами:

* ```refresh_token``` - должен совпадать с ```refresh_token```, который был выдан при получении ```access_token``` 
* ```grant_type``` -  необходимое значение - 'refresh_token'

Пример запроса:
http://mysterious-sierra-9325.herokuapp.com/myoauth/token/refresh?grant_type=refresh_token&refresh_token=e37110548f1730c7429d6c75efe192d89af80eb6
Ответ:
```json
{
  "access_token":"66e743492a4ffa9fcea732c3c479c1f278d251ea",
  "expires_in":"120",
  "token_type":"Bearer",
  "refresh_token":"a72d727d34ec2986e4ff4bad7b4c351da35971f6"
}
```

Если неверно указан ```grant_type```:
```json
{
  "error":"invalid_request",
  "error_description":"The request includes an invalid parameter value or includes an invalid parameter value"
}
```

Если неверно указан ```refresh_token```:
```json
{
  "error":"invalid_request",
  "error_description":"Invalid refresh token"
}
```
----------
###Данные
В приложении для данных используются 2 сущности:
  - автомобили ```/cars``` 
  - марки ```/brands```
 
Для получения данных необходимо сделать **GET** запрос с наличием в header'е параметра вида:
```
Authorization: Bearer $access_token 
```
, где $access_token - действительный access token

Если header содержит ошибочный параметр, то будет получен ответ:
``` json
{
  "error":"unauthorized"
}
```

Если действие ```access_token``` истекло, то будет получен ответ:
``` json
{
  "error":"token expired"
}
```

Примеры запросов для получения данных:

Запрос:
http://mysterious-sierra-9325.herokuapp.com/cars/1

Результат:
```json
{ 
  "id": 1, 
  "model": "Impreza WRX", 
  "year": 2003, 
  "brand_id": 3, 
  "color": "Blue" 
}
```
Запрос:
http://mysterious-sierra-9325.herokuapp.com/cars?page=1&per_page=3
Результат:
```json
{
  "current_page":1,
  "per_page":3,
  "total_entries":5,
  "entries":
  [{
	  "id":1,
	  "model":"Impreza WRX",
	  "year":2003,
	  "brand_id":3,
	  "color":"Blue"
    },
    {
	    "id":2,
	    "model":"GT-R",
	    "year":2015,
	    "brand_id":2,
	    "color":"White"
    },
    {
	    "id":3,
	    "model":"320",
	    "year":2001,
	    "brand_id":4,
	    "color":"Black"
    }]
}
```


Запрос:
http://mysterious-sierra-9325.herokuapp.com/brands/1
Результат:
```json
{ 
  "id": 1,
  "name": "Lada",
  "country": "Russia",
  "year": 1950 
}
```

Запрос:
http://mysterious-sierra-9325.herokuapp.com/brands?page=1&per_page=3
Результат:
```json
{
  "current_page":1, 
  "per_page":3,
  "total_entries":4,
  "entries":																	
  [{
    "id":1,
    "name":"Lada",
    "country":"Russia",
    "year":1950
  },
  {
    "id":2,
    "name":"Nissan",
    "country":"Japan",
    "year":1890
  },
  {
    "id":3,
    "name":"Subaru",
    "country":"Japan",
    "year":1930
  }]
}
```
----------
### Примечание
Время жизни ```access_token``` - 2 минуты
Время жизни ```code``` - 10 минут
