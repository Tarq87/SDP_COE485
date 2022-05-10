import "./featuredInfo.css";
import { TransferWithinAStation, ExitToApp } from "@material-ui/icons";

export default function FeaturedInfo() {
  return (
    <div className="featured">
      <div className="featuredItem">
        <span className="featuredTitle">Bus Stop - Student's resturant - Alemadat </span>
        <span className="featuredSub"> today </span>
        <div className="featuredMoneyContainer">
          <span className="featuredMoney">In:</span>
          <span className="featuredMoneyRate">65 <TransferWithinAStation  className="featuredIcon"/>
          </span>
          <span className="featuredMoney">Out:</span>
          <span className="featuredMoneyRate">
            44 <ExitToApp  className="featuredIcon negative"/>
          </span>
        </div>
        <span className="featuredSub"> last month </span>
        <div className="featuredMoneyContainer">
          <span className="featuredMoney">In:</span>
          <span className="featuredMoneyRate">1305 <TransferWithinAStation  className="featuredIcon"/>
          </span>
          <span className="featuredMoney">Out:</span>
          <span className="featuredMoneyRate">
            1012 <ExitToApp  className="featuredIcon negative"/>
          </span>
        </div>
      </div>
      <div className="featuredItem">
        <span className="featuredTitle">Bus Stop - Building 59 </span>
        <span className="featuredSub"> today </span>
        <div className="featuredMoneyContainer">
          <span className="featuredMoney">In:</span>
          <span className="featuredMoneyRate">72 <TransferWithinAStation  className="featuredIcon"/>
          </span>
          <span className="featuredMoney">Out:</span>
          <span className="featuredMoneyRate">
            61 <ExitToApp  className="featuredIcon negative"/>
          </span>
        </div>
        <span className="featuredSub"> last month </span>
        <div className="featuredMoneyContainer">
          <span className="featuredMoney">In:</span>
          <span className="featuredMoneyRate">600 <TransferWithinAStation  className="featuredIcon"/>
          </span>
          <span className="featuredMoney">Out:</span>
          <span className="featuredMoneyRate">
            780 <ExitToApp  className="featuredIcon negative"/>
          </span>
        </div>
      </div>
      <div className="featuredItem">
        <span className="featuredTitle">Bus Stop - Building 76 </span>
        <span className="featuredSub"> today </span>
        <div className="featuredMoneyContainer">
          <span className="featuredMoney">In:</span>
          <span className="featuredMoneyRate">46 <TransferWithinAStation  className="featuredIcon"/>
          </span>
          <span className="featuredMoney">Out:</span>
          <span className="featuredMoneyRate">
            104 <ExitToApp  className="featuredIcon negative"/>
          </span>
        </div>
        <span className="featuredSub"> last month </span>
        <div className="featuredMoneyContainer">
          <span className="featuredMoney">In:</span>
          <span className="featuredMoneyRate">1023 <TransferWithinAStation  className="featuredIcon"/>
          </span>
          <span className="featuredMoney">Out:</span>
          <span className="featuredMoneyRate">
            1458 <ExitToApp  className="featuredIcon negative"/>
          </span>
        </div>
      </div>
    </div>
  );
}
