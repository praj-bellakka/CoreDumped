import React, { useState } from 'react';
import './App.css';
import {
  InfoWindow,
  withScriptjs,
  withGoogleMap,
  GoogleMap,
  Marker,
} from "react-google-maps";
import Geocode from "react-geocode";
import { Descriptions } from 'antd';
import AutoComplete from "react-google-autocomplete";
import firebase from './utils/firebase';
import { Button, TextField, Grid, Box } from '@material-ui/core';
import CloudUploadIcon from '@material-ui/icons/CloudUpload';
import ClearAllIcon from '@material-ui/icons/ClearAll';
import AddIcon from '@material-ui/icons/Add';
import PersonIcon from '@material-ui/icons/Person';

import { makeStyles } from '@material-ui/core/styles';

const useStyles = makeStyles((theme) => ({
  root: {
    '& .MuiTextField-root': {
      color: "white",
      backgroundColour: theme.palette.common.white,
    },
  },
}));


//global variables
const apiKey = "AIzaSyBsPi3wA_-SZVURg6_iBq8zz5mxW5UcHNo";
var index = 0;
var mapList = [];
var curr_address = '';
var curr_coordinates = [];
var curr_placeID = '';
var path = '';
var uid = '';
var isUserExist = false;


Geocode.setApiKey(apiKey);

class App extends React.Component {
  state = {
    address: "",
    condensedAddress: "",
    coordinates: [],
    placeId: "",
    zoom: 12,
    height: 400,
    mapPosition: {
      lat: 0,
      lng: 0,
    },
    markerPosition: {
      lat: 0,
      lng: 0,
    }
  }



