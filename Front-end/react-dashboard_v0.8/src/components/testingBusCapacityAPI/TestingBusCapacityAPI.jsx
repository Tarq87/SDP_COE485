import React, { Component } from 'react'
import "./testingBusCapacityAPI.css"
import axios from 'axios'

export default class TestingBusCapacityAPI extends Component {

  constructor(props) {
    super(props)
  
    this.state = {
       busesCapacity: []
    }
  }

  componentDidMount(){
    axios.get('https://seniordesignproject.azurewebsites.net/capacity')
    .then(response =>{
      this.setState({
        busesCapacity: response.data,
      })
      console.log(response.data)
    }).catch(err => console.log(err))
  }

  render() {
    var busesCapacity = this.state.busesCapacity;
    return (
      <div className="testingBusCapacityAPI">
        <h1 className="testingBusCapacityAPI">Testing REST APIs</h1>
        <br/>
        <br/>
        <h1 className="testingBusCapacityAPI">Buses Capacity API</h1><br/>
        <div className="busesCapacity">
          <h2>Buses Capacity:</h2>
          <ul>
            {
            busesCapacity.map((busCapacity) => {
              return <li key={busCapacity.bus_id}>{`Bus ${busCapacity.bus_id} capacity: ${busCapacity.capacity} Passengers`}</li>
            })
            }
         </ul>
         <br/>
        </div>
      </div>
    )
  }
}


