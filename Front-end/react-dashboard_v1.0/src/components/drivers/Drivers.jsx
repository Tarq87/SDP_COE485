import React, { Component } from 'react'
import "./drivers.css";
import { DataGrid } from "@material-ui/data-grid";
import { DeleteOutline } from "@material-ui/icons";
import { Link } from "react-router-dom";
import axios from 'axios'

export class Drivers extends Component {

  constructor(props) {
    super(props)
  
    this.state = {
       drivers: []
    }
  }

  componentDidMount(){
    axios.get('https://seniordesignproject.azurewebsites.net/getdrivers')
    .then(response =>{
      this.setState({
        drivers: response.data,
      })
      console.log('### get drivers response from API')
      console.log(response.data)
    }).catch(err => console.log(err))
  }

  render() {
    var driversTmp = this.state.drivers

    const handleDelete = (id) => {
      driversTmp.filter((item) => item.id !== id);
      this.setState({
        drivers: driversTmp
      })
    }
    
    const columns = [
      { field: "id", headerName: "ID", width: 110 },
      { field: "driver_name", headerName: "Driver Name", width: 200 },
      {
        field: "bus_id",
        headerName: "Currently in Bus",
        width: 200,
      },
      {
        field: "action",
        headerName: "Action",
        width: 150,
        renderCell: (params) => {
          return (
            <>
              <Link to={"/driver/" + params.row.id}>
                <button className="driverListEdit">Edit</button>
              </Link>
              <DeleteOutline
                className="driverListDelete"
                onClick={() => handleDelete(params.row.id)}
              />
            </>
          );
        },
      },
    ];

    return (
      <div className="drivers">
        <DataGrid
        rows={driversTmp}
        disableSelectionOnClick
        columns={columns}
        pageSize={8}
        checkboxSelection
      />
      </div>
    )
  }
}

export default Drivers