# 🎬 Movie App

Это приложение для поиска фильмов, которое позволяет пользователям находить фильмы, просматривать подробную информацию, рейтинги и жанры, используя API Кинопоиска.

## 🎥 Видео-демонстрация

### Видео общий функционал
[![Movie Search App Demo](https://img.youtube.com/vi/Xaq4JH0iHtY/0.jpg)](https://youtu.be/Xaq4JH0iHtY)

### Видео кеширование
[![Search Feature Demo](https://img.youtube.com/vi/iDCuW58B9MA/0.jpg)](https://youtu.be/iDCuW58B9MA)

### Видео refreshable
[![Movie Detail Demo](https://img.youtube.com/vi/VsZHG15TU1Q/0.jpg)](https://youtu.be/VsZHG15TU1Q)

## 🏗 Архитектура

Проект построен с использованием архитектуры **MVVM** + SwiftUI:

- **Model**: Содержит бизнес-логику и модели данных. Здесь происходит взаимодействие с сетью через API Кинопоиска и сохранение данных в CoreData.
- **ViewModel**: Обрабатывает бизнес-логику и связывает данные из модели с отображением, используя `ObservableObject` и `@Published` свойства.
- **View**: Отображает пользовательский интерфейс и связывается с `ViewModel` с помощью SwiftUI и `@StateObject`.

### Основные компоненты:
- **NetworkService**: Отвечает за выполнение сетевых запросов и обработку ответов от API Кинопоиска.
- **MoviesViewModel / MovieDetailViewModel / SearchViewModel**: `ViewModel` слои для управления логикой и состоянием соответствующих экранов.
- **MoviesView / MovieDetailView / SearchView**: Отображение различных экранов с использованием SwiftUI.
- **Router**: Управляет навигацией между экранами.
- **CoreData**: Используется для кэширования данных, что позволяет отображать информацию о фильмах даже без подключения к интернету.

## ⚙️ Инструкции по обновлению токена

Приложение использует токен API Кинопоиска для выполнения запросов. В случае превышения лимита запросов, необходимо обновить токен:

1. **Получите новый токен**: Напишите боту [@kinopoiskdev_bot](https://t.me/kinopoiskdev_bot) в Telegram и получите новый токен.
2. **Обновите токен в коде**:
   - Откройте проект в Xcode.
   - Перейдите в файл `MoviesService.swift`.
   - Найдите строку с текущим токеном API и замените его на новый:
      APIConstants.apiKey

## 🛠 Использованные технологии

- **SwiftUI** для построения пользовательского интерфейса.
- **MVVM** архитектура для четкого разделения ответственности.
- **Combine** для реактивного программирования.
- **CoreData** для кэширования данных.
- **Kingfisher** для загрузки и кэширования изображений.
   
