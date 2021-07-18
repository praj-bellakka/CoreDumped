import React, {useState} from 'react';
import firebase from '../utils/firebase';


var index = 0;
var mapList = [];



export default function Form() {
	const [name,setName] = useState('');


	const handleOnChange = (e) => {
		setName(e.target.value);
	}

	const addLocation = () => {

		const location = {
			address: name,
			condensedName: name,
			coordinates: '',
			placeId: '',

		}
		mapList[index] = location;
		index++;
	}

	const uploadLocations = () => {
		//let pre = 'User/';
		//let uid = 'xfukae1s4xSSWiHClQDEAMOPrGW2';
		//let path = pre.concat(uid); 
		//console.log(path);
		//const path = "Users/xfukae1s4xSSWiHClQDEAMOPrGW2" //to update UID
		const path = "sendData/xfukae1s4xSSWiHClQDEAMOPrGW2" //to update UID
		const locationRef = firebase.database().ref(path);
		const locationList = {
			mapList
		};
		locationRef.push(locationList);
	}

	const clearLocations = () => {
		index = 0;
		mapList = [];
	}

	return (
		<div>
			<button onClick={addLocation}>Add Location</button>
			<button onClick={clearLocations}>Clear Locations</button>
			<button onClick={uploadLocations}>Upload Locations</button>

		</div>
	);
}