import "./crowdAnalytics.css";
import React, { Component } from 'react'
import axios from 'axios'

/*
const imageDataTest = 'iVBORw0KGgoAAAANSUhEUgAAAoAAAAHgCAYAAAA10dzkAABoBklEQVR4nO3dd3hUZfo+8PvMZCY9\nmfRCCoFUSiihBUSkLEVFEHSxLaDo/lYRF5B19btrXRXLYldYFVFXUGEVREVRkSJIkBKaQAiQBul1\n0qaf3x+TGQg1IZOcMzP357pyXWRmcuYhbe685XkFURRFEBEREZHbUEhdABERERF1LQZAIiIiIjfD\nAEhERETkZhgAiYiIiNwMAyARERGRm2EAJCIiInIzDIBEREREboYBkIiIiMjNMAASERERuRkGQCIi\nIiI3wwBIRERE5GYYAImIiIjcDAMgERERkZthACQiIiJyMwyARERERG6GAZCIiIjIzTAAEhEREbkZ\nBkAiIiIiN8MASERERORmGACJiIiI3AwDIBEREZGbYQAkIiIicjMMgERERERuhgGQiIiIyM0wABIR\nERG5GQZAIiIiIjfDAEhERETkZhgAiYiIiNwMAyARERGRm2EAJCIiInIzDIBEREREboYBkIiIiMjN\nMAASERERuRkGQCIiIiI3wwBIRERE5GYYAImIiIjcDAMgERERkZthACQiIiJyMwyARERERG6GAZCI\niIjIzTAAEhEREbkZBkAiIiIiN8MASERERORmGACJiIiI3AwDIBEREZGbYQAkIiIicjMMgERERERu\nhgGQiIiIyM0wABIRERG5GQZAIiIiIjfDAEhERETkZhgAiYiIiNwMAyARERGRm2EAJCIiInIzDIBE\nREREboYBkIiIiMjNeEhdgDOzWCwoLi6Gv78/BEGQuhwiIiJqA1EUUV9fj+joaCgU7jkWxgDYAcXF\nxYiNjZW6DCIiIroKRUVFiImJkboMSTAAdoC/vz8A6zdQQECAxNUQERFRW2i1WsTGxtpfx90RA2AH\n2KZ9AwICGACJiIicjDsv33LPiW8iIiIiN8YASERERORmGACJiIiI3AzXABIRkdsTRREmkwlms1nq\nUsgBlEolPDw83HqN35UwABIRkVszGAwoKSlBU1OT1KWQA/n4+CAqKgpqtVrqUmSJAZCIiNyWxWJB\nXl4elEoloqOjoVarOWrk5ERRhMFgQEVFBfLy8pCUlOS2zZ4vhwGQiIjclsFggMViQWxsLHx8fKQu\nhxzE29sbKpUKBQUFMBgM8PLykrok2WEkJiIit8cRItfDr+nl8bNDRERE5GYYAImIiOiSZs+ejalT\n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\nlJSEhIQEPP7444iOjsbUqVOlK9oFXe7rEBwcjKeffhrTp09HZGQkTp48iUceeQSJiYmYMGGChFW7\nnrlz52LVqlX46quv4O/vb1/XFxgYCG9vbwQGBmLOnDlYuHAhgoODERAQgHnz5iEzMxPDhg2TuHpy\nClJvQ6YLvfnmm2JcXJyoVqvFIUOGiFlZWVKX5FZmzJghRkVFiWq1WuzWrZs4Y8YM8cSJE1KX5fI2\nb94sArjgbdasWaIoWlvBPP7442JERITo6ekpjh07VszJyZG2aBd0ua9DU1OTOH78eDEsLExUqVRi\nfHy8eN9994mlpaVSl+1yLvY1ACCuWLHC/pjm5mbxgQceEIOCgkQfHx/x5ptvFktKSqQrmpyKIIqi\n2PWxk4iIiIikwjWARERERG6GAZCIiIjIzTAAEhEREbkZBkAiIiIiN8MASERERORmGACJiIiI3AwD\nIBEREZGbYQAkIiIicjMMgETkUmbPnn3R4+G2bNkCQRBQW1vb5TUREckNAyARkYMYjUapSyAiahMG\nQCJyS1988QV69+4NT09PdO/eHUuWLGl1vyAIWLduXavbNBoNPvzwQwBAfn4+BEHA559/jlGjRsHL\nywsrV65EQUEBJk+ejKCgIPj6+qJ3797YsGFDF/2viIjaxkPqAoiIutrevXvxxz/+EU899RRmzJiB\nX3/9FQ888ABCQkIwe/bsdl3r0UcfxZIlSzBgwAB4eXnhvvvug8FgwLZt2+Dr64sjR47Az8+vc/4j\nRERXiQGQiFzON998c0HoMpvN9n+/8sorGDt2LB5//HEAQHJyMo4cOYKXX3653QFw/vz5mDZtmv39\nwsJCTJ8+HX379gUA9OjR4yr/F0REnYdTwETkckaPHo39+/e3env//fft9x89ehQjRoxo9TEjRoxA\nbm5uq6DYFoMGDWr1/kMPPYRnn30WI0aMwJNPPomDBw9e/X+EiKiTMAASkcvx9fVFYmJiq7du3bq1\n6xqCIEAUxVa3XWyTh6+vb6v37733Xpw6dQp/+tOfcOjQIQwaNAhvvvlm+/8TRESdiAGQiNxOWloa\nduzY0eq2HTt2IDk5GUqlEgAQFhaGkpIS+/25ubloampq0/VjY2Pxl7/8BV9++SUefvhhvPfee44r\nnojIAbgGkIjczsMPP4zBgwfjX//6F2bMmIGdO3firbfewjvvvGN/zJgxY/DWW28hMzMTZrMZf//7\n36FSqa547fnz52PSpElITk5GTU0NNm/ejLS0tM787xARtRtHAInI7QwcOBCrV6/GZ599hj59+uCJ\nJ57AM88802oDyJIlSxAbG4uRI0fijjvuwKJFi+Dj43PFa5vNZsydOxdpaWmYOHEikpOTWwVLIiI5\nEMTzF7kQERERkUvjCCARERGRm2EAJCIiInIzDIBEREREboYBkIiIiMjNMAASERERuRkGQCIiIiI3\nwwBIRERE5GYYAImIiIjcDAMgERERkZthACQiIiJyMwyARERERG6GAZCIiIjIzfx/NE9jiqgJWP4A\nAAAASUVORK5CYII=\n'

*/

export class CrowdAnalytics extends Component {

  constructor(props) {
    super(props)
  
    this.state = {
       image: ""
    }
  }

  componentDidMount(){
    axios.get('https://crowdsdp.azurewebsites.net/predict/a')
    .then(response =>{
      this.setState({
        image: response.data.ImageBytes,
      })
      console.log('### get users response from API')
      console.log(response.data)
    }).catch(err => console.log(err))
  }
  
  render() {
    var current = new Date(new Date().getTime() + 24 * 60 * 60 * 1000);
  const date = `${current.getDate()}/${current.getMonth()+1}/${current.getFullYear()}`;
    return (
      <div className="featuredItem">
        <span className="featuredTitle">{`Crowd Analytics for a bus station (Dummy Data)`}</span>
        <div className="featuredMoneyContainer">
          <span className="featuredMoney"></span>
          {
            /*
          <span className="featuredMoneyRate">
            <ArrowDownward  className="featuredIcon negative"/>
          </span>
            */
          }

        </div>
        <span className="featuredSub">{date}</span>

        <div className="crowdAnalytics">
        <img alt='' src={`data:image/jpeg;base64,${this.state.image}`}/>
        </div>
      </div>
    )
  }
}

export default CrowdAnalytics