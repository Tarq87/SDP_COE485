import React, { Component } from 'react'
import "./busSchedule.css";
import { DataGrid } from "@material-ui/data-grid";
import { DeleteOutline } from "@material-ui/icons";
import { busSchedule } from "../../dummyData";
import { Link } from "react-router-dom";

export class BusSchedule extends Component {

  constructor(props) {
    super(props)

    this.state = {
      busSchedule: []
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
    this.state.busSchedule = busSchedule
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
      { field: "date", headerName: "Time", width: 200 },
      { field: "Day", headerName: "Day", width: 200 },
      {
        field: "Week No.",
        headerName: "WeeK Number",
        width: 220,
      },      
    ];

    return (
      
        <div className="userList">
          <DataGrid
            rows={this.state.busSchedule}
            disableSelectionOnClick
            columns={columns}
            pageSize={100}
            checkboxSelection
          />
        </div>
      
    )
  }
}

export default BusSchedule