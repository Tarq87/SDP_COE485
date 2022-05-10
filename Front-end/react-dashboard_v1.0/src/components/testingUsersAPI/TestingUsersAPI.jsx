import "./testingUsersAPI.css"
import React, { Component } from 'react'
import axios from 'axios'

const usersTest = [
  {
    username: 'ammar',
    email: 'ammar@noWhere.go'
  },
  {
    username: 'Amr',
    email: 'Amr@noWhere.go'
  },
  {
    username: 'Felemban',
    email: 'Felemban@noWhere.go'
  },
  {
    username: 'Elrabaa',
    email: 'Elrabaa@noWhere.go'
  }
]

export default class TestingUsersAPI extends Component {

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
    return (
      <div className="testingUsersAPI">
        <h1 className="testingUsersAPI">Testing REST APIs</h1>
        <br/>
        <br/>
        <h1 className="testingUsersAPI">User details API</h1><br/>
        <div className="users">
          <h2>Users :</h2>
          <ul>
            {
            usersTest.map((userTest) => {
              return <li key={userTest.username}>{`username: ${userTest.username},\n *** email: ${userTest.email}`}</li>
            })
            }
         </ul>
         <br/>
        </div>
      </div>
    )
  }
}


