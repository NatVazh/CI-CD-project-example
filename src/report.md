## Part 1. Настройка gitlab-runner

- Поднимем ВМ, установим и зарегистрируем на ней gitlab-runner в docker

```shell
docker run --rm -it \
  -v /srv/gitlab-runner/config:/etc/gitlab-runner \
  gitlab/gitlab-runner:latest \
  register \
  --non-interactive \
  --executor "docker" \
  --docker-image alpine:latest \
  --url "https://git.21-school.ru" \
  --registration-token "GR1348941w5PpxixsanwZ3efJxRiu" \
  --description "docker-runner" \
  --tag-list "docker,linux" \
  --run-untagged="true" \
  --locked="false"
```
![image_1](images/image_1.png)

- Запустим gitlab-runner

```shell
docker run -d --name gitlab-runner --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /srv/gitlab-runner/config:/etc/gitlab-runner \
  gitlab/gitlab-runner:latest
```
![image_2](images/image_2.png)

- Проверим конфиг

```shell
ls -la /srv/gitlab-runner/config/
```
![image_3](images/image_3.png)

```shell
sudo cat /srv/gitlab-runner/config/config.toml
```
![image_4](images/image_4.png)

- Можно проверить логи

```shell
docker logs -f gitlab-runner
```


## Part 2. Сборка

- Сборка прошла успешно, артефакт доступен к загрузке \
![image_5](images/image_5.png)


## Part 3. Тест кодстайла

- После запуска джобы Clang-format нашел и отобразил нарушения кодстайла и зафейлил пайплайн \
![image_6](images/image_6.png) \
![image_7](images/image_7.png)


## Part 4. Integration tests

- Результаты интеграционных тестов можно увидеть в джобе \
![image_8](images/image_8.png)


## Part 5. Deployment stage

- Пайплайн отработал корректно \
![image_8a](images/image_8a.png)

- Проверим логи окончания выполнения джобы \
![image_8b](images/image_8b.png)

- Проверим целевую директорию на второй ВМ до и после запуска пайплайна \
![image_9](images/image_9.png) \
![image_10](images/image_10.png)


## Part 6. Bonus. Notifications

- Создаём бота, отправив `/newbot` в `@BotFather` \
![image_11](images/image_11.png)

- Бот отрабатывает сообщение по каждой джобе пайплайна \
![image_12](images/image_12.png)
