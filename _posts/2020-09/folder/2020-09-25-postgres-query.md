---
layout: post
tags: database
---

# Пометим запросы/команды чтоб не забыть

## Пометим запросы/команды чтоб не забыть


Воспользовавшись следующими переменными окружения, можно задать значения параметров соединения по умолчанию [см. источник](https://postgrespro.ru/docs/postgrespro/12/libpq-envars)

- `PGHOST` действует так же, как параметр соединения host.
- `PGPORT` действует так же, как параметр соединения port.
- `PGDATABASE` действует так же, как параметр соединения dbname.
- `PGUSER` действует так же, как параметр соединения user.
- `PGPASSWORD` действует так же, как параметр соединения password. 


Выгрузка БД в указаную директорию спец. формате файлами. Самый быстрый и надежный способ бэкапа. Или же выгрузка одной таблицы.

```
pg_dump -v --format=d -j 5 -f "$OUT_DIR" -U $PGUSER -d $PGDATABASE [..$ARGS]
pg_dump -v --format=d -j 5 -f "$OUT_DIR" -U $PGUSER -d $PGDATABASE -t $TABLENAME [..$ARGS]
```

Для востоновления, полное
```
pg_restore -U $PGUSER --format=d -d $PGDATABASE --disable-triggers -v $FILE
# // только данные не создаваяя схем
pg_restore -U $PGUSER --format=d -d $PGDATABASE --disable-triggers -v -a $FILE
# // или для одной таблицы (аналогично)
pg_restore -U $PGUSER --format=d -d $PGDATABASE --disable-triggers -v -t $TABLE $FILE
pg_restore -U $PGUSER --format=d -d $PGDATABASE --disable-triggers -v -a -t $TABLE $FILE
```

Посмотреть какие есть таблицы в директории
```
 pg_restore --list dump-rasprodaga-tables-origin | grep -i 'table data' | awk '{print $7}'
```


### Запросы

Показывает сколько какая таблица занимает на диск. Таблица total_usage показывает итоговый размер с учетом индесов и вакумов
```sql
SELECT
            schemaname||'.'||tablename AS full_tname,
            pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS total_usage,
            pg_size_pretty((pg_total_relation_size(schemaname||'.'||tablename) 
                                - pg_relation_size(schemaname||'.'||tablename))) AS external_table_usage
FROM pg_catalog.pg_tables
WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```
