# 🎧 Spotify Clone

A **full-stack music streaming app** inspired by Spotify, built using modern technologies like **Flutter**, **Spring Boot**, **PostgreSQL**, **Redis**, **Hive**, **Riverpod**, and **JWT Authentication**. The app supports real-time music features, offline access, caching, and secure login functionality.

---

## 🛠️ Tech Stack

### 🎯 Frontend (Flutter)

- **Flutter**: Cross-platform mobile development framework.
- **MVVM Architecture**: Clean separation between business logic, state, and UI.
- **Riverpod**: Powerful state management and dependency injection.
- **Hive**: Local storage for offline songs and cached user data.
- **Http**: For making HTTP requests to backend APIs.
- **JWT**: Used for secure token-based authentication.
- **Audio Player**: For local and streaming playback.

### 🔧 Backend (Spring Boot)

- **Spring Boot**: RESTful API development.
- **Spring Security + JWT**: For stateless authentication and user authorization.
- **Redis**: In-memory cache to optimize performance.
- **PostgreSQL**: Relational database to store all persistent data.
- **Cloudinary (or Local Storage)**: To manage and serve audio/media files.

---

### Frontend: MVVM (Model-View-ViewModel)

The Flutter frontend follows the **MVVM** architecture to ensure separation of concerns and better testability.

**Why MVVM?**

- 🧠 ViewModel handles business logic (separation of concerns)
- ♻️ Riverpod enables reactive UI by watching ViewModel state
- 💾 Repository abstracts data source (API/Local)

---

## 📱 Core Features

### ✅ User Experience

- 🔐 JWT-based login & signup
- ❤️ Like and unlike songs
- ⏯️ Local audio playback
- 🕒 Recently played and favorites
- 🗂 Create & manage playlists

### ✅ Backend Services

- 🧠 Redis cache for liked songs and trending lists
- 🧾 JWT-secured API endpoints
- 📁 Song/media upload and streaming
- 📊 API logging and error handling

---

## 🧠 Redis Caching

Redis is used to:

- Cache liked songs for faster access
- Store trending or recently played songs
- Reduce repeated DB queries for frequently accessed data

This drastically improves **performance** and **response time** for user-facing APIs.

---

## 🔐 JWT Authentication

- Login and signup return a secure JWT token
- Token is stored in Hive on the client side
- Every protected API requires the JWT token in the `Authorization` header
- Token expiration and refresh handled at the backend level

---

## 🚀 Future Enhancements

- 🔍 Full-text song & artist search
- 🔁 Repeat/shuffle playback
- 🌐 Music streaming instead of local play
- 👤 Social features: follow users, share playlists
- 🧠 AI-based song recommendations
- 📊 Admin dashboard for uploads and analytics

---

## 👨‍💻 Author

**Meet Bhuva**  
If you're passionate about Flutter, Spring Boot, or full-stack development —  
📬 Connect on [LinkedIn](https://www.linkedin.com/in/meet-bhuva-75a996333)

> 💬 _Feel free to reach out if you want to learn or discuss anything related to this project!_

---

## 🏷 Hashtags

`#Flutter` `#SpringBoot` `#PostgreSQL` `#Redis` `#Hive` `#Riverpod` `#JWT` `#MVVM` `#MobileDevelopment` `#BackendEngineering` `#FullStackDevelopment` `#SpotifyClone`
