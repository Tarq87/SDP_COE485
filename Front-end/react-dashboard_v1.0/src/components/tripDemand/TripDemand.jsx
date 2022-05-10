import React, { Component } from 'react'
import "./tripDemand.css";
import { DataGrid } from "@material-ui/data-grid";
import { tripDemand } from "../../dummyData";

export class TripDemand extends Component {

  constructor(props) {
    super(props)

    this.state = {
      tripDemand: []
    }
  }

  componentDidMount(){
    /*
    axios.get('https://seniordesignproject.azurewebsites.net/getusers')
    .then(response =>{
      this.setState({
        users: response.data,
      })
      console.log('### get users response from API')
      console.log(response.data)
    }).catch(err => console.log(err))
    */
    
  }

  render() {
    this.state.tripDemand = tripDemand
    const columns = [
      { field: "id", headerName: "Ride ID", width: 120 },
      {
        field: "travel_from",
        headerName: "Travel From Station",
        width: 200,
        /*
        renderCell: (params) => {
          return (
            <div className="userListUser">
              <img className="userListImg" src={params.row.avatar} alt="" />
              {params.row.username}
            </div>
          );
        },
        */
      },
      { field: "date", headerName: "Date", width: 200 },
      {
        field: "number_of_passengers",
        headerName: "Number Of Passengers",
        width: 220,
      },      
    ];

    return (
      
        <div className="userList">
          <DataGrid
            rows={this.state.tripDemand}
            disableSelectionOnClick
            columns={columns}
            pageSize={100}
            checkboxSelection
          />
        </div>
      
    )
  }
}

export default TripDemand