  componentDidMount() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(position => {
        console.log('position', navigator.geolocation);
        this.setState({
          mapPosition: {
            lat: position.coords.latitude,
            lng: position.coords.longitude,
          },
          markerPosition: {
            lat: position.coords.latitude,
            lng: position.coords.longitude,
          }
        },
          () => {
            Geocode.fromLatLng(position.coords.latitude, position.coords.longitude).then(
              response => {
                console.log('response', response);
                const address = response.results[0].formatted_address;
                const id = response.results[0].place_id;
                const lat = response.results[0].geometry.location.lat;
                const lng = response.results[0].geometry.location.lng;
                const coordinates = [lat, lng];
                curr_address = address;
                curr_coordinates = coordinates;
                curr_placeID = id;



                this.setState({
                  address: (address) ? address : '',
                  condensedAddress: (address) ? address : "",
                  coordinates: (coordinates) ? coordinates : "",
                  placeId: (id) ? id : ""
                })
              },
              error => {
                console.error(error);
              }
            );

          })
      });
    } else {
      console.error("Geolocation is not supported by this browser!");
    }
  };

  onMarkerDragEnd = (event) => {
    let newLat = event.latLng.lat();
    let newLng = event.latLng.lng();

    Geocode.fromLatLng(newLat, newLng).then(response => {
      console.log('response', response);
      const address = response.results[0].formatted_address;
      const id = response.results[0].place_id;
      const lat = response.results[0].geometry.location.lat;
      const lng = response.results[0].geometry.location.lng;
      const coordinates = [lat, lng];


      curr_address = address;
      curr_coordinates = coordinates;
      curr_placeID = id;

      this.setState({
        address: (address) ? address : "",
        condensedAddress: (address) ? address : "",
        coordinates: (coordinates) ? coordinates : "",
        placeId: (id) ? id : "",
        mapPosition: {
          lat: lat,
          lng: lng
        },
        markerPosition: {
          lat: lat,
          lng: lng
        }
      })
    });
  }

  onPlaceSelected = (place) => {
    console.log('place', place);
    const address = place.formatted_address;
    const id = place.place_id;
    const lat = place.geometry.location.lat();
    const lng = place.geometry.location.lng();
    const coordinates = [lat, lng];


    curr_address = address;
    curr_coordinates = coordinates;
    curr_placeID = id;


    this.setState({
      address: (address) ? address : "",
      condensedAddress: (address) ? address : "",
      coordinates: (coordinates) ? coordinates : "",
      placeId: (id) ? id : "",
      mapPosition: {
        lat: lat,
        lng: lng
      },
      markerPosition: {
        lat: lat,
        lng: lng
      }
    })
  };

  addLocation() {
    const location = {
      address: curr_address,
      condensedName: curr_address,
      coordinates: curr_coordinates,
      placeId: curr_placeID,
    }
    mapList[index] = location;
    index = index + 1;
    console.log(index);
  }

  clearLocations = () => {
    index = 0;
    mapList = [];
  }



  uploadLocations = () => {
    var currentPath = path;
    console.log('currentPath', currentPath);
    var numberOfLocations = index;

    if (currentPath) {
      const locationRef = firebase.database().ref(currentPath);
      const dataPacket = {
        mapList,
        numberOfLocations
      };
      locationRef.push(dataPacket);
      this.clearLocations();
      console.log("uploaded");
    }
    else {
      console.log("invalid path");
    }
  }

  render() {
    const MapWithAMarker = withScriptjs(withGoogleMap(props =>
      <GoogleMap
        defaultZoom={11}
        defaultCenter={{ lat: this.state.mapPosition.lat, lng: this.state.mapPosition.lng }}
        className='map'
        style={{ width: '80%' }}

      >
        <Marker
          draggable={true}
          onDragEnd={this.onMarkerDragEnd}
          position={{ lat: this.state.markerPosition.lat, lng: this.state.mapPosition.lng }}
        >
          <InfoWindow>
            <div>{this.state.address}</div>
          </InfoWindow>
        </Marker>
        <AutoComplete
          apiKey={apiKey}
          style={{ width: "100%", height: '40px', paddindLeft: 16, marginTop: 2, marginBottom: '2rem', }}
          onPlaceSelected={this.onPlaceSelected}
          options={{ types: "address", componentRestrictions: { country: "sg" } }}
        />
      </GoogleMap>

    ));

    return (
      <div>
        <Grid container spacing={1} alignItems="center" justifyContent="center" className="grid">
          <Grid item xs={12}>
            <h1 className="title-dashboard">Welcome to MAPCEPTION's dashboard</h1>
          </Grid>
          <Grid item xs={12} >
            <Box position="relative" left="5%">
              <div className="stepOne">
                Step 1: Give a user id of target user
              </div>
            </Box>
          </Grid>
          <Grid item xs={12}><Box position="relative" left="5%" ><EnterUID /></Box></Grid>
          <Grid item xs={12} >
            <Box position="relative" left="5%">
              <br></br>
              <br></br>
              <br></br>
              <div className="stepOne">
                Step 2: Add Locations
              </div>
            </Box>
          </Grid>
          <Grid item xs={6}>
            <Box component="span" position="relative" left="5%" background="white" className="box-map">
              <MapWithAMarker
                googleMapURL="https://maps.googleapis.com/maps/api/js?key=AIzaSyBsPi3wA_-SZVURg6_iBq8zz5mxW5UcHNo&v=3.exp&libraries=geometry,drawing,places"
                loadingElement={<div style={{ height: `100%` }} />}
                containerElement={<div style={{ height: `400px` }} />}
                mapElement={<div style={{ height: `100%` }} />}
                className="map"
              />
              <br></br>
              <br></br>
              <br></br>
            </Box>
          </Grid>

          <Grid item xs={6} alignItems="center">

            <Box component="span" position="relative" right="5%">
              <h3 className="title-current">Current Location Information</h3>
              <Descriptions bordered={true} column={2} size={"small"} className='description-current' style={{ width: '85vh ' }}>
                <Descriptions.Item label="Address" span={2}>{this.state.address}</Descriptions.Item>
                <Descriptions.Item label="Latitude">{this.state.coordinates[0]}</Descriptions.Item>
                <Descriptions.Item label="Longtitude">{this.state.coordinates[1]}</Descriptions.Item>
                <Descriptions.Item label="Place ID" span={2}>{this.state.placeId}</Descriptions.Item>
              </Descriptions>
            </Box>

            <br></br>

            <Box position="relative" left="40%" top="5%"><Button variant="contained" startIcon={<AddIcon />} onClick={this.addLocation} className="button-add">Add Location</Button></Box>
          </Grid>

          <Grid item xs={12} >
            <Box position="relative" left="5%">
              <br></br>
              <br></br>
              <br></br>
              <br></br>
              <br></br>
              <div className="stepOne">
                Step 3: Upload to user
              </div>
            </Box>
          </Grid>



          <Grid item xs={12} >

            <Box position="relative" left="50%">
              <Button variant="contained" startIcon={<CloudUploadIcon />} onClick={this.uploadLocations} >Upload</Button>
              <Button variant="contained" startIcon={<ClearAllIcon />} onClick={this.clearLocations}>Clear All</Button>

            </Box>

          </Grid>
        </Grid>
      </div>

    );
  }
}
export default App;

function EnterUID() {
  const classes = useStyles();

  const [input, setInput] = useState('');

  const handleOnChange = (e) => {
    setInput(e.target.value);
  }

  const handleOnSubmit = (e) => {
    e.preventDefault();
    uid = input;
    let pre = 'sendData/';
    path = pre.concat(uid);
    console.log(path);
    setInput('');
    verification(uid);
  }

  return (
    <div>

      <form onSubmit={handleOnSubmit} className={classes.root}>
        <TextField variant="outlined" label="user id" onChange={handleOnChange} value={input} type="text" size="small" ></TextField>
        <Button variant="contained" startIcon={<PersonIcon />} onClick={handleOnSubmit}>Enter user id</Button>
      </form>
    </div>
  )
}


const verification = (uid) => {
  if (uid === "") {
    isUserExist = false;
    console.log(isUserExist);
    return;
  }
  const pre = "Users/";
  const userPath = pre.concat(uid);
  var ref = firebase.database().ref(userPath);
  ref.once("value").then(function (snapshot) {
    isUserExist = snapshot.exists();
    console.log(isUserExist);
  });
}