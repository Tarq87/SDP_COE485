import Chart from "../../components/chart/Chart";
import FeaturedInfo from "../../components/featuredInfo/FeaturedInfo";
import "./home.css";
import WidgetSm from "../../components/widgetSm/WidgetSm";
import WidgetLg from "../../components/widgetLg/WidgetLg";
import CrowdAnalytics from "../../components/crowdAnalytics/CrowdAnalytics";
import axios from 'axios'
import React, { Component } from 'react'
import { RealCrowdAnalytics } from "../../components/realCrowdAnalytics/RealCrowdAnalytics";
import PurchaseChart from "../../components/purchaseChart/PurchaseChart";

export default class Home extends Component {

  constructor(props) {
    super(props)
  
    this.state = {
       usedTickets: [],
       purchasedTickets: [],
    }
  }

  componentDidMount(){
    axios.get('https://seniordesignproject.azurewebsites.net/ticketsales')
    .then(response =>{
      this.setState({
        usedTickets: response.data,
      })
      console.log('### get Used tickets response from API')
      console.log(response.data)
    }).catch(err => console.log(err))

    axios.get('https://seniordesignproject.azurewebsites.net/ticketpurchase')
    .then(response =>{
      this.setState({
        purchasedTickets: response.data,
      })
      console.log('### get Purchased tickets response from API')
      console.log(response.data)
    }).catch(err => console.log(err))

  }


  render() {
    var usedTicketsTmp = this.state.usedTickets
    var purchasedTicketsTmp = this.state.purchasedTickets
    return (
      <div className="home">
        <div className="homeWidgets">
        <WidgetSm/>
        <WidgetLg/>
      </div>
        <FeaturedInfo />
        <PurchaseChart data={purchasedTicketsTmp} title="Purchased Ticket" grid dataKey="ticket_purchase"/>
        <Chart data={usedTicketsTmp} title="Used Ticket" grid dataKey="ticket_sales"/>
        <CrowdAnalytics/>
        <RealCrowdAnalytics/>
    </div>
    )
  }
}