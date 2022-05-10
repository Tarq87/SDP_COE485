import "./widgetSm.css";
// import { Visibility } from "@material-ui/icons";
import React, { Component } from 'react'
import axios from 'axios'

var activeMembersCount = 0

export default class WidgetSm extends Component {

  constructor(props) {
    super(props)
  
    this.state = {
       users: []
    }
  }

  componentDidMount(){
    activeMembersCount = 0
    axios.get('https://seniordesignproject.azurewebsites.net/getusers')
    .then(response =>{
      this.setState({
        users: response.data,
      })
      console.log('### get users response from API')
      console.log(response.data)
      this.state.users.map((user) => {
        return activeMembersCount++
      })
    }).catch(err => console.log(err))
  }

  render() {
    return (
      <div className="widgetSm">
      <span className="widgetSmTitle">Active Members</span>
      <div className="widgetSmListItem">
      <img
                src="https://icons.veryicon.com/png/o/miscellaneous/two-color-webpage-small-icon/user-244.png"
                alt=""
                className="widgetSmImg"
              />
      {

/*      
      users.map((user) => {
              return <li className="widgetSmListItem">
              <img
                src="https://icons.veryicon.com/png/o/miscellaneous/two-color-webpage-small-icon/user-244.png"
                alt=""
                className="widgetSmImg"
              />
              <div className="widgetSmUser">
                <span className="widgetSmUsername">{user.username}</span>
                <span className="widgetSmUserTitle">{user.email}</span>
              </div>
           
                
                button className="widgetSmButton">
                <Visibility className="widgetSmIcon" />
                Display
              </button>
                
            
            </li>
            })
*/            
            }
      <span className="widgetSmUser">{activeMembersCount}</span>
      </div>
      </div>
    )
  }
}
