# Brunch with Brogrammers :facepunch:
This is a fork of the awesome Ember skeleton [Tapas with Ember](https://gemnasium.com/mutewinter/tapas-with-ember),
that has been transformed for our needs.

Our inital thoughts were:
  - Use only JavaScript-based tools. We have replaced original deploy script (ruby-based) with DIY cake task that uses `rsync`.
  - Use `emblem.js` as the main template language.
  - Simplify development process as much as possible

# По-русски
Привет, братишка!

Brunch with Brogrammers — это скелетон, созданный для настоящих брограммеров, которые пишут веб-приложения на Ember.js, используя только хипста-бро-инструментарий: CoffeeScript, Emblem, Stylus. Наша задача — применять только средства, которые можно поставить через NPM (бро, мы как и ты любим Руби, но давай не в этот раз!).

## Подготовка
 -  Поставить node.js
 -  Установить глобальные пакеты (нам это пригодится, доверься мне):
```
npm install -g brunch grunt-cli bower
```

## Быстрый старт
 - Можно просто склонировать этот репозиторий. Не забудь поменять remotes!
```
git clone https://github.com/Hatlam/brunch-with-brogrammers broplication
```
 - Ставим пакеты:
```
cd broplication/
npm install
bower install
```

## Разработка
Запускаем и начинаем кодить:
```
grunt serve
```
Теперь у тебя есть development веб-сервер на порту 3333, который будет автоматически перезагружать страницу при изменении исходников. Live reload, bitch!

## Продакшн
Бро, ну мы конечно знаем, что ты пишешь серьезные вещи, поэтому собрать все готовое для деплоя можешь командой:
```
grunt build
```
Готовый для деплоя на МКС продукт лежит в папке `public`

## Деплой
Деплоить можно через rsync. Забивай настройки сервера в `Gruntfile.coffee` и вперед:
```
grunt deploy
```

