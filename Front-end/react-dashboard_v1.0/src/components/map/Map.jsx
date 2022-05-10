import {
  Box,
  Button,
  ButtonGroup,
  Flex,
  HStack,
  IconButton,
  Input,
  SkeletonText,
  Text,
} from '@chakra-ui/react'
import { FaLocationArrow, FaTimes } from 'react-icons/fa'

import {
  useJsApiLoader,
  GoogleMap,
  Marker,
  Autocomplete,
  DirectionsRenderer,
  InfoWindow,
} from '@react-google-maps/api'
import { useRef, useState, useEffect } from 'react'
import axios from 'axios'

 const center = { lat: 26.31412, lng: 50.14532 }

/*
const markers = [
  {
    id: 1,
    name: "Chicago, Illinois",
    position: { lat: 41.881832, lng: -87.623177 }
  },
  {
    id: 2,
    name: "Denver, Colorado",
    position: { lat: 39.739235, lng: -104.99025 }
  },
  {
    id: 3,
    name: "Los Angeles, California",
    position: { lat: 34.052235, lng: -118.243683 }
  },
  {
    id: 4,
    name: "New York, New York",
    position: { lat: 40.712776, lng: -74.005974 }
  }
]
*/

/*
const stationMarkers = [ // Just an example this should probably be in your state or props.
 // double _s1Latitude = 26.31319, _s1Longitude = 50.14827;
  // double _s2Latitude = 26.30500, _s2Longitude = 50.14757;
  // double _s3Latitude = 26.31463, _s3Longitude = 50.13977;
  {
    id: 1,
    name: "Station1",
    position: { lat: 26.31319, lng: 50.14827 }
  },
  {
    id: 2,
    name: "Station2",
    position: { lat: 26.30500, lng: 50.14757 }
  },
  {
    id: 3,
    name: "Station3",
    position: { lat: 26.31463, lng: 50.13977 }
  }
];

*/

var stationNames = []
var stationLats = []
var stationLngs = []

var buses_id = []
var busesLats = []
var busesLngs = []

 //var stationMarkers = []
 //var busesMarkers = []
 var allMarkers = []

 //var requestCounter = 0

 var busesCapacityObjects = []
 var busesCapacity_id = []
 var busesCapacity = []

