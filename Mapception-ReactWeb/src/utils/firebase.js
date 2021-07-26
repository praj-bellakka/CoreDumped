import firebase from 'firebase';

const firebaseConfig = {
  apiKey: "AIzaSyDP6-Aspk6si6MxQEDzmx8Zt-qxw2I1Dzg",
  authDomain: "mapception-c014b.firebaseapp.com",
  databaseURL: "https://mapception-c014b-default-rtdb.asia-southeast1.firebasedatabase.app",
  projectId: "mapception-c014b",
  storageBucket: "mapception-c014b.appspot.com",
  messagingSenderId: "44291013706",
  appId: "1:44291013706:web:a159cd16d0620f2bb6fab3"
};

firebase.initializeApp(firebaseConfig);

export default firebase;
