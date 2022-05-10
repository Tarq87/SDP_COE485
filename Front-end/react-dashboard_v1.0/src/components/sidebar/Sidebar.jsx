import "./sidebar.css";
import {
  LineStyle,
  PermIdentity,
  Storefront,
  Map,
  Http,
  Schedule,
} from "@material-ui/icons";
import { Link } from "react-router-dom";
import { React, Component } from 'react'

export default class Sidebar extends Component {

  constructor(props) {
    super(props)

    this.state = {
      activeSidebarItem: ['active', '', '', '', '', '', '', '', '', '', '', '', '']
    }
  }
/*
  componentDidMount(){
    this.activeSidebarItem = ['', '', '', '', '', '', '', '', '', '', '', '']
    console.log(this.activeSidebarItem)
  }
*/

  /*
  const [this.activeSidebarItem, activateSidebarItem] = useState(['active', '', '', '', '', '', '', '', '', '', '', '', ''])
  const [index, setIndex] = useState(0)
  */

  render() {
    return (
    <div className="sidebar">
    <div className="sidebarWrapper">
      <div className="sidebarMenu">
        <h3 className="sidebarTitle">Dashboard</h3>
        <ul className="sidebarList">
          <Link to="/" className="link">
            <li className={`sidebarListItem ${this.state.activeSidebarItem[0]}`} id='home' 
            onClick={() => {
            console.log("Home Clicked")
            this.setState({
              activeSidebarItem: ['active', '', '', '', '', '', '', '', '', '', '', '', ''],
            })
            }}> 
              <LineStyle className="sidebarIcon" />
              Home
            </li>
          </Link>
          <Link to="/map" className="link">
            <li className={"sidebarListItem " + this.state.activeSidebarItem[1]} id='map' 
            onClick={() => {
            console.log("Map Clicked")
            this.setState({
              activeSidebarItem: ['', 'active', '', '', '', '', '', '', '', '', '', '', ''],
            })
            }}>
              <Map className="sidebarIcon" />
              Maps
            </li>
          </Link>
          {
            /*
            <Link to="/testingBusesAPI" className="link">
            <li className={"sidebarListItem " + this.state.activeSidebarItem[2]} id='testingBusesAPI' onClick={() => {
            console.log("Testing requestbuses API Clicked")
            this.setState({
              activeSidebarItem: ['', '', 'active', '', '', '', '', '', '', '', '', '', ''],
            })
            }} >
            <button></button>
              <Http className="sidebarIcon" />
              Testing requestbuses API
            </li>
          </Link>
          <Link to="/testingStationsAPI" className="link">
            <li className={"sidebarListItem " + this.state.activeSidebarItem[3]} id='testingStationsAPI' onClick={() => {
            console.log("Testing requeststations API Clicked")
            this.setState({
              activeSidebarItem: ['', '', '', 'active', '', '', '', '', '', '', '', '', ''],
            })
            }} >
              <Http className="sidebarIcon" />
              Testing requeststations API
            </li>
          </Link>

            */
          }

          
          <Link to="/drivers" className="link">
            <li className={"sidebarListItem " + this.state.activeSidebarItem[5]} id='drivers' 
            onClick={() => {
            console.log("Drivers Clicked")
            this.setState({
              activeSidebarItem: ['', '', '', '', '', 'active', '', '', '', '', '', '', ''],
            })
            }}>
              <PermIdentity className="sidebarIcon" />
              Drivers
            </li>
          </Link>
          
          {/*
          <Link to="/products" className="link">
            <li className={"sidebarListItem " + this.state.activeSidebarItem[6]} id='stations' 
            onClick={() => {
            console.log("Stations Analytics Clicked")
            this.setState({
              activeSidebarItem: ['', '', '', '', '', '', 'active', '', '', '', '', '', ''],
            })
            }}>
              <Storefront className="sidebarIcon" />
              Stations Analytics
            </li>
          </Link>
          */
          }

          {
            /*

            <Link to="/testingBusCapacityAPI" className="link">
            <li className={"sidebarListItem " + this.state.activeSidebarItem[7]} id='testingBusCapacityAPI' onClick={() => {
            console.log("testingBusCapacityAPI Clicked")
            this.setState({
              activeSidebarItem: ['', '', '', '', '', '', '', 'active', '', '', '', '', ''],
            })
            }} >
              <Http className="sidebarIcon" />
              Testing Bus capacity API
            </li>
          </Link>
          <Link to="/testingTicketsAPI" className="link">
            <li className={"sidebarListItem " + this.state.activeSidebarItem[8]} id='testingTicketsAPI' onClick={() => {
            console.log("testingTicketsAPI Clicked")
            this.setState({
              activeSidebarItem: ['', '', '', '', '', '', '', '', 'active', '', '', '', ''],
            })
            }} >
              <Http className="sidebarIcon" />
              Testing User Tickets API
            </li>
          </Link>
          <Link to="/testingUsersAPI" className="link">
            <li className={"sidebarListItem " + this.state.activeSidebarItem[9]} id='testingUsersAPI' onClick={() => {
            console.log("testingUsersAPI Clicked")
            this.setState({
              activeSidebarItem: ['', '', '', '', '', '', '', '', '', 'active', '', '', ''],
            })
            }} >
              <Http className="sidebarIcon" />
              Testing Users API
            </li>
          </Link>
          <Link to="/testingImageAPI" className="link">
            <li className={"sidebarListItem " + this.state.activeSidebarItem[10]} id='testingImageAPI' onClick={() => {
            console.log("testingImageAPI Clicked")
            this.setState({
              activeSidebarItem: ['', '', '', '', '', '', '', '', '', '', 'active', '', ''],
            })
            }} >
              <Http className="sidebarIcon" />
              Testing Image 
            </li>
          </Link>

            */
          }

          <Link to="/busSchedule" className="link">
            <li className={"sidebarListItem " + this.state.activeSidebarItem[11]} id='busSchedule' onClick={() => {
            console.log("busSchedule Clicked")
            this.setState({
              activeSidebarItem: ['', '', '', '', '', '', '', '', '', '', '', 'active', ''],
            })
            }} >
              <Schedule className="sidebarIcon" />
              Bus Schedule
            </li>
          </Link>

          <Link to="/tripDemand" className="link">
            <li className={"sidebarListItem " + this.state.activeSidebarItem[12]} id='tripDemand' onClick={() => {
            console.log("tripDemand Clicked")
            this.setState({
              activeSidebarItem: ['', '', '', '', '', '', '', '', '', '', '', '', 'active'],
            })
            }} >
              <Schedule className="sidebarIcon" />
              Trip Demand
            </li>
          </Link>
        </ul>
      </div>
    </div>
  </div>
    )
  }
}
