import React, { Component } from 'react'
import "./testingTicketsAPI.css"
import axios from 'axios'

const userTicketsTest = [
  {
    user_id: 'ammar',
    ticket_id: 'a123 bla bla bla',
    ticket_type: 1
  },
  {
    user_id: 'Amr',
    ticket_id: 'a123 bla bla bla',
    ticket_type: 1
  },
  {
    user_id: 'Tariq',
    ticket_id: 'a123 bla bla bla',
    ticket_type: 1
  },
  {
    user_id: 'Elrabaa',
    ticket_id: 'a123 bla bla bla',
    ticket_type: 1
  },
]

export default class TestingTicketsAPI extends Component {

  constructor(props) {
    super(props)
  
    this.state = {
       userTickets: []
    }
  }

  componentDidMount(){
    axios.get('https://seniordesignproject.azurewebsites.net/gettickets')
    .then(response =>{
      this.setState({
        userTickets: response.data,
      })
      console.log('### user Tickets response from API')
      console.log(response.data)
    }).catch(err => console.log(err))
  }

  render() {
    var userTickets = userTicketsTest;
    return (
      <div className="testingTicketsAPI">
        <h1 className="testingTicketsAPI">Testing REST APIs</h1>
        <br/>
        <br/>
        <h1 className="testingTicketsAPI">User Tickets API</h1><br/>
        <div className="userTickets">
          <h2>Tickets :</h2>
          <ul>
            {
            userTickets.map((userTicket) => {
              return <li key={userTicket.user_id}>{`username: ${userTicket.user_id},\n *** ticket ID: ${userTicket.ticket_id},\n *** ticket type: ${userTicket.ticket_type} persons/ticket\n`}</li>
            })
            }
         </ul>
         <br/>
        </div>
      </div>
    )
  }
}


