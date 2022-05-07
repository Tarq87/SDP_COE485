import React, { Component } from 'react'
import {
  CalendarToday,
  LocationSearching,
  MailOutline,
  PermIdentity,
  PhoneAndroid,
  Publish,
} from "@material-ui/icons";
import { Link } from "react-router-dom";
import "./driver.css";

export class Driver extends Component {

  /*
  constructor(props) {
    super(props)
  
    this.state = {
       driver: []
    }
  }

  componentDidMount(){
    axios.get('https://seniordesignproject.azurewebsites.net/getdrivers')
    .then(response =>{
      this.setState({
        driver: response.data,
      })
      console.log('### get users response from API')
      console.log(response.data)
    }).catch(err => console.log(err))
  }

  */

  render() {
    return (
        <div className="driver">
      <div className="driverTitleContainer">
        <h1 className="driverTitle">Edit driver</h1>
        <Link to="/newdriver">
          <button className="driverAddButton">Create</button>
        </Link>
      </div>
      <div className="driverContainer">
        <div className="driverShow">
          <div className="driverShowTop">
            <img
              src="https://cdn-icons-png.flaticon.com/512/2798/2798177.png"
              alt=""
              className="driverShowImg"
            />
            <div className="driverShowTopTitle">
              <span className="driverShowdrivername">Amro Ghndakji</span>
              <span className="driverShowdriverTitle">Computer Engineer</span>
            </div>
          </div>
          <div className="driverShowBottom">
            <span className="driverShowTitle">Account Details</span>
            <div className="driverShowInfo">
              <PermIdentity className="driverShowIcon" />
              <span className="driverShowInfoTitle">Amr</span>
            </div>
            <div className="driverShowInfo">
              <CalendarToday className="driverShowIcon" />
              <span className="driverShowInfoTitle">10.12.1999</span>
            </div>
            <span className="driverShowTitle">Contact Details</span>
            <div className="driverShowInfo">
              <PhoneAndroid className="driverShowIcon" />
              <span className="driverShowInfoTitle"> 050 000 0000</span>
            </div>
            <div className="driverShowInfo">
              <MailOutline className="driverShowIcon" />
              <span className="driverShowInfoTitle">amergh1997@gmail.com</span>
            </div>
            <div className="driverShowInfo">
              <LocationSearching className="driverShowIcon" />
              <span className="driverShowInfoTitle">DAMMAM | KSA</span>
            </div>
          </div>
        </div>
        <div className="driverUpdate">
          <span className="driverUpdateTitle">Edit</span>
          <form className="driverUpdateForm">
            <div className="driverUpdateLeft">
              <div className="driverUpdateItem">
                <label>drivername</label>
                <input
                  type="text"
                  placeholder="Amr"
                  className="driverUpdateInput"
                />
              </div>
              <div className="driverUpdateItem">
                <label>Full Name</label>
                <input
                  type="text"
                  placeholder="Amro Ghndakji"
                  className="driverUpdateInput"
                />
              </div>
              <div className="driverUpdateItem">
                <label>Email</label>
                <input
                  type="text"
                  placeholder="amergh1997@gmail.com"
                  className="driverUpdateInput"
                />
              </div>
              <div className="driverUpdateItem">
                <label>Phone</label>
                <input
                  type="text"
                  placeholder="050 271 3970"
                  className="driverUpdateInput"
                />
              </div>
              <div className="driverUpdateItem">
                <label>Address</label>
                <input
                  type="text"
                  placeholder="Dammam | Aljalawyiah"
                  className="driverUpdateInput"
                />
              </div>
            </div>
            <div className="driverUpdateRight">
              <div className="driverUpdateUpload">
                <img
                  className="driverUpdateImg"
                  src="https://cdn-icons-png.flaticon.com/512/2798/2798177.png"
                  alt=""
                />
                <label htmlFor="file">
                  <Publish className="driverUpdateIcon" />
                </label>
                <input type="file" id="file" style={{ display: "none" }} />
              </div>
              <button className="driverUpdateButton">Update</button>
            </div>
          </form>
        </div>
      </div>
    </div>
    )
  }
}

export default Driver