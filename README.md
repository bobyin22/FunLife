<h1 align="center">翻Life (FunLife) </h1>

<p align="center">
<img src="https://github.com/bobyin22/FunLife/blob/main/FunLife/ScreenShot/FunLife.png?raw=true" width="300" height="300"/>
</p>
<p align="center">
    <img src="https://img.shields.io/badge/platform-iOS-lightgray">
    <img src="https://img.shields.io/badge/release-v1.1.0-green">
    <img src="https://img.shields.io/badge/license-MIT-blue">
</p>

<p align="center">
    <a href="https://apps.apple.com/tw/app/funlife/id6450445182">
    <img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg"></a>
</p>

## About 簡介

<h4 align="center">Discover a whole new level of focus with ease! Our Pomodoro Timer feature allows you to concentrate effortlessly by flipping your phone, breaking free from phone addiction. Stay connected and inspired with our Group Feature, connecting you with friends anytime, anywhere. Together, let's become the best version of ourselves!<br>
  <br>
  從來沒有想過專注力可以這麼容易，透過翻蓋手機進行專注，徹底隔絕手機成癮<br>
  社群教室讓我們隨時隨地可以與朋友連線，互相激勵，成為最好的自己
  </p>
<br>

## How To Use App 如何使用

- Enable screen lock. App can notify user with a vibration when the phone is flipped, then start the countdown.
- 打開螢幕鎖定，翻蓋時震動通知使用者，開始讀秒

<image src="https://github.com/bobyin22/FunLife/blob/main/FunLife/ScreenShot/HowToUseAppIntro.gif" width="220"/><image src="https://github.com/bobyin22/FunLife/blob/main/FunLife/ScreenShot/HowToUseAppIntro2.gif" width="220"/>

## Features 功能

### Timer 計時頁

- Countdown Timer feature, starting the timer by flipping the phone face-down, completely isolating phone distractions, initiating focused countdown, helping you make the most of your time and enhance work efficiency.
- 倒數計時功能，透過翻轉手機背面開始計時，翻轉手機背面，徹底隔絕手機誘惑，開始專注倒數計時，幫助您有效利用時間並提高工作效率。

### AddTask 添加任務頁

- Add tasks and display them on the timer page.
- 添加任務並把任務顯示在計時頁面

### DayTask 今日任務頁

- Display today's tasks and allow users to delete or switch between any task.
- 顯示今日任務並且可刪除、切換任一任務
<p align="center">
<img src="https://github.com/bobyin22/FunLife/blob/main/FunLife/ScreenShot/Group%201.png"/>
</p>

### Calendar 每日專注日曆

- 輕鬆瀏覽日曆介面，隨時查看今天的總專注時數以及過去時段的累積時數。讓您更了解自己的時間使用情況，以便做出更明智的時間管理決策。
- Easily navigate the calendar interface to view today's total focused hours and cumulative hours from past periods. This enables you to gain a better understanding of your time usage, allowing you to make more informed decisions for effective time management.

### Group 群組教室頁

- Stay focused together with friends and track each other's focused hours through the group feature. You can share your dedicated time with your friends, encourage each other, and stay motivated to grow and progress together.
- 與好友一同專注，透過群組功能追蹤彼此的專注時數。您可以與朋友分享您的專注時間，相互鼓勵並保持動力，共同成長和進步

### Profile 個人頁面

- Create your unique personal page, showcasing your exclusive style and personality. Customize your page to make it more distinctive and appealing, enhancing your user experience with a personalized and enjoyable touch.
- 打造您獨一無二的個人專屬頁面，將專屬的風格和個性展現於您的專頁，使其更具個性和吸引力，這個功能讓您的使用體驗更加個性化和愉悅

<p align="center">
<img src="https://github.com/bobyin22/FunLife/blob/main/FunLife/ScreenShot/Group%202.png"/>
</p>

## Technical Highlights 使用技術

- Utilized the `UIDevice API` to detect phone flipping for implementing the Pomodoro Timer functionality.
- Import the third-party library `FSCalendar` switch between different days and achieve timing functionality through DateComponent and DateFormatter.
- Incorporated `NotificationCenter` to constantly monitor the phone's orientation, triggering corresponding timing and pause actions when the status changes.
- Developed a `Widget` feature for the app, enhancing the user experience with photo and text components.
- Designed the app's data structure and utilized Firebase to store user data by using `Firebase Firestore` and converting user photos into URLs stored in `Firebase Storage`.
- Implemented `URL scheme` to enable different users to navigate back to the app from other applications. Interacted with Firebase to facilitate group joining functionality for different users.
- Used `UIImagePickerController` to allow users to pick photos from their phone's gallery or take pictures with the camera. Employed `Git Flow` for version control during development.
- Implemented UI `AutoLayout` programmatically.
- Completed the entire project independently, from conceptualization, schedule planning, and interface design, to coding, and successfully published it on the App Store.

## Libraries 第三方套件

- Firebase
- FSCalendar
- SwiftLint
- Kingfisher
- IQKeyboardManagerSwift

## Requirement 需求

- Xcode 14.0
- iOS 15.0

## ReleaseNotes 版本

| Version | Date       | Description                      |
| :------ | :--------- | :------------------------------- |
| 1.1     | 2023.07.28 | New UI and optimized performance |
| 1.0     | 2023.07.14 | Release in App Store             |

## Contact 聯絡方式

尹周舶 Chou Po Yin <br>

- Email: bobyin22@gmail.com <br>
- LinkedIn: https://www.linkedin.com/in/chou-po-yin/
