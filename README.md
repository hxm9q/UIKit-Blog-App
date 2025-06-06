# 📝 Blog App

**Blog App — это iOS-приложение, разработанное на Swift с использованием UIKit, которое позволяет пользователям создавать, просматривать и управлять блог-постами. Приложение реализует систему аутентификации, хранение данных в Firestore и поддержку пользовательских профилей.**

Для хранения данных приложение использует Firestore Database вместо Firestore Storage, а также статус премиум-подписки по умолчанию есть у каждого пользователя для упрощения реализации. (Без Apple Purchases)

---

## 🚀 Особенности

- 🔐 **Аутентификация пользователей через FirebaseAuth**
- 📝 **Создание, чтение и отображение постов**
- 🖼️ **Загрузка и отображение изображений в записях (альтернатива Firebase Storage)**
- 🧑‍💼 **Профиль пользователя с фото и базовой информацией**
- 🗂 **Список всех постов и постов конкретного пользователя**
- 📦 **Локальное кэширование email и имени через `UserDefaults`**
- 🎯 **UI построен на UIKit без использования SwiftUI**
- 📱 **Вёрстка проекта полностью выполнена кодом, без использования storyboard**
- 🔄 **Использует кастомную обертку над Firestore вместо Firebase Storage**
- 🧭 **Навигация с использованием `UINavigationController` и `UITableView`**

---

## 🧰 Технологии

- **Swift**
- **UIKit**
- **Firebase (Authentication, Firestore)**
- **UserDefaults**
- **URLSession (при использовании URL изображений)**
- **MVC-подход**
- **Auto Layout / NSLayoutConstraint**

---

## 📸 Скриншоты

> <img src=Blog%20App/Blog%20App/Images/Screenshots/SignIn.png alt="SignIn" width="300"/>
> <img src=Blog%20App/Blog%20App/Images/Screenshots/SignUp.png alt="SignUp" width="300"/>
> <img src=Blog%20App/Blog%20App/Images/Screenshots/SignUpEmailError.png alt="SignUpEmailError" width="300"/>
> <img src=Blog%20App/Blog%20App/Images/Screenshots/SignUpPassError.png alt="SignUpPassError" width="300"/>
> <img src=Blog%20App/Blog%20App/Images/Screenshots/ProfileView.png alt="ProfileView" width="300"/>
> <img src=Blog%20App/Blog%20App/Images/Screenshots/PremiumView.png alt="PremiumView" width="300"/>
> <img src=Blog%20App/Blog%20App/Images/Screenshots/PostView.png alt="PostView" width="300"/>
> <img src=Blog%20App/Blog%20App/Images/Screenshots/PostCreate.png alt="PostCreate" width="300"/>
> <img src=Blog%20App/Blog%20App/Images/Screenshots/ImagePicker.png alt="ImagePicker" width="300"/>
> <img src=Blog%20App/Blog%20App/Images/Screenshots/PostCreateError.png alt="PostCreateError" width="300"/>
> <img src=Blog%20App/Blog%20App/Images/Screenshots/FirestoreAuth.png alt="FirestoreAuth" width="300"/>
> <img src=Blog%20App/Blog%20App/Images/Screenshots/FirestoreDB.png alt="FirestoreDB" width="300"/>

---

## ❗ Замена Firebase Storage

Так как Firebase Storage не используется (ограничения по тарифу), изображения сохраняются как `Data` в Firestore в виде Base64 строки. Это временное решение, и его можно заменить, если подключить стороннее хранилище.
