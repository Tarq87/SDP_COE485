import "./widgetLg.css";
import React, { Component } from 'react'
import axios from 'axios'


export default class WidgetLg extends Component {

  constructor(props) {
    super(props)
  
    this.state = {
       tickets: []
    }
  }

  componentDidMount(){
    axios.get('https://seniordesignproject.azurewebsites.net/gettickets')
    .then(response =>{
      this.setState({
        tickets: response.data,
      })
      console.log('### get tickets response from API')
      console.log(response.data)
    }).catch(err => console.log(err))
  }

  render() {
    var tickets = this.state.tickets
    return (
      <div className="widgetLg">
      <h3 className="widgetLgTitle">Latest transactions</h3>
      <table className="widgetLgTable">
        <tr className="widgetLgTr">
          {
            /*
<th className="widgetLgTh">Customer</th>
            */
          }
          
          <th className="widgetLgTh">Date</th>
          <th className="widgetLgTh">Ticket ID</th>
          <th className="widgetLgTh">Ticket Type</th>
        </tr>
          {tickets.map((ticket) => {
            return <tr className="widgetLgTr">
              {
                /*
<td className="widgetLgUser">
              <img
                src="https://icons.veryicon.com/png/o/miscellaneous/two-color-webpage-small-icon/user-244.png"
                alt=""
                className="widgetLgImg"
              />
              <span className="widgetLgName">{ticket.user_id}</span>
            </td>
                */
              }
            
            <td className="widgetLgDate">{ticket.Date}</td>
            <td className="widgetLgAmount">{ticket.ticket_id}</td>
            <td className="widgetLgAmount">{ticket.ticket_type}</td>
          </tr>
        })
          }
      </table>
    </div>
    )
  }
}