export default function Map() {
  const [isLoading, setLoading] = useState(true);

  const { isLoaded } = useJsApiLoader({
    googleMapsApiKey: process.env.REACT_APP_GOOGLE_MAPS_API_KEY,
    libraries: ['places'],
  })

  // For GoogleMaps
  const [activeMarker, setActiveMarker] = useState(null);
/*
  // For retrieving stations
  const [stationNames, setStationNames] = useState([])
  const [stationLats, setStationLats] = useState([])
  const [stationLngs, setStationLngs] = useState([])

  // For retrieving Buses
  const [buses_id, setBuses_id] = useState([])
  const [busesLats, setBusesLats] = useState([])
  const [busesLngs, setBusesLngs] = useState([])
*/

  useEffect(() => {
    // requesting statinos
    axios.get('https://seniordesignproject.azurewebsites.net/requeststations')
    .then(response =>{
      stationNames =  response.data.name
      stationLngs = response.data.longitude
      stationLats = response.data.latitude
      console.log(response.data)
    }).catch(err => console.log(err))
    // requesting buses
    axios.get('https://seniordesignproject.azurewebsites.net/requestbuses')
    .then(response =>{
      buses_id =  response.data.bus_id
      busesLngs = response.data.longitude
      busesLats = response.data.latitude
      console.log(response.data)
    }).catch(err => console.log(err))

    axios.get('https://seniordesignproject.azurewebsites.net/capacity')
    .then(response =>{
      busesCapacityObjects = response.data 
      console.log(response.data)
      setTimeout(() => {
        setLoading(false)
     }, 500)
    }).catch(err => console.log(err))
  }, []);


  const [map, setMap] = useState(/** @type google.maps.Map */ (null))
  const [directionsResponse, setDirectionsResponse] = useState(null)
  const [distance, setDistance] = useState('')
  const [duration, setDuration] = useState('')

  const[isOrigin, setIsOrigin] = useState(true)

  //const[areBusesUpdated, setBusesupdated] = useState(false)

  const handleActiveMarker = (id, name) => {
    if (id === activeMarker) {
      return;
    }
    setActiveMarker(id);
    if(isOrigin){
      setIsOrigin(false)
      originRef.current.value = name
    }else{
      setIsOrigin(true)
      destiantionRef.current.value = name
    }
     
  }

   const handleOnLoad = (map) => {
      setMap(map)
      const bounds = new window.google.maps.LatLngBounds();
      allMarkers.forEach(({ position }) => bounds.extend(position));
      //busesMarkers.forEach(({ position }) => bounds.extend(position));
      map.fitBounds(bounds);

/*
      setTimeout(() => {
        
      }, 5000)
      console.log('### First Time Triggering Buses Request ###')
      triggerRequest()
*/
  }

/*
  const triggerRequest = () => {
    requestCounter = requestCounter +1
    while(!areBusesUpdated){
    axios.get('https://seniordesignproject.azurewebsites.net/requestbuses')
    .then(response =>{
      buses_id =  response.data.bus_id
      busesLngs = response.data.longitude
      busesLats = response.data.latitude
      console.log(response.data)
      setBusesupdated(true)
    }).catch(err => {
      setBusesupdated(true)
      console.log(err)})
    }
    createMarkerObject()
    console.log(`>>> Buses Update Number ${requestCounter}: \n${allMarkers}`)
    triggerTimer()
  }

  const triggerTimer = () => {
    setTimeout(() => {
      setBusesupdated(false)
    }, 5000)
    triggerRequest()
  }
*/

/*
  const [markers, setMarkers] = useState([ // Just an example this should probably be in your state or props.
  // double _s1Latitude = 26.31319, _s1Longitude = 50.14827;
   // double _s2Latitude = 26.30500, _s2Longitude = 50.14757;
   // double _s3Latitude = 26.31463, _s3Longitude = 50.13977;
   {
     name: "marker1",
     position: { lat: 26.31319, lng: 50.14827 }
   },
   {
     name: "marker2",
     position: { lat: 26.30500, lng: 50.14757 }
   },
   {
     name: "marker3",
     position: { lat: 26.31463, lng: 50.13977 }
   }
 ])
 */

  /** @type React.MutableRefObject<HTMLInputElement> */
  const originRef = useRef()
  /** @type React.MutableRefObject<HTMLInputElement> */
  const destiantionRef = useRef()

  if (!isLoaded || isLoading || (buses_id.length === 0) || (busesLats.length === 0) || (busesLngs.length === 0) || (stationNames.length === 0) || (stationLats.length === 0) || (stationLngs.length === 0)) {
    return <SkeletonText />
  }

  console.log('### Station Names, Lats, Lngs ###')

  console.log(stationNames)
  console.log(stationLats)
  console.log(stationLngs)

  console.log('### Buse IDs, Lats, Lngs ###')

  console.log(buses_id)
  console.log(busesLats)
  console.log(busesLngs)

  setTimeout(() => {
    
  }, 500)
  
  createMarkerObject()

  setTimeout(() => {
    
 }, 500)

  async function calculateRoute() {
    if (originRef.current.value === '' || destiantionRef.current.value === '') {
      return
    }

    var stationOriginMatch = false
    var stationDestinationMatch = false
    var busOriginMatch = false
    var busDestinationMatch = false
    var originPosition = { lat: 26.31412, lng: 50.14532 }
    var destinationPosition = { lat: 26.31412, lng: 50.14532 }

    for(var i =0; i < stationNames.length; i++){
      if( (stationNames[i] === originRef.current.value)){
        originPosition = {lat: stationLats[i], lng: stationLngs[i]}
        stationOriginMatch = true
      }else if( (i < buses_id.length) && (buses_id[i] === originRef.current.value) ){
        originPosition = {lat: busesLats[i], lng: busesLngs[i]}
        busOriginMatch = true
      }
      
      if( (stationNames[i] === destiantionRef.current.value) ){
        destinationPosition = {lat: stationLats[i], lng: stationLngs[i]}
        stationDestinationMatch = true
      }else if( (i < buses_id.length) && (buses_id[i] === destiantionRef.current.value) ){
        destinationPosition = {lat: busesLats[i], lng: busesLngs[i]}
        busDestinationMatch = true
      }
    }

    if( (stationOriginMatch || busOriginMatch) && (stationDestinationMatch || busDestinationMatch) ){
    const directionsService = new window.google.maps.DirectionsService()
    const results = await directionsService.route({
      origin: originPosition,
      destination: destinationPosition,
      // eslint-disable-next-line no-undef
      travelMode: google.maps.TravelMode.DRIVING,
    })
    setDirectionsResponse(results)
    setDistance(results.routes[0].legs[0].distance.text)
    setDuration(results.routes[0].legs[0].duration.text)
    }else{
      // eslint-disable-next-line no-undef
    const directionsService = new google.maps.DirectionsService()
    const results = await directionsService.route({
      origin: originRef.current.value,
      destination: destiantionRef.current.value,
      // eslint-disable-next-line no-undef
      travelMode: google.maps.TravelMode.DRIVING,
    })
    setDirectionsResponse(results)
    setDistance(results.routes[0].legs[0].distance.text)
    setDuration(results.routes[0].legs[0].duration.text)
    }
  }

  function clearRoute() {
    setDirectionsResponse(null)
    setDistance('')
    setDuration('')
    originRef.current.value = ''
    destiantionRef.current.value = ''
  }

  function createMarkerObject(){
    busesCapacity_id = busesCapacityObjects.map(obj => obj.bus_id)
    busesCapacity = busesCapacityObjects.map(obj => obj.capacity)

    console.log(`### Buses IDs and their corresponding capacities ###`)
    console.log(busesCapacity_id)
    console.log(busesCapacity)

    var stationIcon = new window.google.maps.MarkerImage(
      "https://cdn-icons-png.flaticon.com/512/1042/1042263.png",
      null,
      null, 
      null, 
      new window.google.maps.Size(64, 64)
    )

    var busesIcon = new window.google.maps.MarkerImage(
      "https://cdn-icons-png.flaticon.com/512/6395/6395324.png",
      null,
      null, 
      null, 
      new window.google.maps.Size(64, 64)
    )
    var j = (stationNames.length + buses_id.length)
    var i = 0
    var tmpObj = {}

    for (; i < stationNames.length; i++){
      var tmpStationCapacity = ''
      tmpObj = {
        id: (i+1),
        name: stationNames[i],
        position: { lat: stationLats[i], lng: stationLngs[i] },
        icon: stationIcon,
        capacity: tmpStationCapacity
      }
      //stationMarkers[i] = tmpObj
      allMarkers[i] = tmpObj
      tmpObj = {}
    }

    var k =0
    
    for (; i < j ; i++){
      var tmpBusCapacity = ''
      for(var t = 0; t < busesCapacity_id.length; t++){
        if(busesCapacity_id[t] === buses_id[k]){
          tmpBusCapacity = `Capacity: ${busesCapacity[t]}`
        }
      }

      tmpObj = {
        id: (i+1),
        name: buses_id[k],
        position: { lat: busesLats[k], lng: busesLngs[k] },
        icon: busesIcon,
        capacity: tmpBusCapacity // string containg the bus capacity
      }
      allMarkers[i] = tmpObj
      tmpObj = {}
      k++
    }
    //allMarkers = [...stationMarkers, ...busesMarkers]
    //console.log(stationMarkers)
    //console.log(busesMarkers)
    console.log(allMarkers)
  }
    
/*
  function createBusesMarkerObjects(){
    for(var i =0; i <  buses_id.length; i++){
      var tmpObj = {
        id: (i+1),
        name: buses_id[i],
        position: { lat: busesLats[i], lng: busesLngs[i] },
        icon: busesIcon
      }
      busesMarkers[i] = tmpObj
    }
    allMarkers = [...stationMarkers, ...busesMarkers]
    console.log(busesMarkers)
    console.log(`#### All Markers ####\n${busesMarkers}`)
  }
*/



  return (
    <div className="map">
      <Flex
      position='relative'
      flexDirection='column'
      alignItems='center'
      h='100vh'
      w='100vw'
    >
      <Box position='absolute' left={0} top={0} h='100%' w='100%'>
        {/* Google Map Box */}
        <GoogleMap
          onLoad={handleOnLoad}
          onClick={() => setActiveMarker(null)}
          center={center}
          zoom={15}
          mapContainerStyle={{ width: '100%', height: '100%' }}
          options={{
            zoomControl: true,
            streetViewControl: false,
            mapTypeControl: true,
            fullscreenControl: true,
          }}
        >
{/*
          {
          stationMarkers.map(({ id, name, position }) => (
        <Marker
          icon={stationIcon}
          key={id}
          position={position}
          onClick={() => handleActiveMarker(id)}
        >
          {activeMarker === id ? (
            <InfoWindow onCloseClick={() => setActiveMarker(null)}>
              <div>{name}</div>
            </InfoWindow>
          ) : null}
        </Marker>
      ))}
          */}

        {
          allMarkers.map(({ id, name, position, icon, capacity}) => (
        <Marker
          icon={icon}
          key={id}
          position={position}
          onClick={() => handleActiveMarker(id, name)}
        >
          {activeMarker === id ? (
            <InfoWindow onCloseClick={() => setActiveMarker(null)}>
              <div>{`${name}\n${capacity}`}</div>
            </InfoWindow>
          ) : null}
        </Marker>
      ))
      }

      {directionsResponse && (
            <DirectionsRenderer directions={directionsResponse} />
          )}
        </GoogleMap>
      </Box>
      <Box
        p={4}
        borderRadius='lg'
        m={4}
        bgColor='white'
        shadow='base'
        minW='container.md'
        zIndex='1'
      >
        <HStack spacing={2} justifyContent='space-between'>
          <Box flexGrow={1}>
            <Autocomplete>
              <Input type='text' placeholder='Origin' ref={originRef} />
            </Autocomplete>
          </Box>
          <Box flexGrow={1}>
            <Autocomplete>
              <Input
                type='text'
                placeholder='Destination'
                ref={destiantionRef}
              />
            </Autocomplete>
          </Box>

          <ButtonGroup>
            <Button colorScheme='pink' type='submit' onClick={calculateRoute}>
              Calculate Route
            </Button>
            <IconButton
              aria-label='center back'
              icon={<FaTimes />}
              onClick={clearRoute}
            />
          </ButtonGroup>
        </HStack>
        <HStack spacing={4} mt={4} justifyContent='space-between'>
          <Text>Distance: {distance} </Text>
          <Text>Duration: {duration} </Text>
          <IconButton
            aria-label='center back'
            icon={<FaLocationArrow />}
            isRound
            onClick={() => {
              map.panTo(center)
              map.setZoom(15)
            }}
          />
        </HStack>
      </Box>
    </Flex>
    </div>
  )
}
