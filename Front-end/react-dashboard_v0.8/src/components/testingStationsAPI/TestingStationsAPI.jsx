import React, { Component } from 'react'
import "./testingStationsAPI.css"
import axios from 'axios'

export default class TestingStationsAPI extends Component {

  constructor(props) {
    super(props)
  
    this.state = {
       stationsNames: [],
       stationsLats: [],
       stationsLngs: []
    }
  }

  componentDidMount(){
    axios.get('https://seniordesignproject.azurewebsites.net/requeststations')
    .then(response =>{
      this.setState({
        stationsNames: response.data.name,
        stationsLngs: response.data.longitude,
        stationsLats: response.data.latitude
        
      })
      console.log(response.data)
    }).catch(err => console.log(err))
  }

  render() {
    var stationsNames = this.state.stationsNames;
    var stationsLats = this.state.stationsLats;
    var stationsLngs = this.state.stationsLngs;
    //var {stationsNames} = stations.name
    return (
      <div className="testingStationsAPI">
        <h1 >Testing REST APIs</h1>
        <br/>
        <br/>
        <h1 >requeststations API</h1>
        <div className="stationsNames">
          <h2>Stations Names:</h2>
          <ul>
            {
            stationsNames.map((item, i) => {
              return <li key={i}>{item}</li>
            })
            }
         </ul>
         <br/>
         <h2>Stations longitudes:</h2>
          <ul>
            {
            stationsLngs.map((item, i) => {
              return <li key={i}>{item}</li>
            })
            }
         </ul>
         <br/>
         <h2>Stations latitudes:</h2>
          <ul>
            {
            stationsLats.map((item, i) => {
              return <li key={i}>{item}</li>
            })
            }
         </ul>
        </div>
      </div>
    )
  }
}


