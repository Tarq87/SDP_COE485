import "./widgetSm.css";
// import { Visibility } from "@material-ui/icons";
import React, { Component } from 'react'
import axios from 'axios'

export default class WidgetSm extends Component {

  constructor(props) {
    super(props)
  
    this.state = {
       users: []
    }
  }

  componentDidMount(){
    axios.get('https://seniordesignproject.azurewebsites.net/getusers')
    .then(response =>{
      this.setState({
        users: response.data,
      })
      console.log('### get users response from API')
      console.log(response.data)
    }).catch(err => console.log(err))
  }

  render() {
    var users = this.state.users
    return (
      <div className="widgetSm">
      <span className="widgetSmTitle">Members</span>
      <ul className="widgetSmList">
      {users.map((user) => {
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
              {
                /*
                button className="widgetSmButton">
                <Visibility className="widgetSmIcon" />
                Display
              </button>
                */
              }
            </li>
            })}
        
      </ul>
    </div>
    )
  }
}
