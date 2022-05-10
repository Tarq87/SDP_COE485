import Sidebar from "./components/sidebar/Sidebar";
import Topbar from "./components/topbar/Topbar";
import "./App.css";
import Home from "./pages/home/Home";
import Map from "./components/map/Map";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";
import TestingStationsAPI from "./components/testingStationsAPI/TestingStationsAPI";
import TestingBusesAPI from "./components/testingBusesAPI/TestingBusesAPI";
import TestingBusCapacityAPI from "./components/testingBusCapacityAPI/TestingBusCapacityAPI";
import TestingTicketsAPI from "./components/testingTicketsAPI/TestingTicketsAPI";
import TestingUsersAPI from "./components/testingUsersAPI/TestingUsersAPI";
import TestingImageAPI from "./components/testingImageAPI/TestingImageAPI";
import BusSchedule from "./components/busSchedule/BusSchedule";
import TripDemand from "./components/tripDemand/TripDemand";
import Drivers from "./components/drivers/Drivers";
import Driver from "./components/driver/Driver";
import NewDriver from "./components/newDriver/NewDriver";

function App() {
  return (
    <Router>
      <Topbar />
      <div className="container">
        <Sidebar />
        <Switch>
          <Route exact path="/">
            <Home />
          </Route>
          <Route path="/map">
            <Map/>
          </Route>
          <Route path="/testingStationsAPI">
            <TestingStationsAPI/>
          </Route>
          <Route path="/testingBusesAPI">
            <TestingBusesAPI/>
          </Route>
          <Route path="/drivers">
            <Drivers/>
          </Route>
          <Route path="/driver/:driverId">
            <Driver/>
          </Route>
          <Route path="/newDriver">
            <NewDriver/>
          </Route>
          <Route path="/testingBusCapacityAPI">
            <TestingBusCapacityAPI/>
          </Route>
          <Route path="/testingTicketsAPI">
            <TestingTicketsAPI/>
          </Route>
          <Route path="/testingUsersAPI">
            <TestingUsersAPI/>
          </Route>
          <Route path="/testingImageAPI">
            <TestingImageAPI/>
          </Route>
          <Route path="/busSchedule">
            <BusSchedule/>
          </Route>
          <Route path="/tripDemand">
            <TripDemand/>
          </Route>
        </Switch>
      </div>
    </Router>
  );
}

export default App;
