import "./newDriver.css";

export default function NewDriver() {
  return (
    <div className="newDriver">
      <h1 className="newDriverTitle">New Driver</h1>
      <form className="newDriverForm">
        <div className="newDriverItem">
          <label>Drivername</label>
          <input type="text" placeholder="Amro" />
        </div>
        <div className="newDriverItem">
          <label>Full Name</label>
          <input type="text" placeholder="Amro Ghndakji" />
        </div>
        <div className="newDriverItem">
          <label>Email</label>
          <input type="email" placeholder="amergh1997@gmail.com" />
        </div>
        <div className="newDriverItem">
          <label>Password</label>
          <input type="password" placeholder="password" />
        </div>
        <div className="newDriverItem">
          <label>Phone</label>
          <input type="text" placeholder="+966502713970" />
        </div>
        <div className="newDriverItem">
          <label>Address</label>
          <input type="text" placeholder="Dammam | Jalawyiah" />
        </div>
        <div className="newDriverItem">
          <label>Gender</label>
          <div className="newDriverGender">
            <input type="radio" name="gender" id="male" value="male" />
            <label for="male">Male</label>
            <input type="radio" name="gender" id="female" value="female" />
            <label for="female">Female</label>
          </div>
        </div>
        <div className="newDriverItem">
          <label>Active</label>
          <select className="newDriverSelect" name="active" id="active">
            <option value="yes">Yes</option>
            <option value="no">No</option>
          </select>
        </div>
        <button className="newDriverButton">Create</button>
      </form>
    </div>
  );
}
