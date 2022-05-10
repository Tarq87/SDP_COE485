import React, { Component } from 'react'
import "./testingBusesAPI.css"
import axios from 'axios'

export default class TestingBusesAPI extends Component {

  constructor(props) {
    super(props)
  
    this.state = {
       buses_id: [],
       busesLats: [],
       busesLngs: []
    }
  }

  componentDidMount(){
    axios.get('https://seniordesignproject.azurewebsites.net/requestbuses')
    .then(response =>{
      this.setState({
        buses_id: response.data.bus_id,
        busesLngs: response.data.longitude,
        busesLats: response.data.latitude
        
      })
      console.log(response.data)
    }).catch(err => console.log(err))
  }

  render() {
    var buses_id = this.state.buses_id;
    var busesLats = this.state.busesLats;
    var busesLngs = this.state.busesLngs;
    return (
      <div className="testingBusesAPI">
        <h1 className="testingBusesAPI">Testing REST APIs</h1>
        <br/>
        <br/>
        <h1 className="testingBusesAPI">requestbuses API</h1>
        <div className="buses_id">
          <h2>buses Names:</h2>
          <ul>
            {
            buses_id.map((item, i) => {
              return <li key={i}>{item}</li>
            })
            }
         </ul>
         <br/>
         <h2>buses longitudes:</h2>
          <ul>
            {
            busesLngs.map((item, i) => {
              return <li key={i}>{item}</li>
            })
            }
         </ul>
         <br/>
         <h2>buses latitudes:</h2>
          <ul>
            {
            busesLats.map((item, i) => {
              return <li key={i}>{item}</li>
            })
            }
         </ul>
        </div>
      </div>
    )
  }
}


