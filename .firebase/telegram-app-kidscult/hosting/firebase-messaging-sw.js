importScripts("https://www.gstatic.com/firebasejs/10.12.2/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/10.12.2/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyCtVxKE51wDXG8v6o0iXwuYSGwjOqsA1nM",
  authDomain: "kidscult-a5d7e.firebaseapp.com",
  projectId: "kidscult-a5d7e",
  storageBucket: "kidscult-a5d7e.firebasestorage.app",
  messagingSenderId: "419315761443",
  appId: "1:419315761443:web:e2fc3c88681cde33b78c96",
});

const messaging = firebase.messaging();

// Обработка пушей, когда приложение не открыто
messaging.onBackgroundMessage((payload) => {
  console.log("Получено фоновое сообщение:", payload);
  self.registration.showNotification(payload.notification.title, {
    body: payload.notification.body,
    icon: "/icons/Icon-192.png",
  });
});