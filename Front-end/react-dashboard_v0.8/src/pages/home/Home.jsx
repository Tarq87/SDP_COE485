import Chart from "../../components/chart/Chart";
import FeaturedInfo from "../../components/featuredInfo/FeaturedInfo";
import "./home.css";
import WidgetSm from "../../components/widgetSm/WidgetSm";
import WidgetLg from "../../components/widgetLg/WidgetLg";
import CrowdAnalytics from "../../components/crowdAnalytics/CrowdAnalytics";
import axios from 'axios'
import React, { Component } from 'react'

export default class Home extends Component {

  constructor(props) {
    super(props)
  
    this.state = {
       sales: []
    }
  }

  componentDidMount(){
    axios.get('https://seniordesignproject.azurewebsites.net/ticketsales')
    .then(response =>{
      this.setState({
        sales: response.data,
      })
      console.log('### get Ticket Sales response from API')
      console.log(response.data)
    }).catch(err => console.log(err))
  }


  render() {
    var salesTmp = this.state.sales
    return (
      <div className="home">
        {
          /*
            <FeaturedInfo />
            
          */
        }
        <CrowdAnalytics/>
        <Chart data={salesTmp} title="Ticket Sales" grid dataKey="ticket_sales"/>
        
      <div className="homeWidgets">
        <WidgetSm/>
        <WidgetLg/>
      </div>
    </div>
    )
  }
}